`timescale 1ns/10ps

module mem(MFC, en, addr, in, rw, out);
    input en, rw;
    input[15:0] addr, in;
    output reg[15:0] out;
    output reg MFC;

    reg[15:0] memorycell;

    always @(posedge en) begin
        if(rw==1)
            case(addr)
                16'b0000000000000000:
                    out = 16'b0110000010100011; // MOVI R2, #35
                16'b0000000000000001:
                    out = 16'b0001000010000001; // ADDI R2, #1
                16'b0000000000000010:
                    out = 16'b0101000100000010; // MOV P0, R2
                16'b0000000000000011:
                    out = 16'b0010000100011101; // SUBI P0, #1D
                16'b0000000000000100:
                    out = 16'b1110000010000100; // XOR R2, P0
                16'b0000000000000101:
                    out = 16'b1011000010000000; // NOT R2
                16'b0000000000000110:
                    out = 16'b0100000100000010; // STORE P0, (R2)
                16'b0000000000000111:
                    out = 16'b0011000010000011; // LOAD (R2), R3
                default:
                    out = memorycell;
            endcase
        else
            memorycell = in;
        #5 MFC = 1;
    end

    always @(negedge en) begin
        MFC = 0;
    end

endmodule