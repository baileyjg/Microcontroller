// Move Finite State Machine
// Author: Bailey Grimes
// Date: 11/23/22

`timescale 1ns/10ps

module MOVFSM(clk, rst, instruction, done, rxOut, rxIn, pcInc, IF_active);
    input clk, rst, IF_active;
    input[15:0] instruction;
    wire[3:0] opCode = instruction[15:12];
    wire[5:0] param1 = instruction[11:6];
    wire[5:0] param2 = instruction[5:0];

    output reg done, pcInc;
    output reg[5:0] rxOut, rxIn;

    reg[2:0] pres_state, next_state;
    parameter st0 = 3'b000, st1 = 3'b001, st2 = 3'b010, st3 = 3'b011, st4 = 3'b100;

    // State register
    always @(posedge clk or posedge rst) begin
        if(rst)
            pres_state <= st0;
        else if(IF_active)
            pres_state <= st0;
        else if(opCode == 4'b0101)
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
            st4: next_state <= st4;
            default: next_state <= st0;
        endcase
    end

    // Output definition
    always @(pres_state) begin
        case(pres_state)
            st0: begin
                done <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;
            end
            st1: begin
                done <= 0;rxIn <= 6'b000000;pcInc <= 1;
                case(param2) // Pull the data from the gen reg in param2
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
                done <= 0;pcInc <= 0;
                case(param2) // Pull the data from the gen reg in param2
                    6'b000000: rxOut <= 6'b100000;
                    6'b000001: rxOut <= 6'b010000;
                    6'b000010: rxOut <= 6'b001000;
                    6'b000011: rxOut <= 6'b000100;
                    6'b000100: rxOut <= 6'b000010;
                    6'b000101: rxOut <= 6'b000001;
                    default: rxOut <= 6'b000000;
                endcase
                case(param1) // Store the data into the gen reg in param1
                    6'b000000: rxIn <= 6'b100000;
                    6'b000001: rxIn <= 6'b010000;
                    6'b000010: rxIn <= 6'b001000;
                    6'b000011: rxIn <= 6'b000100;
                    6'b000100: rxIn <= 6'b000010;
                    6'b000101: rxIn <= 6'b000001;
                    default: rxIn <= 6'b000000;
                endcase
            end
            st3: begin
                done <= 1;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;
            end
            st4: begin
                done <= 0;rxOut <= 6'b000000;rxIn <= 6'b000000;pcInc <= 0;
            end
        endcase
    end
endmodule