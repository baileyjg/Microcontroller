`include "IFFSM.v"
`include "PC.v"
`timescale 1ns/10ps

module IFFSM_tb;
    reg clk, rst, MFC, done, pcInc;

    wire PCoutEN, memEN, marIn, mdReadEN, mdrOut, RW, IRin;
    wire[15:0] PCout;

    IFFSM fsm(clk, rst, done, MFC, PCoutEN, marIn, memEN, RW, mdReadEN, mdrOut, IRin);
    PC pc(pcInc, rst, PCout);

    initial begin
        $dumpfile("IFFSM.vcd");
        $dumpvars(0, IFFSM_tb);

        // Set initial values
        clk = 0;
        rst = 0;
        pcInc = 0;
        done = 0;

        // Begin stimulation of values
        rst = 1;
        #1 rst = 0;
        done = 0;
        #1 done = 0;
        #60 MFC = 1;
        #15 MFC = 0;

    end

    always #10 clk =~ clk;

endmodule