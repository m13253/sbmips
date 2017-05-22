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
