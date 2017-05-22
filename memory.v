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

module memory(
    input wire clk,
    input wire rst,
    input wire [31:2] addr_a,
    input wire [31:0] din_a,
    output reg [31:0] dout_a,
    input wire en_a,
    input wire we_a,
    input wire [31:2] addr_b,
    output reg [31:0] dout_b,
    input wire en_b
    );

reg [31:0] ram [0:255];
reg [31:0] rom [0:255];

initial begin
    $readmemh("program/text.hex", rom);
    $readmemh("program/data.hex", ram);
end

always @(posedge clk) begin
    if(en_a && we_a)
        ram[addr_a] <= din_a;
    dout_a <= en_a ? ram[addr_a] : 32'hzzzzzzzz;
    dout_b <= en_b ? rom[addr_b] : 32'hzzzzzzzz;
end

endmodule
