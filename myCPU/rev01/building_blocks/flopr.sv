module flopr(
	clk,
	n_rst,
	// clr,
	d,
	q
);

    parameter RESET_VALUE = 32'h0000_0000;
	parameter WIDTH = 32;

	input clk, n_rst/*, clr*/;
	input [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;	

	always@(posedge clk or negedge n_rst) begin 
		if(!n_rst/* | clr*/) begin
			q <= RESET_VALUE;
		end
		else begin
			q <= d;
		end		
	end

endmodule
