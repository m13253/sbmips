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

module led_drv(
    input wire clk, // 100 Mhz
    input wire [15:0] value,
    output reg [7:0] digit_led,
    output wire [3:0] digit_sel
    );

reg [19:0] clk_div;
initial
    clk_div = 0;
always @(posedge clk)
    clk_div = clk_div + 1;

wire [2:0] digit_idx = clk_div[19:18];

reg [3:0] digit;
always @(posedge clk) begin
    case (digit_idx)
        3: digit = value[15:12];
        2: digit = value[11:8];
        1: digit = value[7:4];
        0: digit = value[3:0];
    endcase
    case (digit)
        4'h0: digit_led = 8'b00000011;
        4'h1: digit_led = 8'b10011111;
        4'h2: digit_led = 8'b00100101;
        4'h3: digit_led = 8'b00001101;
        4'h4: digit_led = 8'b10011001;
        4'h5: digit_led = 8'b01001001;
        4'h6: digit_led = 8'b01000001;
        4'h7: digit_led = 8'b00011111;
        4'h8: digit_led = 8'b00000001;
        4'h9: digit_led = 8'b00001001;
        4'ha: digit_led = 8'b00010001;
        4'hb: digit_led = 8'b11000001;
        4'hc: digit_led = 8'b01100011;
        4'hd: digit_led = 8'b10000101;
        4'he: digit_led = 8'b01100001;
        4'hf: digit_led = 8'b01110001;
    endcase
end

assign digit_sel[3] = digit_idx != 0;
assign digit_sel[2] = digit_idx != 1;
assign digit_sel[1] = digit_idx != 2;
assign digit_sel[0] = digit_idx != 3;

endmodule
