module controller(
    Btaken,
    opcode,
    funct3,
    funct7,
    PCSrc,
    Branch,
    ResultSrc,
    MemWrite,
    ALUSrc_A,
    ALUSrc_B,
    ImmSrc,
    RegWrite,
    ALUControl,
    Jump,
    Csr
);
    // input
    input Btaken;
    input [6:0] opcode;
    input [2:0] funct3;
    input funct7;
    // output
    output [1:0] PCSrc;
    output MemWrite, ALUSrc_B, RegWrite, Branch, Jump;
    output [1:0] ResultSrc, ALUSrc_A;
    output [2:0] ImmSrc;
    output [4:0] ALUControl;
    output Csr;
    
    wire [1:0] ALUop;

    maindec mdec(
        .Btaken(Btaken),
        .opcode(opcode),
        .Branch(Branch),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUop(ALUop),
        .Csr(Csr)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

    assign PCSrc = ((Btaken == 1'b1) && (opcode == 7'b110_0011))? 2'b01: 
                    (opcode == 7'b110_1111) ? 2'b01 : // Jal, b-type
                    (opcode == 7'b110_0111) ? 2'b10 : 2'b00; // Jalr
                    
endmodule
