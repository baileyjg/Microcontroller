`include "MOVFSM.v"
`timescale 1ns/10ps

module MOVFSM_tb;
    reg clk, rst;
    reg[15:0] instruction;

    wire done, pcInc;
    wire[3:0] rxOut, rxIn;

    MOVFSM fsm(clk, rst, instruction, done, rxOut, rxIn, pcInc);

    initial begin
        $dumpfile("MOVFSM.vcd");
        $dumpvars(0, MOVFSM_tb);

        // Set initial values
        clk = 0;
        rst = 0;
        instruction = 16'b0100000001000010; // ALU; MOV R1 R2

        // Begin stimulation of values
        rst = 1;
        #1 rst = 0;

    end

    always #10 clk =~ clk;

endmodule