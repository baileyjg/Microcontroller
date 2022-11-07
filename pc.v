`timescale 1ns/10ps

module PC(clk, rst, out);
input clk, rst;
output reg[15:0] out;

always @(posedge clk or posedge rst) begin
    if(rst)
        out <= 16'b0000000000000000;
    else
        out <= out + 1;
end
endmodule