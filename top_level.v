// Micro-Controller Top-Level
// Author: Bailey Grimes
// Date: 11/2/22

`include "ALU.v"
`include "dff.v"
`include "tri_state.v"
`include "PC.v"
`include "mem.v"
`timescale 1ns/10ps

module top_level(clk, rst, busIn, busOut, opControl, ALUin0, ALUin1, ALUOutLatch, ALUOutEn, PCOutEn);
input clk, rst;

input ALUin0, ALUin1, ALUOutLatch, ALUOutEn; // ALU control signals
input[2:0] opControl; // ALU opcontrol
input PCOutEn; // PC control signals
input r0Latch, r1Latch, r2Latch, r3Latch, r0Out, r1Out, r2Out, r3Out; // General purpose register control signals
input memEN, memRW; // Memory control signals
input MARin; // MAR control signals
input MDRwriteEN, MDRreadEN, MDRout; // MDR control signals
output MFC; // Mem function complete
input p0Latch, p0Out, p1Latch, p1Out; // I/O control signals

input[15:0] busIn;
output wire[15:0] busOut;

wire[15:0] temp0, temp1, temp2, temp3; // ALU port mapping pin conversions
wire[15:0] temp4; // PC pin conversions
wire[15:0] temp5, temp6, temp7, temp8; // General purpose reg pin conversions
wire[15:0] temp9, temp10, temp11, temp12; // Memory pin conversions
wire[15:0] p0Data, p1Data, p1temp; // I/O pin conversions

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

// General purpose registers //
dff r0(clk, rst, r0Latch, busIn, temp5);
tri_state buffer3(r0Out, temp5, busOut);

dff r1(clk, rst, r1Latch, busIn, temp6);
tri_state buffer4(r1Out, temp6, busOut);

dff r2(clk, rst, r2Latch, busIn, temp7);
tri_state buffer5(r2Out, temp7, busOut);

dff r3(clk, rst, r3Latch, busIn, temp8);
tri_state buffer6(r3Out, temp8, busOut);

// Memory //
mem MEM(MFC, memEN, temp9, temp10, memRW, temp11);

// MAR
dff MAR(clk, rst, MARin, busIn, temp9);

// MDR
dff MDRwrite(clk, rst, MDRwriteEN, busIn, temp10);
dff MDRread(clk, rst, MDRreadEN, temp11, temp12);
tri_state MDRtri(MDRout, temp12, busOut);

// I/O //

// P0
dff p0(clk, rst, p0Latch, busIn, p0Data);
tri_state p0tri(p0Out, p0Data, busOut);

// P1
dff p1(clk, rst, p1Latch, p1Data, p1temp);
tri_state p1tri(p1Out, p1temp, busOut);

endmodule