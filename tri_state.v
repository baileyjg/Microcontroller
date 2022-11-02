// Tri-State Buffer
// Author: Bailey Grimes
// Date: 10/21/22

`timescale 1ns/10ps
module tri_state(en, data, q);
    input[15:0] data;
    input en;
    output reg[15:0] q;

    always @(en or data) begin
        if(en)
            q <= data;
        else
            q <= 16'bzzzz; 
    end
endmodule