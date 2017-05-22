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

