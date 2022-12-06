`include "top_level.v"
`timescale 1ns/10ps

module top_level_tb;
    reg clk, rst;
    reg[15:0] p1Data;
    wire[15:0] p0_data_out, bus;

    // Port mapping of the top_level
    top_level top(clk, rst, p1Data, p0_data_out, bus);

    initial begin
        $dumpfile("top_level.vcd");
        $dumpvars(0, top_level_tb);

        // Set initial values
        clk = 0;
        rst = 0;
        p1Data = 16'b1111000011110000;
        #1 rst = 1;
        #11 rst = 0;
    end

    always #10 clk =~ clk;
endmodule