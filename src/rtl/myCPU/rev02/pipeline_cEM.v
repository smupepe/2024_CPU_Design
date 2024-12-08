module pipeline_cEM(
    // input
    clk,
    n_rst,
    RegWriteE, // 1bit
    ResultSrcE, // 2bit
    MemWriteE, // 1bit
    // output
    RegWriteM, // 1bit
    ResultSrcM, // 2bit
    MemWriteM // 1bit
);

parameter   RESET_PC = 32'h1000_0000;

input clk, n_rst;
input RegWriteE, MemWriteE;
input [1:0] ResultSrcE;

output RegWriteM, MemWriteM;
output [1:0] ResultSrcM;

flopr # (
        .RESET_VALUE (0),
        .WIDTH(1)
) u_Regwrite_EM(
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(RegWriteE),
        .q(RegWriteM)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(2)
) u_ResultSrc_EM(
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(ResultSrcE),
        .q(ResultSrcM)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(1)
) u_MemWrite_EM(
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(MemWriteE),
        .q(MemWriteM)
    );

endmodule