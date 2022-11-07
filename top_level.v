// Micro-Controller Top-Level
// Author: Bailey Grimes
// Date: 11/2/22

`include "ALU.v"
`include "dff.v"
`include "tri_state.v"
`include "PC.v"
`timescale 1ns/10ps

module top_level(clk, rst, busIn, busOut, opControl, ALUin0, ALUin1, ALUOutLatch, ALUOutEn, PCOutEn);
input clk, rst;
input ALUin0, ALUin1, ALUOutLatch, ALUOutEn; // ALU control signals
input[2:0] opControl; // ALU opcontrol
input PCOutEn; // PC control signals
input r0Latch, r1Latch, r2Latch, r3Latch, r0Out, r1Out, r2Out, r3Out; // General purpose register control signals
input[15:0] busIn;
output wire[15:0] busOut;
wire[15:0] temp0, temp1, temp2, temp3; // ALU port mapping pin conversions
wire[15:0] temp4; // PC pin conversions
wire[15:0] temp5, temp6, temp7, temp8;

// Port mappings //

// ALU
ALU alu(temp0, temp1, opControl, temp2);
dff flip0(clk, rst, ALUin0, busIn, temp0); // ALU input reg 1
dff flip1(clk, rst, ALUin1, busIn, temp1); // ALU input reg 2
dff flip2(clk, rst, ALUOutLatch, temp2, temp3); // ALU output reg
tri_state buffer(ALUOutEn, temp3, busOut); // ALU output tri-state

// Program counter
PC pc(clk, rst, temp4);
tri_state buffer2(PCOutEn, temp4, busOut);

// General purpose registers
dff r0(clk, rst, r0Latch, busIn, temp5);
tri_state buffer3(r0Out, temp5, busOut);

dff r1(clk, rst, r1Latch, busIn, temp6);
tri_state buffer4(r1Out, temp6, busOut);

dff r2(clk, rst, r2Latch, busIn, temp7);
tri_state buffer5(r2Out, temp7, busOut);

dff r3(clk, rst, r3Latch, busIn, temp8);
tri_state buffer6(r3Out, temp8, busOut);

// MAR

endmodule