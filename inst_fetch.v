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

module inst_fetch(
    input wire clk,
    input wire rst,

    output wire [31:2] mem_addr,
    input wire [31:0] mem_dout,
    output wire mem_en,

    input wire stall,
    input wire jump,
    input wire [31:2] jump_pc,

    output wire [31:0] inst,
    output reg [31:2] pc
    );

reg ready = 0;
reg [31:2] next_pc = 0;

assign mem_addr = jump ? jump_pc : next_pc;
assign mem_en = 1;
assign inst = ready ? mem_dout : 0;

initial begin
    pc = 0;
end

always @(posedge clk, posedge rst)
    if(rst) begin
        pc = 0;
        next_pc = 0;
        ready = 0;
    end else begin
        pc = mem_addr;
        next_pc = pc + 1;
        ready = 1;
    end

endmodule
