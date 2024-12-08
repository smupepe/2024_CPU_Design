module pipeline_cDE(
    // input
    clk,
    n_rst,
    clr,
    RegWriteD,
    ResultSrcD,
    MemWriteD,
    ALUControlD,
    ALUSrc_AD,
    ALUSrc_BD,
    PCSrc,
    // output
    RegWriteE,
    ResultSrcE,
    MemWriteE,
    ALUControlE,
    ALUSrc_AE,
    ALUSrc_BE,
    PCSrcE
);

input clk, n_rst, clr;
input RegWriteD,  MemWriteD, ALUSrc_BD;
input [4:0] ALUControlD;
input [1:0] ALUSrc_AD, ResultSrcD, PCSrc;

output RegWriteE, MemWriteE, ALUSrc_BE;
output [4:0] ALUControlE;
output [1:0] ALUSrc_AE, ResultSrcE, PCSrcE;

flopr # (
        .RESET_VALUE (0),
        .WIDTH(1)
) u_Regwrite_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(RegWriteD),
        .q(RegWriteE)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(2)
) u_ResultSrc_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(ResultSrcD),
        .q(ResultSrcE)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(1)
) u_Memwrite_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(MemWriteD),
        .q(MemWriteE)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(5)
) u_ALUControl_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(ALUControlD),
        .q(ALUControlE)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(2)
) u_ALUSrcA_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(ALUSrc_AD),
        .q(ALUSrc_AE)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(1)
) u_ALUSrcB_DE(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(ALUSrc_BD),
        .q(ALUSrc_BE)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(2)
) u_PCSrc_E(
        .clk(clk),
        .n_rst(n_rst),
        .clr(clr),
        .d(PCSrc),
        .q(PCSrcE)
    );

endmodule