`include "top_level.v"
`timescale 1ns/10ps

module top_level_tb;
    reg clk, rst, ALUin0, ALUin1, ALUOutLatch, ALUOutEn;
    reg[2:0] opControl;
    reg[15:0] busIn;
    wire[15:0] busOut;

    // Port mapping of the top_level
    top_level top(clk, rst, busIn, busOut, opControl, ALUin0, ALUin1, ALUOutLatch, ALUOutEn);

    initial begin
        $dumpfile("top_level.vcd");
        $dumpvars(0, top_level_tb);

        // Set initial values
        clk = 0;
        rst = 0;
        busIn = 16'bzzzzzzzzzzzzzzzz;
        opControl = 3'b000;
        ALUin0 = 0;
        ALUin1 = 0;
        ALUOutLatch = 0;
        ALUOutEn = 0;

        // Begin stimulating values
        #1
        rst = 1;
        #1
        rst = 0;
        #1
        busIn = 16'b1000110010100001;
        #6
        opControl = 3'b000;
        ALUin0 = 1;
        #2
        ALUin0 = 0;
        #1
        busIn = 16'b0001001011001000;
        #17
        ALUin1 = 1;
        #2
        ALUin1 = 0;
        #18
        ALUOutLatch = 1;
        #2
        ALUOutLatch = 0;
        #1
        ALUOutEn = 1;
        #1
        ALUOutEn = 0;
    end

    always #10 clk =~ clk;
endmodule