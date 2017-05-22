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
