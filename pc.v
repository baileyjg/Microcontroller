// Program Counter
// Author: Bailey Grimes
// Date: 11/9/22

`timescale 1ns/10ps

module PC(inc, rst, out);
input rst, inc;
output reg[15:0] out;

always @(inc or rst) begin
    if(rst)
        out <= 16'b0000000000000000;
    else if(inc)
        out <= out + 1;
end
endmodule