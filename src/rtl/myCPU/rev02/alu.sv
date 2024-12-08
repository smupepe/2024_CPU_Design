module alu(
    a_in,
    b_in,
    ALUControl,
    result,
    NZCV
);
    input [31:0] a_in, b_in;
    input [4:0] ALUControl;
    output reg [31:0] result; 
    output [3:0] NZCV;

    reg aN, aZ, aC, aV;           // FLAG 
    wire N, Z, C, V;
    wire [31:0] add_sub_b;
    wire [31:0] adder_result, and_result, or_result, slt_result, xor_result, sll_result, srl_result, sra_result, sltu_result;

    assign add_sub_b = (ALUControl == 5'b1_0000 || ALUControl == 5'b1_1000 || ALUControl == 5'b1_0111) ? ~b_in + 32'h1 : b_in;

    adder u_add_32bit_add(
        .a(a_in),
        .b(add_sub_b),
        .ci(1'b0),
        .sum(adder_result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );    
    
    always@(*)begin
        if (ALUControl == 5'b0_0000 || ALUControl == 5'b1_0111 || ALUControl == 5'b1_1000 || ALUControl == 5'b1_0000) begin
            {aN, aZ, aC, aV} = {N, Z, C, V};
        end
        else if ((ALUControl == 5'b1_0001) || (ALUControl == 5'b1_0010)) begin // bgeu, bltu
            aN = N;
            aZ = Z;
            aC = (a_in >= b_in) ? 1'b1 : 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0001) begin
            aN = and_result[31];
            aZ = (and_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0010) begin
            aN = or_result[31];
            aZ = (or_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0011) begin
            aN = xor_result[31];
            aZ = (xor_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0100) begin
            aN = sll_result[31];
            aZ = (sll_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0101) begin
            aN = srl_result[31];
            aZ = (srl_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0110) begin
            aN = sra_result[31];
            aZ = (sra_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end

        else begin
            {aN, aZ, aC, aV} = 4'h0;	
        end
    end
    
    assign and_result = a_in & b_in;
    assign or_result = a_in | b_in;
    assign xor_result = a_in ^ b_in;
    assign slt_result = aN ^ aV;
    assign sltu_result = (a_in < b_in)? 32'h1 : 32'h0;
    assign sll_result = a_in << b_in[4:0];
    assign srl_result = a_in >> b_in[4:0];
    assign sra_result = $signed(a_in) >>> b_in[4:0];

    always@(*) begin
        case(ALUControl)
            5'b0_0000 : result = adder_result;        // add
            5'b1_0000 : result = adder_result;        // sub
            5'b0_0001 : result = and_result;          // and
            5'b0_0010 : result = or_result;           // or
            5'b0_0011 : result = xor_result;          // xor
            5'b1_0111 : result = slt_result;          // SLT
            5'b1_1000 : result = sltu_result;         // sltu
            5'b0_0100 : result = sll_result;          // sll
            5'b0_0101 : result = srl_result;          // srl
            5'b0_0110 : result = sra_result;          // sra
            default : result = 32'hx;
        endcase
    end

    assign NZCV = {aN, aZ, aC, aV};

endmodule
