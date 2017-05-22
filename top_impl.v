`timescale 1ns / 1ps
`default_nettype none

module top_impl(
    input wire btn,
    input wire gclk,
    input wire rst,
    input wire [7:0] led_sel,
    output wire [11:0] led
    );

wire clk;
dejitter dejitter(
    .clk(gclk), .btn(btn),
    .btn_out(clk)
    );

top top(
    .btn(clk), .gclk(gclk), .rst(rst),
    .led_sel(led_sel), .led(led)
    );

endmodule
