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

module top_bench;

    // Inputs
    reg btn;
    reg gclk;
    reg rst;
    reg [7:0] led_sel;

    // Outputs
    wire [11:0] led;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .btn(btn),
        .gclk(gclk),
        .rst(rst),
        .led_sel(led_sel),
        .led(led)
    );

    initial begin
        // Initialize Inputs
        btn = 0;
        gclk = 0;
        rst = 0;
        led_sel = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        repeat(500) begin
            btn = ~btn;
            gclk = ~gclk;
            #100;
        end

    end

endmodule

