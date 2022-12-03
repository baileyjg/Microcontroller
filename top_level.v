// Micro-Controller Top-Level
// Author: Bailey Grimes
// Date: 11/2/22

`include "ALU.v"
`include "dff.v"
`include "tri_state.v"
`include "PC.v"
`include "mem.v"
`include "IFFSM.v"
`include "ALUFSM.v"
`include "ALUiFSM.v"
`include "MEMFSM.v"
`include "MOVFSM.v"
`include "MOViFSM.v"
`timescale 1ns/10ps

module top_level(clk, rst, busIn, busOut, MFC, address, RW, EN);
input clk, rst, MFC;
input[15:0] busIn;
output wire RW, EN;
output[15:0] address;
output wire[15:0] busOut, bus;

// FSM Output Signals
wire ALU_done, ALUi_done, mem_done, MOV_done, MOVi_done; // Done signals
wire[4:0] ALU_RegX_Out, ALU_RegX_In, ALUi_RegX_Out, ALUi_RegX_In, mem_RegX_Out, mem_RegX_In, MOV_RegX_Out, MOV_RegX_In, MOVi_RegX_In;
wire ALU_PC_inc, ALUi_PC_inc, mem_PC_inc, MOV_PC_inc, MOVi_PC_inc; // PC increment
wire IF_MAR_in, mem_MAR_in; // MAR in EN
wire IF_MDR_read, mem_MDR_read; // MDR Read EN
wire IF_MDR_out, mem_MDR_out; // MDR Out EN
wire IF_mem_EN, mem_mem_EN; // Mem EN
wire IF_RW, mem_RW; // Mem RW
wire ALUFSM_ALU_in0, ALUFSM_ALU_in1, ALUiFSM_ALU_in0, ALUiFSM_ALU_in1;
wire ALUFSM_ALU_outlatch, ALUiFSM_ALU_outlatch;
wire ALUFSM_ALU_outEN, ALUiFSM_ALU_outEN;

// FSM Instantiations
IFFSM IF(clk, rst, DONE, MFC, PC_INC, MAR_IN, MEM_EN, RW, MDR_READ_EN, MDR_OUT, IR_IN);
ALUFSM alu(clk, rst, IRinstruct, ALU_done, ALU_RegX_Out, ALUFSM_ALU_in0, ALUFSM_ALU_in1, 
ALUFSM_ALU_outlatch, ALUFSM_ALU_outEN, ALU_RegX_In, ALU_PC_inc);
ALUiFSM alui(clk, rst, IRinstruct, ALUi_done, ALUi_RegX_Out, ALUiFSM_ALU_in0, ALUiFSM_ALU_in1, 
ALUiFSM_ALU_outlatch, ALUiFSM_ALU_outEN, ALUi_RegX_In, ALUi_PC_inc, ALUi_param2out, ALUImmOut);
MEMFSM memfsm();
MOVFSM mov();
MOViFSM movi();

// Assignments
assign DONE = (ALU_done || ALUi_done || mem_done || MOV_done || MOVi_done)? 1:0;
assign PC_INC = (ALU_PC_inc || ALUi_PC_inc || mem_PC_inc || MOV_PC_inc || MOVi_PC_inc)? 1:0;

assign MEM_EN = (IF_mem_EN || mem_mem_EN)? 1:0;
assign RW = (IF_RW || mem_RW)? 1:0;
assign MAR_IN = (IF_MAR_in || mem_MAR_in)? 1:0;
assign MDR_READ_EN = (IF_MDR_read || mem_MDR_read)? 1:0;
assign MDR_OUT = (IF_MDR_out || mem_MDR_out)? 1:0;

// Components //
wire[15:0] IRinstruct;
wire[15:0] ALUi_param2out, MOVi_param2out;

// ALU
dff flip0(clk, rst, ALUin0, busIn, temp0); // ALU input reg 1
dff flip1(clk, rst, ALUin1, busIn, temp1); // ALU input reg 2
dff flip2(clk, rst, ALUOutLatch, temp2, temp3); // ALU output reg
tri_state buffer(ALUOutEn, temp3, busOut); // ALU output tri-state

// Program counter
PC pc(clk, PCInc, rst, temp4);
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

// Memory
mem MEM(MFC, memEN, temp9, temp10, memRW, temp11);

// MAR
dff MAR(clk, rst, MARin, busIn, temp9);

// MDR
dff MDRwrite(clk, rst, MDRwriteEN, busIn, temp10);
dff MDRread(clk, rst, MDRreadEN, temp11, temp12);
tri_state MDRtri(MDRout, temp12, busOut);

// P0
dff p0(clk, rst, p0Latch, busIn, p0Data);
tri_state p0tri(p0Out, p0Data, busOut);

// P1
dff p1(clk, rst, p1Latch, p1Data, p1temp);
tri_state p1tri(p1Out, p1temp, busOut);

// Instruction Register
dff IR(clk, rst, IR_IN, busIn, IRinstruct);

// ALUi Immediate Num Out Tri-state
tri_state immOut(ALUImmOut, ALUi_param2out, busOut);

// MOVi Immediate Num Out Tri-state
tri_state immOut2(MOVImmOut, MOVi_param2out, busOut);

endmodule