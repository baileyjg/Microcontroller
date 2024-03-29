// Memory Finite State Machine
// Author: Bailey Grimes
// Date: 11/22/22

`timescale 1ns/10ps

module MEMFSM(clk, rst, instruction, done, memEN, marIn, mdrWriteEN, mdrReadEN, mdrOut, RW, rxOut, rxIn, pcInc, MFC, addr_out_EN, addr_out, IF_active);
    input clk, rst, MFC, IF_active;
    input[15:0] instruction;
    wire[3:0] opCode = instruction[15:12];
    wire[5:0] param1 = instruction[11:6];
    wire[5:0] param2 = instruction[5:0];

    output reg done, memEN, marIn, mdrWriteEN, mdrReadEN, mdrOut, RW, pcInc, addr_out_EN;
    output reg[5:0] rxOut, rxIn;
    output reg[15:0] addr_out;

    //States
    reg[3:0] pres_state, next_state;
    parameter st0 = 4'b0000, st1 = 4'b0001, st2 = 4'b0010, st3 = 4'b0011, st4 = 4'b0100, st5 = 4'b0101, st6 = 4'b0110;
    parameter st7 = 4'b0111, st8 = 4'b1000, st9 = 4'b1001, st10 = 4'b1010, st11 = 4'b1011, st12 = 4'b1100, st13 = 4'b1101;

    // State register
    always @(posedge clk or posedge rst) begin
        if(rst)
            pres_state <= st0;
        else if(IF_active)
            pres_state <= st0;
        else if(pres_state == st0 && opCode == 4'b0011) // Branch to st6 for load operation
            pres_state <= st6;
        else if(pres_state == st0 && opCode == 4'b0100) // Branch to st3 for store operation
            pres_state <= st1;
        else if(pres_state == st9 && MFC) // Load can move into st10
            pres_state <= st10;
        else if(pres_state == st9 && !MFC) // Load must stay in st9
            pres_state <= st9;
        else if(pres_state == st5 && !MFC) // Store operation stays in st5 until MFC
            pres_state <= st5;
        else if(pres_state == st5 && MFC) // Store operation can move into done state
            pres_state <= st12;
        else if(opCode == 4'b0011 || opCode == 4'b0100)
            pres_state <= next_state;
        else
            pres_state <= st0;
    end

    // Next state logic
    always @(pres_state) begin
        case(pres_state)
            st0: next_state <= st1;
            st1: next_state <= st2;
            st2: next_state <= st3;
            st3: next_state <= st4;
            st4: next_state <= st5;
            st5: next_state <= st6;
            st6: next_state <= st7;
            st7: next_state <= st8;
            st8: next_state <= st9;
            st9: next_state <= st10;
            st10: next_state <= st11;
            st11: next_state <= st11;
            default: next_state <= st0;
        endcase
    end

    // Output defintion
    always @(pres_state) begin
        case(pres_state)
            st0: begin
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
            end
            st1: begin
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxIn <= 6'b000000;pcInc <= 1;addr_out_EN <= 0;
                case(param2) // Figure out which gen reg to pull the destination address from
                    6'b000000: rxOut <= 6'b100000;
                    6'b000001: rxOut <= 6'b010000;
                    6'b000010: rxOut <= 6'b001000;
                    6'b000011: rxOut <= 6'b000100;
                    6'b000100: rxOut <= 6'b000010;
                    6'b000101: rxOut <= 6'b000001;
                    default: rxOut <= 6'b000000;
                endcase
            end
            st2: begin
                done <= 0;memEN <= 0;marIn <= 1;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
                case(param2) // Figure out which gen reg to pull the destination address from
                    6'b000000: rxOut <= 6'b100000;
                    6'b000001: rxOut <= 6'b010000;
                    6'b000010: rxOut <= 6'b001000;
                    6'b000011: rxOut <= 6'b000100;
                    6'b000100: rxOut <= 6'b000010;
                    6'b000101: rxOut <= 6'b000001;
                    default: rxOut <= 6'b000000;
                endcase
            end
            st3: begin // Begin Store operation
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
                case(param1) // Figure out which gen reg to pull the data from
                    6'b000000: rxOut <= 6'b100000;
                    6'b000001: rxOut <= 6'b010000;
                    6'b000010: rxOut <= 6'b001000;
                    6'b000011: rxOut <= 6'b000100;
                    6'b000100: rxOut <= 6'b000010;
                    6'b000101: rxOut <= 6'b000001;
                    default: rxOut <= 6'b000000;
                endcase
            end
            st4: begin
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 1;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
                case(param1) // Figure out which gen reg to pull the data from
                    6'b000000: rxOut <= 6'b100000;
                    6'b000001: rxOut <= 6'b010000;
                    6'b000010: rxOut <= 6'b001000;
                    6'b000011: rxOut <= 6'b000100;
                    6'b000100: rxOut <= 6'b000010;
                    6'b000101: rxOut <= 6'b000001;
                    default: rxOut <= 6'b000000;
                endcase
            end
            st5: begin
                done <= 0;memEN <= 1;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
            end
            st6: begin // Begin load operation
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 1;
                addr_out <= 16'b1111111111111111; // Put an invalid address on the bus, this allows memory to output the memorycell later on
            end
            st7: begin
                done <= 0;memEN <= 0;marIn <= 1;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 1;
                addr_out <= 16'b1111111111111111;
            end
            st8: begin
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 1;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
            end
            st9: begin
                done <= 0;memEN <= 1;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 1;mdrOut <= 0;RW <= 1;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
            end
            st10: begin
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 1;RW <= 1;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
            end
            st11: begin
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 1;RW <= 1;rxOut <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
                case(param1) // Figure out which gen reg to load the data into
                    6'b000000: rxIn <= 6'b100000;
                    6'b000001: rxIn <= 6'b010000;
                    6'b000010: rxIn <= 6'b001000;
                    6'b000011: rxIn <= 6'b000100;
                    6'b000100: rxIn <= 6'b000010;
                    6'b000101: rxIn <= 6'b000001;
                    default: rxIn <= 6'b000000;
                endcase
            end
            st12: begin // Load and store operations merge into 2nd to last state
                done <= 1;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
            end
            st13: begin
                done <= 0;memEN <= 0;marIn <= 0;mdrWriteEN <= 0;mdrReadEN <= 0;mdrOut <= 0;RW <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;addr_out_EN <= 0;
            end
        endcase
    end

endmodule