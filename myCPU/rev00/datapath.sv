module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
    PCSrc,         // from controller ......
    ResultSrc,
    ALUControl,
    ALUSrc_A,
    ALUSrc_B,
    ImmSrc,
    RegWrite,
    Csr,
    PC,            // for imem  
    ALUResult,     // for dmem ..
    WriteData,      
    NZCV, // for controller 
    byte_enable
);

    parameter   RESET_PC = 32'h1000_0000;

    //input
    input clk, n_rst, ALUSrc_B, RegWrite, Csr;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrc, PCSrc, ALUSrc_A;
    input [2:0] ImmSrc;
    input [4:0] ALUControl;
    
    //output
    output [31:0] PC, ALUResult;
    output [31:0] WriteData;
    output [3:0] NZCV;
    output [3:0] byte_enable;

    wire [31:0] PC_next, PC_target, PC_plus4;
    wire [31:0] ImmExt, be_rd, be_wd;                       
    wire [31:0] SrcA, bef_SrcB;
    wire [31:0] SrcB, bef_SrcA;
    wire [31:0] Result;
    wire [4:0] uImm;

    reg [31:0] tohost_csr;
    
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
        .in0(PC_plus4),
        .in1(PC_target),
        .in2(ALUResult),
        .sel(PCSrc),
        .out(PC_next)
    );
    
    flopr # (
        .RESET_VALUE (RESET_PC)
    ) u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .d(PC_next),
        .q(PC)
    );

    adder u_pc_plus4(
        .a(PC), 
        .b(32'h4), 
        .ci(1'b0), 
        .sum(PC_plus4),
        .N(),
        .Z(),
        .C(),
        .V()
    );

    extend u_Extend(
        .ImmSrc(ImmSrc),
        .in(Instr[31:7]),
        .out(ImmExt)
    );

    adder u_pc_target(
        .a(PC), 
        .b(ImmExt), 
        .ci(1'b0), 
        .sum(PC_target),
        .N(),
        .Z(),
        .C(),
        .V()
    );
    
    reg_file_async rf (
        .clk        (clk),
        .clkb       (clk),
        .we         (RegWrite),
        .ra1        (Instr[19:15]),
        .ra2        (Instr[24:20]),
        .wa         (Instr[11:7]),
        .wd         (Result),
        .rd1        (bef_SrcA),
        .rd2        (bef_SrcB)
    );

    mux2 u_alu_mux2(
        .in0(bef_SrcB),
        .in1(ImmExt),
        .sel(ALUSrc_B),
        .out(SrcB)
    );

    mux3 u_alu_mux3(
        .in0(bef_SrcA),
        .in1(PC),
        .in2(32'd0),
        .sel(ALUSrc_A),
        .out(SrcA)
    );

    alu u_ALU(
        .a_in(SrcA),
        .b_in(SrcB),
        .ALUControl(ALUControl),
        .result(ALUResult),
        .NZCV(NZCV)
    );

    be_logic u_be_logic(
        .w_d(bef_SrcB),
        .r_d(ReadData),
        .addr_last2(ALUResult[1:0]),
        .funct3(Instr[14:12]),
        .be_wd(WriteData),
        .be_rd(be_rd),
        .byte_enable(byte_enable)
    );

    mux3 u_result_mux3(
        .in0(ALUResult),
        .in1(be_rd),
        .in2(PC_plus4),
        .sel(ResultSrc),
        .out(Result)
    );

endmodule
