module controller(
    opcode,
    funct3,
    funct7,
    ResultSrc,
    MemWrite,
    ALUSrc_A,
    ALUSrc_B,
    ImmSrc,
    RegWrite,
    ALUControl,
    PCSrc,
    Csr
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input funct7;
    // output
    output MemWrite, ALUSrc_B, RegWrite;
    output [1:0] ResultSrc, ALUSrc_A, PCSrc;
    output [2:0] ImmSrc;
    output [4:0] ALUControl;
    output Csr;
    
    wire [1:0] ALUop;

    wire MemWrite, ALUSrc_B, RegWrite, Branch, BranchE, Jal, Jalr;
    wire [1:0] ResultSrc, ALUSrc_A, PCSrc;
    wire [2:0] ImmSrc;
    wire [4:0] ALUControl;
    wire [3:0] NZCV;
    wire [31:0] InstrD;
    wire [2:0] funct3E;

    maindec mdec(
        .opcode(opcode),
        // output
        .Branch(Branch),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jal(Jal),
        .Jalr(Jalr),
        .ALUop(ALUop),
        .Csr(Csr)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        // output
        .ALUControl(ALUControl)
    );

	blogic u_blogic(
        .funct3(funct3),
        .opcode(opcode),
        .N(NZCV[3]),
        .Z(NZCV[2]),
        .C(NZCV[1]),
        .V(NZCV[0]),
        .Branch(Branch),
        .Jal(Jal),
        .Jalr(Jalr),
        // output
        .PCSrc(PCSrc)
    );
    
endmodule
