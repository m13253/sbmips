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

module inst_decode(
    input wire clk,
    input wire rst,

    input wire [31:2] pc_in,
    input wire [31:0] inst,

    output reg [31:2] pc_out,
    output reg [31:0] inst_out,

    output reg [5:0] opcode,
    output reg [4:0] rs,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg [4:0] shamt,
    output reg [5:0] funct,
    output reg [25:0] immed
    );

initial begin
    pc_out = 0; inst_out = 32'hzzzzzzzz;
    opcode = 0;
    rs = 0; rt = 0; rd = 0;
    shamt = 0; funct = 0;
    immed = 0;
end

always @(posedge clk, posedge rst) begin
    if(rst) begin
        pc_out = 0; inst_out = 32'hzzzzzzzz;
        opcode = 0;
        rs = 0; rt = 0; rd = 0;
        shamt = 0; funct = 0;
        immed = 0;
    end else begin
        pc_out = pc_in; inst_out = inst;
        opcode = inst[31:26];
        if(opcode == 6'h02 || opcode == 6'h03) begin
            rs = 0; rt = 0; rd = 0; shamt = 0; funct = 0;
            immed = inst[25:0];
        end begin
            if(opcode == 6'h00) begin
                rs = inst[25:21];
                rt = inst[20:16];
                rd = inst[15:11];
                shamt = inst[10:6];
                funct = inst[5:0];
                immed = 0;
            end else begin
                rs = inst[25:21];
                rt = 0;
                rd = inst[20:16];
                shamt = 0;
                funct = 0;
                immed = $signed(inst[15:0]);
            end
        end
    end
end

endmodule
