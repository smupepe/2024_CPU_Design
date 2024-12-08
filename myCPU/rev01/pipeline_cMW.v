module pipeline_cMW(
    clk,
    n_rst,
    RegWriteM,
    ResultSrcM,
    // output 
    RegWriteW,
    ResultSrcW
);
parameter   RESET_PC = 32'h1000_0000;

input clk, n_rst;
input RegWriteM;
input [1:0] ResultSrcM;

output RegWriteW;
output [1:0] ResultSrcW;

flopr # (
        .RESET_VALUE (0),
        .WIDTH(1)
) u_Regwrite_MW(
        .clk(clk),
        .n_rst(n_rst),
        // .clr(1'b0),
        .d(RegWriteM),
        .q(RegWriteW)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(2)
) u_ResultSrc_MW(
        .clk(clk),
        .n_rst(n_rst),
        // .clr(1'b0),
        .d(ResultSrcM),
        .q(ResultSrcW)
    );

endmodule