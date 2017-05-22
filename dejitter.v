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
