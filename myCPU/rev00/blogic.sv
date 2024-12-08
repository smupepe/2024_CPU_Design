module blogic(
    funct3,
    N,
    Z,
    C,
    V,
    Branch,
    Btaken
);

input [2:0] funct3;
input N, Z, C, V;
input Branch;

output reg Btaken;

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
            Btaken = (C == 1'b0)? 1'b1 : 1'b0; // bltu  x
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


endmodule