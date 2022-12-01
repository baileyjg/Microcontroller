`include "IFFSM.v"
`timescale 1ns/10ps

module IFFSM_tb;
    reg clk, rst, MFC, done;

    wire pcInc, PCoutEN, memEN, marIn, mdrWriteEN, mdReadEN, mdrOut, RW, IRin;

    IFFSM fsm(clk, rst, done, MFC, PCoutEN, marIn, memEN, RW, mdReadEN, mdrOut, IRin);

    initial begin
        $dumpfile("IFFSM.vcd");
        $dumpvars(0, IFFSM_tb);

        // Set initial values
        clk = 0;
        rst = 0;

        // Begin stimulation of values
        rst = 1;
        #1 rst = 0;
        #60 MFC = 1;
        #15 MFC = 0;

    end

    always #10 clk =~ clk;

endmodule