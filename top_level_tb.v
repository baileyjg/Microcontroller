`include "ALU.v"
`timescale 1ns/10ps

module top_level_tb;
    reg[2:0] op;
    reg[15:0] in0, in1;
    wire[15:0] out;

    ALU alu(op, in0, in1, out);

    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, top_level_tb);

        op = 3'b000;
        in0 = 16'b0000000000000000;
        in1 = 16'b0000000000000000;
        #10;
        op = 3'b110;
        in0 = 16'b0010010101000011;
        in1 = 16'b1100011000001010;
        #50;
    end
endmodule