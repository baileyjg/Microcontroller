// D Flip-Flop
// Author: Bailey Grimes
// Date: 10/21/22

`timescale 1ns/10ps
module dff(clk, rst, en, d, q);
    input clk, rst, en;
    input[3:0] d;
    output reg[3:0] q;

    always @(posedge clk or posedge rst) begin
        if(rst)
            q <= 4'b0000;
        else if(en)
            q <= d;
    end
endmodule