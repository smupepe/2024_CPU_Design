module riscvsingle(
	clk,
	n_rst,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData,
    byte_enable
);

	parameter   RESET_PC = 32'h1000_0000;

	//input
	input clk, n_rst;
	input [31:0] Instr, ReadData;
	//output
	output MemWrite;
	output [31:0] PC, ALUResult, WriteData;
    output [3:0] byte_enable;

	wire  ALUSrc_B, RegWrite, Csr;  
	wire [1:0] PCSrc, ResultSrc, ALUSrc_A;
	wire [2:0] ImmSrc;
	wire [4:0] ALUControl;
	wire [3:0] NZCV;
	wire Branch, Btaken;

	controller u_controller(
		.Btaken(Btaken),
        .opcode(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[30]),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .Branch(Branch),
        .Csr(Csr)
	);

	datapath #(
		.RESET_PC(RESET_PC)
	) i_datapath(
		.clk(clk),
        .n_rst(n_rst),
        .Instr(Instr),        
        .ReadData(ReadData),    
        .PCSrc(PCSrc),      
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Csr(Csr),
        .PC(PC),            
        .ALUResult(ALUResult),   
        .WriteData(WriteData),      
        .NZCV(NZCV),
        .byte_enable(byte_enable)
	);

	blogic u_blogic(
        .funct3(Instr[14:12]),
        .N(NZCV[3]),
        .Z(NZCV[2]),
        .C(NZCV[1]),
        .V(NZCV[0]),
        .Branch(Branch),
        .Btaken(Btaken)
    );

endmodule
