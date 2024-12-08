module pipeline_FD(
    clk,
    n_rst,
    PCF,
    PCPlus4F,
    InstrD,
    PCD,
    PCPlus4D,
);

parameter RESET_VALUE = 32'h0000_0000;

input clk, n_rst;
input [31:0] Instr, PCF, PCPlus4F;

output [31:0] InstrD, PCD, PCPlus4D;

endmodule