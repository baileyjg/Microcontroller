`include "MEMFSM.v"
`timescale 1ns/10ps

module MEMFSM_tb;
    reg clk, rst, MFC;
    reg[15:0] instruction;

    wire done, pcInc, memEN, marIn, mdrWriteEN, mdReadEN, mdrOut, RW;
    wire[3:0] rxOut, rxIn;

    MEMFSM fsm(clk, rst, instruction, done, memEN, marIn, mdrWriteEN, mdrReadEN, mdrOut, RW, rxOut, rxIn, pcInc, MFC);

    initial begin
        $dumpfile("MEMFSM.vcd");
        $dumpvars(0, MEMFSM_tb);

        // Set initial values
        clk = 0;
        rst = 0;
        instruction = 16'b0010000001000010; // LOAD R1 R2

        // Begin stimulation of values
        rst = 1;
        #1 rst = 0;
        #60 MFC = 1;
        #15 MFC = 0;

    end

    always #10 clk =~ clk;

endmodule