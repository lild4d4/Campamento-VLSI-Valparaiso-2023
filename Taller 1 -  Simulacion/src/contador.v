module contador (
	input clk,
	input reset,
	output reg[3:0] out
);

	always @(posedge clk) begin
		if(reset) out <= 0;
		else out <= out + 1;
	end

endmodule
