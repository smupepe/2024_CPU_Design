module flopenr(
	clk,
	n_rst,
	en,
	clr,
	d,
	q
);

    parameter RESET_VALUE = 32'h0000_0000;
	parameter WIDTH = 32;

	input clk, n_rst, en, clr;
	input [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;	

	always@(posedge clk) begin
		if(!n_rst | clr) begin
			q <= 32'h0;
		end
		else begin
			if(en)
				q <= d;
			else 
				q <= q;
		end		
	end

endmodule
