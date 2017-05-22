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

module dejitter(
    input wire clk,
    input wire btn,
    output reg btn_out
    );

reg [31:0] count = 0;

initial
    btn_out = 0;

always @(posedge clk) begin
    if(btn != btn_out)
        count = count + 1;
    else
        count = 0;
    if(count == 5000000) begin
        btn_out = btn;
        count = 0;
    end
end

endmodule
