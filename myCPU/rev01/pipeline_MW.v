module pipeline_MW(
    clk,
    n_rst,
    ALUResultM,
    ReadData,
    RdM,
    PC_Plus4M,
    funct3M,
    ALUResultW,
    ReadDataW,
    RdW,
    PC_Plus4W,
    funct3W
);

parameter   RESET_PC = 32'h1000_0000;

input clk, n_rst;
input [31:0] ALUResultM, ReadData, PC_Plus4M;
input [4:0] RdM;
input [2:0] funct3M;

output [31:0] ALUResultW, ReadDataW, PC_Plus4W;
output [4:0] RdW;
output [2:0] funct3W;

flopr # (
        .RESET_VALUE (0),
        .WIDTH(32)
) u_ALUResult_MW(
        .clk(clk),
        .n_rst(n_rst),
        // .clr(1'b0),
        .d(ALUResultM),
        .q(ALUResultW)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(32)
) u_ReadData_MW(
        .clk(clk),
        .n_rst(n_rst),
        // .clr(1'b0),
        .d(ReadData),
        .q(ReadDataW)
    );

flopr # (
        .RESET_VALUE (RESET_PC + 32'h4),
        .WIDTH(32)
) u_PCPlus4_MW(
        .clk(clk),
        .n_rst(n_rst),
        // .clr(1'b0),
        .d(PC_Plus4M),
        .q(PC_Plus4W)
    );

flopr # (
        .RESET_VALUE (RESET_PC),
        .WIDTH(5)
) u_Rd_MW(
        .clk(clk),
        .n_rst(n_rst),
        // .clr(1'b0),
        .d(RdM),
        .q(RdW)
    );

flopr #(
        .RESET_VALUE(0),
        .WIDTH(3)
    ) u_func3_MW
    (
        .clk(clk),
        .n_rst(n_rst),
        // .clr(1'b0),
        .d(funct3M),
        .q(funct3W)
    );

endmodule