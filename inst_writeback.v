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

module inst_writeback(
    input wire clk,
    input wire rst,

    input wire [31:2] pc_in,
    input wire [31:0] inst,
    input wire [4:0] rd,
    input wire [31:0] rd_val,

    output wire [4:0] reg_addr,
    output wire [31:0] reg_din,
    output wire reg_we,

    output reg [31:2] pc_out,
    output reg [31:0] inst_out
    );

initial begin
    pc_out = 0; inst_out = 32'hxxxxxxxx;
end

assign reg_addr = rd;
assign reg_din = rd_val;
assign reg_we = rd != 5'h00;

always @(posedge clk, posedge rst)
    if(rst) begin
        pc_out = 0; inst_out = 32'hxxxxxxxx;
    end else begin
        pc_out = pc_in; inst_out = inst;
    end

endmodule
