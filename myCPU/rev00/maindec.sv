module maindec(
    Btaken,
    opcode,
    Branch,
    ResultSrc,
    MemWrite,
    ALUSrc_A,
    ALUSrc_B,
    ImmSrc,
    RegWrite,
    Jump,
    ALUop,
    Csr
);
    // input
    input Btaken;
    input [6:0] opcode;
    // output
    output reg MemWrite, RegWrite, Jump, ALUSrc_B, Branch;
    output reg [1:0] ALUSrc_A, ALUop;
    output reg [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output Csr;

    always@(*) begin    // main decoder
        case(opcode)//         1        3       2         1         1          2         1      2      1
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1001_0000;     // lw
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b00_0100_1100_0000;     // sw
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1x_xx00_0000_0100;     // R-type
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0010_1000_0000;     // lui
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b00_1000_0000_1010;	    // beq, bne, blt
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1000_0100;     // I-type ALU
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_1100_0010_0xx1;     // jal
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1010_0001;     // jalr
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0001_1000_0000;     // auipc
            7'b111_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1000_0000;     // csrrw
            default : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'hx;
        endcase
    end

    assign Csr = (opcode == 7'b111_0011)? 1'b1 : 1'b0;

endmodule
