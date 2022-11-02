// ALU
// Author: Bailey Grimes
// Date: 11/2/22

`timescale 1ns/10ps
module ALU(in0, in1, op, out);
    input[2:0] op;
    input[15:0] in0, in1;
    output reg[15:0] out;

    always @(op, in0, in1) begin
        case(op)
            3'b000:
                out <= in0 + in1;
            3'b001:
                out <= in0 - in1;
            3'b010:
                out <= ~in0;
            3'b011:
                out <= in0 & in1;
            3'b100:
                out <= in0 | in1;
            3'b101:
                out <= in0 ^ in1;
            3'b110:
                out <= in0 ~^ in1;
            default:
                out <= 16'b0000000000000000;
        endcase
    end
endmodule