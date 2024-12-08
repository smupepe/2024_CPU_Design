module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
    PCSrc,         // from controller ......
    ResultSrcW,
    // ResultSrcE0,
    ALUControlE,
    ALUSrc_AE,
    ALUSrc_BE,
    ImmSrcD,
    RegWriteM,
    RegWriteW,
    Csr,
    //output
    PCF,            // for imem  
    ALUResult,     // for dmem ..
    WriteData,      
    NZCV, // for controller 
    byte_enable,
    opcode,
    funct3,
    funct7
    // FlushE
);

    parameter   RESET_PC = 32'h1000_0000;

    //input
    input clk, n_rst, ALUSrc_BE, RegWriteM, RegWriteW, Csr/*, ResultSrcE0*/;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrcW, PCSrc, ALUSrc_AE;
    input [2:0] ImmSrcD;
    input [4:0] ALUControlE;
    
    //output
    output [31:0] PCF, ALUResult;
    output [31:0] WriteData;
    output [3:0] NZCV;
    output [3:0] byte_enable;
    output [6:0] opcode;
    output [2:0] funct3;
    output funct7/*, FlushE*/;

    wire [31:0] PC_next, PC_target, PC_Plus4;
    wire [31:0] ImmExt, be_rd, be_wd, ReadDataW;
    wire [31:0] SrcA, bef_SrcB;
    wire [31:0] SrcB, bef_SrcA;
    wire [31:0] Result;
    wire [4:0] uImm;

    wire [31:0] PC_Plus4F, PC_Plus4D, PC_Plus4E, PC_Plus4M, PC_Plus4W;
    wire [31:0] PC_targetE;
    wire [31:0] PCD, PCE;
    wire [31:0] ALUResultE, ALUResultM, ALUResultW;
    wire [31:0] ResultW, ImmExtE, InstrD, WriteDataM, WriteDataW, InstrF;
    wire [2:0] funct3D, funct3E, funct3M, funct3W;
    wire [31:0] RD1E, RD2E;
    wire [4:0] RdE, RdW, RdM;
    wire [1:0] ResultSrcE;

    wire [4:0] Rs1D = InstrD[19:15];
    wire [4:0] Rs2D = InstrD[24:20];
    wire [4:0] Rs1E, Rs2E;
 
    // wire StallF, StallD, FlushD;
    reg [31:0] tohost_csr;
        
    assign WriteData = be_wd;
    assign uImm = Instr[19:15];
    
    // Csr
    always @(*) begin
        if (Csr == 1'b1) begin
            case (Instr[14:12])
                3'b001 : tohost_csr = bef_SrcA;
                3'b101 : tohost_csr = {27'b0, {uImm}};
                default : tohost_csr = 32'h0;
            endcase
        end

        else
            tohost_csr = 32'h0;
    end

    mux3 u_pc_mux3(
        .in0(PC_Plus4F),
        .in1(PC_targetE),
        .in2(ALUResultE),
        .sel(PCSrc),
        .out(PC_next)
    );
    
    flopr # (
        .RESET_VALUE (RESET_PC),
        .WIDTH(32)
    ) u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .d(PC_next),
        .q(PCF)
    );

    adder u_pc_plus4(
        .a(PCF), 
        .b(32'h4), 
        .ci(1'b0), 
        .sum(PC_Plus4F),
        .N(),
        .Z(),
        .C(),
        .V()
    );
    
    pipeline_FD # (
        .RESET_PC(RESET_PC)
    ) u_pipeline_FD(
        .clk(clk),
        .n_rst(n_rst),
        .en(1'b1),
        // .clr(FlushD),
        .InstrF(Instr),
        .PCF(PCF),
        .PC_Plus4F(PC_Plus4F),
        .InstrD(InstrD),
        .PCD(PCD),
        .PC_Plus4D(PC_Plus4D)
    );
    
    assign opcode = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[30];

    extend u_Extend(
        .ImmSrc(ImmSrcD),
        .in(InstrD[31:7]),
        .out(ImmExt)
    );

    reg_file_async rf (
        .clk        (clk),
        .clkb       (clk),
        .we         (RegWriteW),
        .ra1        (InstrD[19:15]),
        .ra2        (InstrD[24:20]),
        .wa         (RdW),
        .wd         (ResultW),
        // output
        .rd1        (bef_SrcA),
        .rd2        (bef_SrcB)
    );

    pipeline_DE # (
        .RESET_PC(RESET_PC)
    ) u_pipeline_DE(
        .clk(clk),
        .n_rst(n_rst),
        // .clr(FlushE),
        .bef_SrcA(bef_SrcA),
        .bef_SrcB(bef_SrcB),
        .PCD(PCD),
        .Rs1D(InstrD[19:15]),
        .Rs2D(InstrD[24:20]),
        .RdD(InstrD[11:7]),
        .funct3D(InstrD[14:12]),
        .ImmExtD(ImmExt),
        .PC_Plus4D(PC_Plus4D),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .funct3E(funct3E),
        .ImmExtE(ImmExtE),
        .PC_Plus4E(PC_Plus4E)
    );

    adder u_pc_target(
        .a(PCE), 
        .b(ImmExtE), 
        .ci(1'b0), 
        .sum(PC_targetE),
        .N(),
        .Z(),
        .C(),
        .V()
    );

    wire [31:0] SrcAE, SrcBE;
    wire [1:0]  ForwardAE, ForwardBE;

    mux3 u_RD1E_mux3(
        .in0(RD1E),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardAE),
        .out(SrcA)
    );

    mux3 u_RD2E_mux3(
        .in0(RD2E),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardBE),
        .out(SrcB)
    );

    mux2 u_alu_mux2(
        .in0(SrcB),
        .in1(ImmExtE),
        .sel(ALUSrc_BE),
        .out(SrcBE)
    );

    mux3 u_alu_mux3(
        .in0(SrcA),
        .in1(PCE),
        .in2(32'd0),
        .sel(ALUSrc_AE),
        .out(SrcAE)
    );

    alu u_ALU(
        .a_in(SrcAE),
        .b_in(SrcBE),
        .ALUControl(ALUControlE),
        .result(ALUResultE),
        .NZCV(NZCV)
    );
    
    pipeline_EM  # (
        .RESET_PC(RESET_PC)
    ) u_pipeline_EM(
        .clk(clk),
        .n_rst(n_rst),
        .ALUResultE(ALUResultE),
        .WriteDataE(SrcB),
        .RdE(RdE),
        .funct3E(funct3E),
        .PC_Plus4E(PC_Plus4E),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .funct3M(funct3M),
        .PC_Plus4M(PC_Plus4M)
    );

    be_logic u_be_logic_m( // write(mem stage)
        .w_d(WriteDataM),
        .r_d(),
        .addr_last2(ALUResultM[1:0]),
        .funct3(funct3M),
        .be_wd(be_wd),
        .be_rd(),
        .byte_enable(byte_enable)
    );

    be_logic u_be_logic_w( // read(write-back stage)
        .w_d(),
        .r_d(ReadDataW),
        .addr_last2(ALUResultW[1:0]),
        .funct3(funct3W),
        .be_wd(),
        .be_rd(be_rd),
        .byte_enable()
    );

    pipeline_MW  # (
        .RESET_PC(RESET_PC)
    ) u_pipeline_MW(
        .clk(clk),
        .n_rst(n_rst),
        .ALUResultM(ALUResultM),
        .ReadData(ReadData),
        .RdM(RdM),
        .PC_Plus4M(PC_Plus4M),
        .funct3M(funct3M),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .RdW(RdW),
        .PC_Plus4W(PC_Plus4W),
        .funct3W(funct3W)
    );

    assign ALUResult = ALUResultM;

    hazard_unit u_hazard_unit(
        // .Rs1D(InstrD[19:15]),
        // .Rs2D(InstrD[24:20]),
        // .RdE(RdE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        // .ResultSrcE0(ResultSrcE[0]),
        // .PCSrcE(PCSrc),
        //output
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
        // .StallF(StallF),
        // .StallD(StallD),
        // .FlushE(FlushE),
        // .FlushD(FlushD)
    );

    mux3 u_result_mux3(
        .in0(ALUResultW),
        .in1(be_rd),
        .in2(PC_Plus4W),
        .sel(ResultSrcW),
        .out(ResultW)
    );

endmodule
