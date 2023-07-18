`timescale 1ns / 1ps

module contador_tb;
	
	reg clk, reset;
	wire [3:0] out;
	
	contador DUT(
		.clk(clk),
		.reset(reset),
		.out(out)
	);
	
	always #5 clk = !clk;
	
	initial begin
		$dumpfile("signals.vcd");
		$dumpvars(0, contador_tb);
		clk = 0;
		reset = 1;
		#10 
		reset = 0;
		#100
		$finish;
	end
	
endmodule
