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

module top_level(clk, rst, p1Data, p0_data_out, bus);
input clk, rst, MFC;
input[15:0] p1Data;
output[15:0] p0_data_out;
inout wire[15:0] bus;

// FSM Output Signals
wire ALU_done, ALUi_done, mem_done, MOV_done, MOVi_done; // Done signals
wire[5:0] ALU_RegX_Out, ALU_RegX_In, ALUi_RegX_Out, ALUi_RegX_In, mem_RegX_Out, mem_RegX_In, MOV_RegX_Out, MOV_RegX_In, MOVi_RegX_In;
wire ALU_PC_inc, ALUi_PC_inc, mem_PC_inc, MOV_PC_inc, MOVi_PC_inc; // PC increment
wire PC_OUT_EN;
wire IF_MAR_in, mem_MAR_in; // MAR in EN
wire IF_MDR_read, mem_MDR_read; // MDR Read EN
wire IR_IN; // Instruction register in EN
wire MDR_WRITE_EN; // MDR Write EN
wire IF_MDR_out, mem_MDR_out; // MDR Out EN
wire IF_mem_EN, mem_mem_EN; // Mem EN
wire IF_RW, mem_RW; // Mem RW
wire ALUFSM_ALU_in0, ALUFSM_ALU_in1, ALUiFSM_ALU_in0, ALUiFSM_ALU_in1;
wire ALUFSM_ALU_outlatch, ALUiFSM_ALU_outlatch;
wire ALUFSM_ALU_outEN, ALUiFSM_ALU_outEN;

// FSM Instantiations
IFFSM IF(clk, rst, DONE, MFC, PC_OUT_EN, IF_MAR_in, IF_mem_EN, IF_RW, IF_MDR_read, IF_MDR_out, IR_IN);
ALUFSM alufsm(clk, rst, IRinstruct, ALU_done, ALU_RegX_Out, ALUFSM_ALU_in0, ALUFSM_ALU_in1, 
ALUFSM_ALU_outlatch, ALUFSM_ALU_outEN, ALU_RegX_In, ALU_PC_inc);
ALUiFSM alui(clk, rst, IRinstruct, ALUi_done, ALUi_RegX_Out, ALUiFSM_ALU_in0, ALUiFSM_ALU_in1, 
ALUiFSM_ALU_outlatch, ALUiFSM_ALU_outEN, ALUi_RegX_In, ALUi_PC_inc, ALUi_param2out, ALUImmOut);
MEMFSM memfsm(clk, rst, IRinstruct, mem_done, mem_mem_EN, mem_MAR_in, MDR_WRITE_EN, mem_MDR_read, mem_MDR_out, mem_RW, mem_RegX_Out, mem_RegX_In, mem_PC_inc, MFC);
MOVFSM mov(clk, rst, IRinstruct, MOV_done, MOV_RegX_Out, MOV_RegX_In, MOV_PC_inc);
MOViFSM movi(clk, rst, IRinstruct, MOVi_done, MOVi_RegX_In, MOVi_PC_inc, MOVi_param2out, MOVImmOut);

wire DONE, PC_INC, MEM_EN, RW, MAR_IN, MDR_READ_EN, MDR_OUT, ALU_OUT_LATCH_EN, ALU_OUT_EN, ALUIN0_EN, ALUIN1_EN;
wire R0_OUT_EN, R1_OUT_EN, R2_OUT_EN, R3_OUT_EN, R0_IN_EN, R1_IN_EN, R2_IN_EN, R3_IN_EN;
wire P0_OUT_EN, P1_OUT_EN, P0_IN_EN, P1_IN_EN;

// Assignments
assign DONE = (ALU_done || ALUi_done || mem_done || MOV_done || MOVi_done);
assign PC_INC = (ALU_PC_inc || ALUi_PC_inc || mem_PC_inc || MOV_PC_inc || MOVi_PC_inc);

assign MEM_EN = (IF_mem_EN || mem_mem_EN);
assign RW = (IF_RW || mem_RW);
assign MAR_IN = (IF_MAR_in || mem_MAR_in);
assign MDR_READ_EN = (IF_MDR_read || mem_MDR_read);
assign MDR_OUT = (IF_MDR_out || mem_MDR_out);

assign ALU_OUT_LATCH_EN = (ALUFSM_ALU_outlatch || ALUiFSM_ALU_outlatch);
assign ALU_OUT_EN = (ALUFSM_ALU_outEN || ALUiFSM_ALU_outEN);
assign ALUIN0_EN = (ALUFSM_ALU_in0 || ALUiFSM_ALU_in0);
assign ALUIN1_EN = (ALUFSM_ALU_in1 || ALUiFSM_ALU_in1);

