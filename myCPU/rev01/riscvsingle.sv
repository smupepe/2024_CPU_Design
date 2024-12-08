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

	wire [3:0] NZCV;
    wire ALUSrc_BD, RegWriteD, Csr;
    wire [1:0] ResultSrcD, ALUSrc_AD, PCSrc;
	wire [2:0] ImmSrcD;
	wire [4:0] ALUControlD;
	wire BranchD, MemWriteD, JalD, JalrD;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire  funct7;

	controller u_controller(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        // output
        // .Branch(BranchD), 
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .ALUSrc_A(ALUSrc_AD),
        .ALUSrc_B(ALUSrc_BD),
        .ImmSrc(ImmSrcD),
        .RegWrite(RegWriteD),
        .ALUControl(ALUControlD),
        // .Jal(JalD),
        // .Jalr(JalrD),
        .PCSrc(PCSrc),
        .Csr(Csr)
	);

    wire ALUSrc_BE, RegWriteE;
    wire [1:0] ResultSrcE, ALUSrc_AE, PCSrcE;
	wire [4:0] ALUControlE;
	wire BranchE, MemWriteE, JalE, JalrE;
    // wire FlushE;

    pipeline_cDE u_pipeline_cDE(
        // input
        .clk(clk),
        .n_rst(n_rst),
        // .clr(FlushE),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        // .JalD(JalD),
        // .JalrD(JalrD),
        // .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrc_AD(ALUSrc_AD),
        .ALUSrc_BD(ALUSrc_BD),
        .PCSrc(PCSrc),
        // output
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        // .JalE(JalE),
        // .JalrE(JalrE),
        // .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ALUSrc_AE(ALUSrc_AE),
        .ALUSrc_BE(ALUSrc_BE),
        .PCSrcE(PCSrcE)
    );

    wire RegWriteM, MemWriteM;
    wire [1:0] ResultSrcM;

    pipeline_cEM u_pipeline_cEM(
        // input
        .clk(clk),
        .n_rst(n_rst),
        .RegWriteE(RegWriteE), // 1bit
        .ResultSrcE(ResultSrcE), // 2bit
        .MemWriteE(MemWriteE), // 1bit
        // output
        .RegWriteM(RegWriteM), // 1bit
        .ResultSrcM(ResultSrcM), // 2bit
        .MemWriteM(MemWriteM) // 1bit
    );

    assign MemWrite = MemWriteM;

    wire RegWriteW;
    wire [1:0] ResultSrcW;

    pipeline_cMW u_pipeline_cMW(
        .clk(clk),
        .n_rst(n_rst),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        // output 
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW)
    );
	
    datapath #(
		.RESET_PC(RESET_PC)
	) i_datapath(
		.clk(clk),
        .n_rst(n_rst),
        .Instr(Instr),        
        .ReadData(ReadData),
        .PCSrc(PCSrcE),
        .ResultSrcW(ResultSrcW),
        // .ResultSrcE0(ResultSrcE[0]),
        .ALUControlE(ALUControlE),
        .ALUSrc_AE(ALUSrc_AE),
        .ALUSrc_BE(ALUSrc_BE),
        .ImmSrcD(ImmSrcD),
        .RegWriteW(RegWriteW),
        .RegWriteM(RegWriteM),
        .Csr(Csr),
         // output  
        .PCF(PC), 
        .ALUResult(ALUResult),   
        .WriteData(WriteData),      
        .NZCV(NZCV),
        .byte_enable(byte_enable),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7)
        // .FlushE(FlushE)
	);

endmodule
