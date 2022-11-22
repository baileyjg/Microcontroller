`include "ALUFSM.v"
`timescale 1ns/10ps

module ALUFSM_tb;
    reg clk, rst;
    reg[15:0] instruction;

    wire done, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, pcInc;
    wire[3:0] rxOut, rxIn;

    ALUFSM fsm(clk, rst, instruction, done, rxOut, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, rxIn, pcInc);

    initial begin
        $dumpfile("ALUFSM.vcd");
        $dumpvars(0, ALUFSM_tb);

        // Set initial values
        clk = 0;
        rst = 0;
        instruction = 16'b1000000001000010; // ALU; Add R1 R2

        // Begin stimulation of values
        rst = 1;
        #1 rst = 0;

    end

    always #10 clk =~ clk;

endmodule