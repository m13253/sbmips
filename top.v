/*
  sbmips
  Copyright (C) 2017  StarBrilliant <m13253@hotmail.com>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

`timescale 1ns / 1ps
`default_nettype none

module top(
    input wire clk,
    input wire gclk,
    input wire rst,
    input wire [7:0] led_sel,
    output wire [11:0] led
    );

wire [31:2] mem_addr_a;
wire [31:0] mem_din_a;
wire [31:0] mem_dout_a;
wire mem_en_a;
wire mem_we_a;
wire [31:2] mem_addr_b;
wire [31:0] mem_dout_b;
wire mem_en_b;

memory memory(
    .clk(clk), .rst(rst),
    .addr_a(mem_addr_a), .din_a(mem_din_a),
    .dout_a(mem_dout_a),
    .en_a(mem_en_a), .we_a(mem_we_a),
    .addr_b(mem_addr_b), .dout_b(mem_dout_b),
    .en_b(mem_en_b)
    );

wire [4:0] reg_addr_a;
wire [31:0] reg_dout_a;
wire [4:0] reg_addr_b;
wire [31:0] reg_dout_b;
wire [4:0] reg_addr_c;
wire [31:0] reg_dout_c;
wire [4:0] reg_addr;
wire [31:0] reg_din;
wire reg_we;

regfile regfile(
    .clk(clk), .rst(rst),
    .addr_a(reg_addr_a), .dout_a(reg_dout_a),
    .addr_b(reg_addr_b), .dout_b(reg_dout_b),
    .addr_c(reg_addr_c), .dout_c(reg_dout_c),
    .addr(reg_addr), .din(reg_din), .we(reg_we)
    );

wire ex_jump;
wire [31:2] ex_jump_pc;
wire [31:0] if_inst;
wire [31:2] if_pc;

inst_fetch inst_fetch(
    .clk(clk), .rst(rst),

    .mem_addr(mem_addr_b),
    .mem_dout(mem_dout_b),
    .mem_en(mem_en_b),

    .jump(ex_jump),
    .jump_pc(ex_jump_pc),

    .inst(if_inst),
    .pc(if_pc)
    );

wire [31:2] id_pc;
wire [31:0] id_inst;
wire [5:0] id_opcode;
wire [4:0] id_rs;
wire [4:0] id_rt;
wire [4:0] id_rd;
wire [4:0] id_shamt;
wire [5:0] id_funct;
wire [25:0] id_immed;

inst_decode inst_decode(
    .clk(clk), .rst(rst),

    .pc_in(if_pc), .inst(if_inst),

    .pc_out(id_pc), .inst_out(id_inst),

    .opcode(id_opcode),
    .rs(id_rs), .rt(id_rt), .rd(id_rd),
    .shamt(id_shamt), .funct(id_funct),
    .immed(id_immed)
    );

wire [31:2] ex_pc;
wire [31:0] ex_inst;
wire ex_load;
wire ex_store;
wire [4:0] ex_rd;
wire [31:0] ex_rd_val;
wire [4:0] mem_rd;
wire [31:0] mem_rd_val;

inst_execute inst_execute(
    .clk(clk), .rst(rst),
    .pc_in(id_pc), .inst(id_inst),
    .opcode(id_opcode),
    .rs(id_rs), .rt(id_rt), .rd(id_rd),
    .shamt(id_shamt), .funct(id_funct),
    .immed(id_immed),

    .reg_addr_a(reg_addr_a), .reg_dout_a(reg_dout_a),
    .reg_addr_b(reg_addr_b), .reg_dout_b(reg_dout_b),

    .mem_addr(mem_addr_a), .mem_din(mem_din_a),
    .mem_en(mem_en_a), .mem_we(mem_we_a),

    .mem_rd(mem_rd), .mem_rd_val(mem_rd_val),

    .pc_out(ex_pc), .inst_out(ex_inst),
    .jump(ex_jump), .jump_pc(ex_jump_pc),
    .load(ex_load), .store(ex_store),
    .rd_out(ex_rd), .rd_val(ex_rd_val)
    );

wire [31:2] mem_pc;
wire [31:0] mem_inst;

inst_memory inst_memory(
    .clk(clk), .rst(rst),

    .pc_in(ex_pc), .inst(ex_inst),
    .rd(ex_rd), .rd_val(ex_rd_val),
    .load(ex_load), .store(ex_store),

    .mem_dout(mem_dout_a),

    .pc_out(mem_pc), .inst_out(mem_inst),
    .rd_out(mem_rd), .rd_val_out(mem_rd_val)
    );

wire [31:2] wb_pc;
wire [31:0] wb_inst;

inst_writeback inst_writeback(
    .clk(clk), .rst(rst),
    .pc_in(mem_pc), .inst(mem_inst),
    .rd(mem_rd), .rd_val(mem_rd_val),

    .reg_addr(reg_addr), .reg_din(reg_din), .reg_we(reg_we),

    .pc_out(wb_pc), .inst_out(wb_inst)
    );

assign reg_addr_c = led_sel[5:1];
reg [15:0] led_display;
always @(*)
    if(led_sel[0])
        if(led_sel[7:1] == 0)
            led_display = wb_pc[31:16];
        else
            led_display = reg_dout_c[31:16];
    else
        if(led_sel[7:1] == 0)
            led_display = {wb_pc[15:2], 2'b00};
        else
            led_display = reg_dout_c[15:0];

led_drv led_drv(
    .clk(gclk),
    .value(led_display),
    .digit_led(led[11:4]),
    .digit_sel(led[3:0])
    );

endmodule
