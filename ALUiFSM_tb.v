`include "ALUiFSM.v"
`timescale 1ns/10ps

module ALUiFSM_tb;
    reg clk, rst;
    reg[15:0] instruction;

    wire done, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, pcInc;
    wire[3:0] rxOut, rxIn;
    wire[15:0] param2Out;

    ALUiFSM fsm(clk, rst, instruction, done, rxOut, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, rxIn, pcInc, param2Out);

    initial begin
        $dumpfile("ALUiFSM.vcd");
        $dumpvars(0, ALUiFSM_tb);

        // Set initial values
        clk = 0;
        rst = 0;
        instruction = 16'b0000000001000100; // ALU; Add R1 4

        // Begin stimulation of values
        rst = 1;
        #1 rst = 0;

    end

    always #10 clk =~ clk;

endmodule