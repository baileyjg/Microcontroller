// ALU Finite State Machine
// Author: Bailey Grimes
// Date: 11/20/22

`timescale 1ns/10ps

module ALUFSM(clk, rst, instruction, done, rxOut, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, rxIn, pcInc);
input clk, rst;
input[15:0] instruction; // 16-bit data
wire[3:0] opcode = instruction[15:12];
wire[5:0] param1 = instruction[11:6];
wire[5:0] param2 = instruction[5:0];

output reg done, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, pcInc; // Output signals
output reg[4:0] rxOut, rxIn; // Gen reg output signals

// States
reg[3:0] pres_state, next_state;
parameter st0 = 4'b0000, st1 = 4'b0001, st2 = 4'b0010, st3 = 4'b0011, st4 = 4'b0100, st5 = 4'b0101, st6 = 4'b0110, st7 = 4'b0111;
parameter st8 = 4'b1000, st9 = 4'b1001, st10 = 4'b1010;

// State register
always @(posedge clk or posedge rst) begin
    if(rst)
        pres_state <= st0;
    else if(opcode == 4'b1000 || opcode == 4'b1001 || opcode == 4'b1010 || opcode == 4'b1011 || opcode == 4'b1100 || opcode == 4'b1101 || opcode == 4'b1110)
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
        st10: next_state <= st10;
        default: next_state <= st0;
    endcase
end

// Output definition
always @(pres_state) begin
    case(pres_state)
        st0: begin
            done <= 0;rxOut <= 5'b00000;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
        end
        st1: begin
            done <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 1;
            case(param1) // Figure out which gen reg EN to assert
                6'b000000: rxOut <= 5'b10000;
                6'b000001: rxOut <= 5'b01000;
                6'b000010: rxOut <= 5'b00100;
                6'b000011: rxOut <= 5'b00010;
                6'b000100: rxOut <= 5'b00001;
                default: rxOut <= 5'b00000;
            endcase
        end
        st2: begin
            done <= 0;ALUin0 <= 1;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
            case(param1) // Figure out which gen reg EN to assert
                6'b000000: rxOut <= 5'b10000;
                6'b000001: rxOut <= 5'b01000;
                6'b000010: rxOut <= 5'b00100;
                6'b000011: rxOut <= 5'b00010;
                6'b000100: rxOut <= 5'b00001;
                default: rxOut <= 5'b00000;
            endcase
        end
        st3: begin
            done <= 0;rxOut <= 5'b00000;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
        end
        st4: begin
            done <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
            case(param2) // Figure out which gen reg EN to assert
                6'b000000: rxOut <= 5'b10000;
                6'b000001: rxOut <= 5'b01000;
                6'b000010: rxOut <= 5'b00100;
                6'b000011: rxOut <= 5'b00010;
                6'b000100: rxOut <= 5'b00001;
                default: rxOut <= 5'b00000;
            endcase
        end
        st5: begin
            done <= 0;ALUin0 <= 0;ALUin1 <= 1;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
            case(param2) // Figure out which gen reg EN to assert
                6'b000000: rxOut <= 5'b10000;
                6'b000001: rxOut <= 5'b01000;
                6'b000010: rxOut <= 5'b00100;
                6'b000011: rxOut <= 5'b00010;
                6'b000100: rxOut <= 5'b00001;
                default: rxOut <= 5'b00000;
            endcase
        end
        st6: begin
            done <= 0;rxOut <= 5'b00000;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 1;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
        end
        st7: begin
            done <= 0;rxOut <= 5'b00000;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 1;rxIn <= 5'b00000;pcInc <= 0;
        end
        st8: begin
            done <= 0;rxOut <= 5'b00000;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 1;pcInc <= 0;
            case(param1) // Figure out which gen reg EN to assert
                6'b000000: rxIn <= 5'b10000;
                6'b000001: rxIn <= 5'b01000;
                6'b000010: rxIn <= 5'b00100;
                6'b000011: rxIn <= 5'b00010;
                6'b000100: rxIn <= 5'b00001;
                default: rxIn <= 5'b00000;
            endcase
        end
        st9: begin
            done <= 1;rxOut <= 5'b00000;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
        end
        st10: begin
            done <= 0;rxOut <= 5'b00000;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxIn <= 5'b00000;pcInc <= 0;
        end
    endcase
end

endmodule