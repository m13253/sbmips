`timescale 1ns / 1ps
`default_nettype none

module regfile(
    input wire clk,
    input wire rst,
    input wire [4:0] addr_a,
    output wire [31:0] dout_a,
    input wire [4:0] addr_b,
    output wire [31:0] dout_b,
    input wire [4:0] addr_c,
    output wire [31:0] dout_c,
    input wire [4:0] addr,
    input wire [31:0] din,
    input wire we
    );

reg [31:0] regs [0:31];

assign dout_a = regs[addr_a];
assign dout_b = regs[addr_b];
assign dout_c = regs[addr_c];

integer i;

initial
    for(i = 0; i < 32; i = i + 1)
        regs[i] = 0;

always @(posedge clk, posedge rst)
    if(rst)
        for(i = 0; i < 32; i = i + 1)
            regs[i] = 0;
    else if(we && addr != 5'h00)
        regs[addr] = din;

endmodule
