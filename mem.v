`timescale 1ns/10ps

module mem(MFC, en, addr, in, rw);
    input en, rw;
    input[15:0] addr, in;
    output reg[15:0] out;
    output reg MFC;

    reg memorycell;

    always @(posedge en) begin
        if(rw==1)
            case(addr)
                16'b0000000000000000:
                    out = 1;
                16'b0000000000000001:
                    out = 1;
                16'b0000000000000010:
                    out = 1;
                16'b0000000000000011:
                    out = 1;
                16'b0000000000000100:
                    out = 1;
                16'b0000000000000101:
                    out = 1;
                16'b0000000000000110:
                    out = 1;
                16'b0000000000000111:
                    out = 1;
                default:
                    out = memorycell;
            endcase
        else
            memorycell = in;
    end

    always @(negedge en) begin
        MFC = 0;
    end

endmodule