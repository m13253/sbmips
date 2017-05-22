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

module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [4:0] shamt,
    input wire [5:0] alu_op,
    output reg [31:0] out
    );

always @(*)
    case (alu_op)
        6'h00: begin // sll
            out = a << shamt;
        end
        6'h02: begin // srl
            out = $unsigned(a) >> shamt;
        end
        6'h03: begin // sra
            out = $signed(a) >> shamt;
        end
        6'h04: begin // sllv
            out = b << a;
        end
        6'h06: begin // srlv
            out = $unsigned(b) >> a;
        end
        6'h07: begin // srav
            out = $signed(b) >> a;
        end
        6'h20: begin // add
            out = a + b;
        end
        6'h21: begin // addu
            out = a + b;
        end
        6'h22: begin // sub
            out = a - b;
        end
        6'h23: begin // subu
            out = a - b;
        end
        6'h24: begin // and
            out = a & b;
        end
        6'h25: begin // or
            out = a | b;
        end
        6'h26: begin // xor
            out = a ^ b;
        end
        6'h27: begin // nor
            out = ~(a | b);
        end
        6'h2a: begin // slt
            out = $signed(a) < $signed(b);
        end
        6'h2b: begin // sltu
            out = $unsigned(a) < $unsigned(b);
        end
        default: begin
            out = 31'hxxxxxxxx;
        end
    endcase

endmodule
