// Instruction Fetch Finite State Machine

`timescale 1ns/10ps

module IFFSM(clk, rst, done, MFC, PCoutEN, MARin, memEN, RW, MDRreadEN, MDRout, IRin);
input clk; // Clock
input rst, done; // FSM kickstart signals
input MFC; // Memory function complete
output reg PCoutEN, MARin, memEN, RW, MDRreadEN, MDRout, IRin; // FSM output signals

// States
reg[2:0] pres_state, next_state;
parameter st0 = 3'b000, st1 = 3'b001, st2 = 3'b010, st3 = 3'b011, st4 = 3'b100, st5 = 3'b101, st6 = 3'b110, st7 = 3'b111;

// State Register
always @(posedge clk or posedge rst or posedge done or posedge MFC) begin
    if(rst || done) // Kick off the FSM with either reset or done signals
        next_state <= st0;
    else if(pres_state == st3 && MFC) // St3 can only move on if MFC is asserted
        pres_state <= st4;
    else if(pres_state == st3 && !MFC) // Stay in st3 if no MFC
        pres_state <= st3;
    else // Transition to next_state each clk edge
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
        st7: next_state <= st7;
        default: next_state = st0;
    endcase
end

// Moore output definition
always @(pres_state) begin
    case(pres_state)
        st0: begin
            PCoutEN <= 1; MARin <= 0; memEN <= 0; RW <= 0; MDRreadEN <= 0; MDRout <= 0; IRin <= 0;
        end
        st1: begin
            PCoutEN <= 1; MARin <= 1; memEN <= 0; RW <= 0; MDRreadEN <= 0; MDRout <= 0; IRin <= 0;
        end
        st2: begin
            PCoutEN <= 0; MARin <= 0; memEN <= 1; RW <= 0; MDRreadEN <= 0; MDRout <= 0; IRin <= 0;
        end
        st3: begin
            PCoutEN <= 0; MARin <= 0; memEN <= 1; RW <= 1; MDRreadEN <= 0; MDRout <= 0; IRin <= 0;
        end
        st4: begin
            PCoutEN <= 0; MARin <= 0; memEN <= 1; RW <= 1; MDRreadEN <= 1; MDRout <= 0; IRin <= 0;
        end
        st5: begin
            PCoutEN <= 0; MARin <= 0; memEN <= 0; RW <= 1; MDRreadEN <= 0; MDRout <= 1; IRin <= 0;
        end
        st6: begin
            PCoutEN <= 0; MARin <= 0; memEN <= 0; RW <= 1; MDRreadEN <= 0; MDRout <= 1; IRin <= 1;
        end
        st7: begin
            PCoutEN <= 0; MARin <= 0; memEN <= 0; RW <= 0; MDRreadEN <= 0; MDRout <= 0; IRin <= 0;
        end
        default: begin
            PCoutEN <= 0; MARin <= 0; memEN <= 0; RW <= 0; MDRreadEN <= 0; MDRout <= 0; IRin <= 0;
        end
    endcase
end

endmodule