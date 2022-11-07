// Micro-Controller Top-Level
// Author: Bailey Grimes
// Date: 11/2/22

`include "ALU.v"
`include "dff.v"
`include "tri_state.v"
`timescale 1ns/10ps

module top_level(clk, rst, busIn, busOut, opControl, ALUin0, ALUin1, ALUOutLatch, ALUOutEn);
input clk, rst;
input ALUin0, ALUin1, ALUOutLatch, ALUOutEn; // ALU control signals
input[2:0] opControl; // ALU opcontrol
input[15:0] busIn;
output wire[15:0] busOut;
input[15:0] temp0, temp1, temp2, temp3; // Port mapping pin conversions

// Port mappings
ALU alu(temp0, temp1, opControl, temp2);

dff flip0(clk, rst, ALUin0, busIn, temp0); // ALU input reg 1
dff flip1(clk, rst, ALUin1, busIn, temp1); // ALU input reg 2
dff flip2(clk, rst, ALUOutLatch, temp2, temp3); // ALU output reg

tri_state buffer(ALUOutEn, temp3, busOut); // ALU output tri-state
endmodule