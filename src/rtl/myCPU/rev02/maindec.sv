module maindec(
 //   Btaken,
    opcode,
    Branch,
    ResultSrc,
    MemWrite,
    ALUSrc_A,
    ALUSrc_B,
    ImmSrc,
    RegWrite,
    // Jump,
    Jal,
    Jalr,
    ALUop,
    Csr
);
    // input
  //  input Btaken;
    input [6:0] opcode;
    // output
    output reg MemWrite, RegWrite, Jal, Jalr, ALUSrc_B, Branch;
    output reg [1:0] ALUSrc_A, ALUop;
    output reg [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output Csr;

    always@(*) begin    // main decoder
        case(opcode)//         1        3       2         1         1          2         1      2     1     1
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b100_0001_0010_0000;     // lw
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b000_1001_1000_0000;     // sw
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b1xx_x000_0000_1000;     // R-type
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b110_0101_0000_0000;     // lui
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b001_0000_0001_0100;	  // beq, bne, blt
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b100_0001_0000_1000;     // I-type ALU
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b101_1000_0100_xx10;     // jal
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b100_0001_0100_0001;     // jalr
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b110_0011_0000_0000;     // auipc
            7'b111_0011 : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'b100_0001_0000_0000;     // csrrw
            default : {RegWrite, ImmSrc, ALUSrc_A, ALUSrc_B, MemWrite, ResultSrc, Branch, ALUop, Jal, Jalr} = 15'hx;
        endcase
    end

    assign Csr = (opcode == 7'b111_0011)? 1'b1 : 1'b0;

endmodule
