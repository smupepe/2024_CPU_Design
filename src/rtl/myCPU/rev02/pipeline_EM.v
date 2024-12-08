module pipeline_EM(
    clk,
    n_rst,
    ALUResultE,
    WriteDataE,
    RdE,
    funct3E,
    PC_Plus4E,
    ALUResultM,
    WriteDataM,
    RdM,
    funct3M,
    PC_Plus4M
);

parameter   RESET_PC = 32'h1000_0000;

input clk, n_rst;
input [31:0] ALUResultE, WriteDataE, PC_Plus4E;
input [4:0] RdE;
input [2:0] funct3E;

output [31:0] ALUResultM, WriteDataM, PC_Plus4M;
output [4:0] RdM;
output [2:0] funct3M;

flopr # (
        .RESET_VALUE(0),
        .WIDTH(32)
) u_ALUResult_EM(
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(ALUResultE),
        .q(ALUResultM)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(32)
) u_WriteData_EM(
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(WriteDataE),
        .q(WriteDataM)
    );

flopr # (
        .RESET_VALUE (RESET_PC + 32'h4),
        .WIDTH(32)
) u_PCPlus4_EM(
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(PC_Plus4E),
        .q(PC_Plus4M)
    );

flopr # (
        .RESET_VALUE (0),
        .WIDTH(5)
) u_Rd_EM(
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(RdE),
        .q(RdM)
    );
    
flopr #(
        .RESET_VALUE(0),
        .WIDTH(3)
    ) u_funct3_EM
    (
        .clk(clk),
        .n_rst(n_rst),
        .clr(1'b0),
        .d(funct3E),
        .q(funct3M)
    );

endmodule