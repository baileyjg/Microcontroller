// Program Counter
// Author: Bailey Grimes
// Date: 11/9/22

`timescale 1ns/10ps

module PC(clk, inc, rst, out);
input clk, rst, inc;
output reg[15:0] out;

always @(posedge clk or posedge rst) begin
    if(rst)
        out <= 16'b0000000000000000;
    else if(inc)
        out <= out + 1;
end
endmodule