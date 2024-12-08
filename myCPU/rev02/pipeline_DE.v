module pipeline_DE(
    clk,
    n_rst,
    clr,
    bef_SrcA,
    bef_SrcB,
    PCD,
    Rs1D,
    Rs2D,
    RdD,
    funct3D,
    ImmExtD,
    PC_Plus4D,
    RD1E,
    RD2E,
    PCE,
    Rs1E,
    Rs2E,
    RdE,
    funct3E,
    ImmExtE,
    PC_Plus4E
);

parameter   RESET_PC = 32'h1000_0000;

input clk, n_rst, clr;
input [31:0] bef_SrcA, bef_SrcB, PCD, ImmExtD, PC_Plus4D;
input [4:0] Rs1D, Rs2D, RdD;
input [2:0] funct3D;

output [31:0] RD1E, RD2E, PCE, ImmExtE, PC_Plus4E;
output [4:0] RdE, Rs1E, Rs2E;
output [2:0] funct3E;

flopr # (
        .RESET_VALUE (0),
        .WIDTH(32)
) u_RD1_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(bef_SrcA),
        .q(RD1E)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(32)
) u_RD2_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(bef_SrcB),
        .q(RD2E)
    );

flopr # (
        .RESET_VALUE (RESET_PC),
        .WIDTH(32)
) u_PC_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(PCD),
        .q(PCE)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(32)
) u_ImmExt_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(ImmExtD),
        .q(ImmExtE)
    );

flopr # (
        .RESET_VALUE (RESET_PC + 32'h4),
        .WIDTH(32)
) u_PCPlus4_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(PC_Plus4D),
        .q(PC_Plus4E)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(5)
) u_Rd_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(RdD),
        .q(RdE)
    );

flopr #(
        .RESET_VALUE(0),
        .WIDTH(3)
    ) u_funct3_DE
    (
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(funct3D),
        .q(funct3E)
    );

flopr #(
        .RESET_VALUE(0),
        .WIDTH(5)
    ) u_Rs1_DE
    (
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(Rs1D),
        .q(Rs1E)
    );

flopr #(
        .RESET_VALUE(0),
        .WIDTH(5)
    ) u_Rs2_DE
    (
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(Rs2D),
        .q(Rs2E)
    );

endmodule