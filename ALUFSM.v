`timescale 1ns/10ps

module ALUFSM(clk, rst, activate, done, rx1out, rx2out, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, rxin, pcInc, instruction);
input clk; // Clock
input rst, activate; // Kick start signals
input[15:0] instruction;
wire[3:0] opcode = instruction[15:12];
wire[5:0] param1 = instruction[11:6];
wire[5:0] param2 = instruction[5:0];
output reg done, rx1out, rx2out, ALUin0, ALUin1, ALUoutlatch, ALUoutEN, rxin, pcInc; // Output signals

// States
reg[3:0] pres_state, next_state;
parameter st0 = 4'b0000, st1 = 4'b0001, st2 = 4'b0010, st3 = 4'b0011, st4 = 4'b0100, st5 = 4'b0101, st6 = 4'b0110, st7 = 4'b0111;
parameter st8 = 4'b1000, st9 = 4'b1001, st10 = 4'b1010, st11 = 4'b1011;

// State register
always @(posedge clk or posedge rst or posedge activate) begin
    if(rst)
        pres_state <= st0;
    else if(opcode == 4'b1000 || opcode == 4'b1001 || opcode == 4'b1010 || opcode == 4'b1011 || opcode == 4'b1100 || opcode == 4'b1101 || opcode == 4'b1110)
        pres_state <= next_state;
    else
        pres_state <= next_state;
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
            done <= 0;rx1out <= 0;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
        st1: begin
            done <= 0;rx1out <= 1;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 1;
        end
        st2: begin
            done <= 0;rx1out <= 1;rx2out <= 0;ALUin0 <= 1;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
        st3: begin
            done <= 0;rx1out <= 0;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
        st4: begin
            done <= 0;rx1out <= 0;rx2out <= 1;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
        st5: begin
            done <= 0;rx1out <= 0;rx2out <= 1;ALUin0 <= 0;ALUin1 <= 1;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
        st6: begin
            done <= 0;rx1out <= 0;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 1;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
        st7: begin
            done <= 0;rx1out <= 0;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 1;rxin <= 0;pcInc <= 0;
        end
        st8: begin
            done <= 0;rx1out <= 0;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 1;rxin <= 1;pcInc <= 0;
        end
        st9: begin
            done <= 1;rx1out <= 0;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
        st10: begin
            done <= 0;rx1out <= 0;rx2out <= 0;ALUin0 <= 0;ALUin1 <= 0;ALUoutlatch <= 0;ALUoutEN <= 0;rxin <= 0;pcInc <= 0;
        end
    endcase
end

endmodule