assign R0_OUT_EN = (ALU_RegX_Out[5] || ALUi_RegX_Out[5] || mem_RegX_Out[5] || MOV_RegX_Out[5]);
assign R1_OUT_EN = (ALU_RegX_Out[4] || ALUi_RegX_Out[4] || mem_RegX_Out[4] || MOV_RegX_Out[4]);
assign R2_OUT_EN = (ALU_RegX_Out[3] || ALUi_RegX_Out[3] || mem_RegX_Out[3] || MOV_RegX_Out[3]);
assign R3_OUT_EN = (ALU_RegX_Out[2] || ALUi_RegX_Out[2] || mem_RegX_Out[2] || MOV_RegX_Out[2]);
assign R0_IN_EN = (ALU_RegX_In[5] || ALUi_RegX_In[5] || mem_RegX_In[5] || MOV_RegX_In[5] || MOVi_RegX_In[5]);
assign R1_IN_EN = (ALU_RegX_In[4] || ALUi_RegX_In[4] || mem_RegX_In[4] || MOV_RegX_In[4] || MOVi_RegX_In[4]);
assign R2_IN_EN = (ALU_RegX_In[3] || ALUi_RegX_In[3] || mem_RegX_In[3] || MOV_RegX_In[3] || MOVi_RegX_In[3]);
assign R3_IN_EN = (ALU_RegX_In[2] || ALUi_RegX_In[2] || mem_RegX_In[2] || MOV_RegX_In[2] || MOVi_RegX_In[2]);

assign P0_OUT_EN = (ALU_RegX_Out[1] || ALUi_RegX_Out[1] || mem_RegX_Out[1] || MOV_RegX_Out[1]);
assign P0_IN_EN = (ALU_RegX_In[1] || ALUi_RegX_In[1] || mem_RegX_In[1] || MOV_RegX_In[1] || MOVi_RegX_In[1]);
assign P1_OUT_EN = (ALU_RegX_Out[0] || ALUi_RegX_Out[0] || mem_RegX_Out[0] || MOV_RegX_Out[0]);
assign P1_IN_EN = (ALU_RegX_In[0] || ALUi_RegX_In[0] || mem_RegX_In[0] || MOV_RegX_In[0] || MOVi_RegX_In[0]);

// Components //
wire[15:0] IRinstruct;
wire[15:0] ALUi_param2out, MOVi_param2out;

wire[15:0] ALUin0_data, ALUin1_data; // ALU input registers
wire[2:0] ALUControlOp; // ALU op control
wire[15:0] ALU_data_out, ALU_out_latch_data;
assign ALUControlOp = IRinstruct[14:12]; // Get last three bits of the opcode

// ALU
ALU alu(ALUin0_data, ALUin1_data, ALUControlOp, ALU_data_out);
dff flip0(clk, rst, ALUIN0_EN, bus, ALUin0_data); // ALU input reg 1
dff flip1(clk, rst, ALUIN1_EN, bus, ALUin1_data); // ALU input reg 2
dff flip2(clk, rst, ALU_OUT_LATCH_EN, ALU_out_latch_data, ALU_data_out); // ALU output reg
tri_state buffer(ALU_OUT_EN, ALU_data_out, bus); // ALU output tri-state

wire[15:0] PC_instruct_out; // Instruction data from the PC
// Program counter
PC pc(clk, PC_INC, rst, PC_instruct_out);
tri_state buffer2(PC_OUT_EN, PC_instruct_out, bus);

wire[15:0] r0_data, r1_data, r2_data, r3_data; // Gen reg temp signals
// General purpose registers
dff r0(clk, rst, R0_IN_EN, bus, r0_data);
tri_state buffer3(R0_OUT_EN, r0_data, bus);

dff r1(clk, rst, R1_IN_EN, bus, r1_data);
tri_state buffer4(R1_OUT_EN, r1_data, bus);

dff r2(clk, rst, R2_IN_EN, bus, r2_data);
tri_state buffer5(R2_OUT_EN, r2_data, bus);

dff r3(clk, rst, R3_IN_EN, bus, r3_data);
tri_state buffer6(R3_OUT_EN, r3_data, bus);

// Memory
mem MEM(MFC, MEM_EN, memAdress, memDataIn, RW, memDataOutLatch);

wire[15:0] memAdress;
// MAR
dff MAR(clk, rst, MAR_IN, bus, memAdress);

wire[15:0] memDataIn, memDataOutLatch, memDataOut;
// MDR
dff MDRwrite(clk, rst, MDR_WRITE_EN, bus, memDataIn); // MDR write D flip-flop
dff MDRread(clk, rst, MDR_READ_EN, memDataOutLatch, memDataOut); // MDR read D flip-flop
tri_state MDRtri(MDR_OUT, memDataOut, bus);

wire[15:0] p0_data_out, p1_data_out;
// P0
dff p0(clk, rst, P0_IN_EN, bus, p0_data_out);
tri_state p0tri(P0_OUT_EN, p0_data_out, bus);

// P1
dff p1(clk, rst, P1_IN_EN, p1Data, p1_data_out);
tri_state p1tri(P1_OUT_EN, p1_data_out, bus);

// Instruction Register
dff IR(clk, rst, IR_IN, bus, IRinstruct);

// ALUi Immediate Num Out Tri-state
tri_state immOut(ALUImmOut, ALUi_param2out, bus);

// MOVi Immediate Num Out Tri-state
tri_state immOut2(MOVImmOut, MOVi_param2out, bus);

endmodule