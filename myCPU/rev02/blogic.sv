module blogic(
    funct3,
    opcode,
    N,
    Z,
    C,
    V,
    Branch,
    Jal,
    Jalr,
    PCSrc
);

input [2:0] funct3;
input [6:0] opcode;
input N, Z, C, V;
input Branch, Jal, Jalr;

output reg [1:0] PCSrc;

reg Btaken;

always @(*) begin
    if (Branch == 1'b1) begin
        if (funct3 == 3'b000) begin
            Btaken = (Z == 1'b1)? 1'b1 : 1'b0; // beq
        end
        else if (funct3 == 3'b001) begin
            Btaken = (Z == 1'b0)? 1'b1 : 1'b0; // bne
        end
        else if (funct3 == 3'b100) begin
            Btaken = (N != V)? 1'b1 : 1'b0; // blt
        end
        else if (funct3 == 3'b110) begin
            Btaken = (C == 1'b0)? 1'b1 : 1'b0; // bltu 
        end
        else if (funct3 == 3'b111) begin
            Btaken = (C == 1'b1)? 1'b1 : 1'b0; // bgeu
        end
        else if (funct3 == 3'b101) begin
            Btaken = ((N == V)) ? 1'b1 : 1'b0; // bge
        end
    end

    else begin
        Btaken = 1'b0;
    end
end

always @(*) begin
    if ((Btaken == 1'b1) && (opcode == 7'b110_0011)) begin
        PCSrc = 2'b01;
    end
    else if (Jal == 1'b1) begin // jal
        PCSrc = 2'b01;
    end
    else if (Jalr == 1'b1) begin // jalr
        PCSrc = 2'b10;
    end
    else begin
        PCSrc = 2'b00;
    end
end

endmodule