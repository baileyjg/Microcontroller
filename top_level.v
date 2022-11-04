// Micro-Controller Top-Level
// Author: Bailey Grimes
// Date: 11/2/22

`include "ALU.v"
`include "dff.v"
`include "tri_state.v"
`timescale 1ns/10ps

module top_level(clk, rst, bus, opControl, ALUin0, ALUin1, ALUOutLatch, ALUOutEn);
input clk, rst, ALUin0, ALUin1, ALUOutLatch, ALUOutEn;
input[2:0] opControl;
output wire[15:0] bus;
input[15:0] temp0, temp1, temp2; // Port mapping pin conversions

// Port mappings
ALU alu(temp0, temp0, opControl, temp1);

dff flip0(clk, rst, ALUin0, bus, temp0); // Input reg 1
dff flip1(clk, rst, ALUin1, bus, temp0); // Input reg 2
dff flip2(clk, rst, ALUOutLatch, temp1, temp2); // Output reg

tri_state buffer(ALUOutEn, temp2, bus); // Output tri-state

assign #2 bus = 16'b0011010100001011;
assign #5 bus = 16'b1000001100010000;

endmodule