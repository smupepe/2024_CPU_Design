module Addr_Decoder (
    input [31:0] Addr,
    output reg CS_DMEM_N,
    output reg CS_TBMAN_N
);


always @(*)begin
    if (Addr[31:28] == 4'h1) begin
        CS_DMEM_N = 1'b0;
        CS_TBMAN_N = 1'b1;
    end
    else if (Addr[31:12] == 20'h8000F) begin
        CS_DMEM_N = 1'b1;
        CS_TBMAN_N = 1'b0;
    end 
    else begin
        CS_DMEM_N = 1'b1;
        CS_TBMAN_N = 1'b1;
    end
end

endmodule