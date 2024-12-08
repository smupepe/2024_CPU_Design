module pipeline_FD(
    clk,
    n_rst,
    en,
//     clr,
    InstrF,
    PCF,
    PC_Plus4F,
    InstrD,
    PCD,
    PC_Plus4D
);

parameter   RESET_PC = 32'h1000_0000;

input clk, n_rst, en/*, clr*/;
input [31:0] InstrF, PCF, PC_Plus4F;

output [31:0] InstrD, PCD, PC_Plus4D;

flopenr # (
        .RESET_VALUE (32'h0000_0033),
        .WIDTH(32)
) u_Instr_FD(
        .clk(clk),
        .n_rst(n_rst),
        .en(en),
        // .clr(clr),
        .d(InstrF),
        .q(InstrD)
    );

flopenr # (
        .RESET_VALUE (RESET_PC),
        .WIDTH(32)
) u_PC_FD(
        .clk(clk),
        .n_rst(n_rst),
        .en(en),
        // .clr(clr),
        .d(PCF),
        .q(PCD)
    );

flopenr # (
        .RESET_VALUE (RESET_PC + 32'h4),
        .WIDTH(32)
) u_PCPlus4_FD(
        .clk(clk),
        .n_rst(n_rst),
        .en(en),
        // .clr(clr),
        .d(PC_Plus4F),
        .q(PC_Plus4D)
    );

endmodule