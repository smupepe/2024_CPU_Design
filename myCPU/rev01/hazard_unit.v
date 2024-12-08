module hazard_unit(   
    // Rs1D,
    // Rs2D,
    //RdE,
    Rs1E,
    Rs2E,
    RdM,
    RdW,
    RegWriteM,
    RegWriteW,
    // ResultSrcE0,
    // PCSrcE,
    ForwardAE,
    ForwardBE
    // StallF,
    // StallD,
    // FlushE,
    // FlushD
);


input [4:0] /*Rs1D, Rs2D,*/ Rs1E, Rs2E, RdM, RdW/*, RdE*/;
input RegWriteM, RegWriteW/*, ResultSrcE0*/;
//input [1:0] PCSrcE;

output [1:0] ForwardAE, ForwardBE;
// output StallF, StallD, FlushE, FlushD;

wire lwStall;

assign ForwardAE = ((Rs1E == RdM) && RegWriteM) && (Rs1E != 0) ? 2'b10 :
                    ((Rs1E == RdW) && RegWriteW) && (Rs1E != 0) ? 2'b01 : 2'b00;

assign ForwardBE = ((Rs2E == RdM) && RegWriteM) && (Rs2E != 0) ? 2'b10 :
                    ((Rs2E == RdW) && RegWriteW) && (Rs2E != 0) ? 2'b01 : 2'b00;

// assign lwStall = ResultSrcE0 && ((Rs1D == RdE) || (Rs2D == RdE)) ? 1'b1 : 1'b0;

// assign StallF = lwStall;
// assign StallD = lwStall;
// assign FlushE = (lwStall || (PCSrcE != 2'b00)) ? 1'b1 : 1'b0;
// assign FlushD = (PCSrcE != 2'b00) ? 1'b1 : 1'b0;
endmodule