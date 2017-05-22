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
    pc = 30'hxxxxxxxx;
end

always @(posedge clk, posedge rst)
    if(rst) begin
        pc = 30'hxxxxxxxx;
        next_pc = 0;
        ready = 0;
    end else begin
        pc = mem_addr;
        next_pc = pc + 1;
        ready = 1;
    end

endmodule
