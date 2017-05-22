`timescale 1ns / 1ps
`default_nettype none

module inst_memory(
    input wire clk,
    input wire rst,

    input wire [31:2] pc_in,
    input wire [31:0] inst,
    input wire [4:0] rd,
    input wire [31:0] rd_val,
    input wire load,
    input wire store,

    input wire [31:0] mem_dout,

    output reg [31:2] pc_out,
    output reg [31:0] inst_out,
    output reg [4:0] rd_out,
    output reg [31:0] rd_val_out
    );

initial begin
    pc_out = 0; inst_out = 32'hxxxxxxxx;
    rd_out = 0; rd_val_out = 0;
end

always @(posedge clk, posedge rst) begin
    if(rst) begin
        pc_out = 0; inst_out = 32'hxxxxxxxx;
        rd_out = 0; rd_val_out = 0;
    end else begin
        pc_out = pc_in;
        inst_out = inst;
        rd_out = store ? 5'h00 : rd;
        rd_val_out = load ? mem_dout : rd_val;
    end
end

endmodule
