module debouncer_control(
	input		wire			clk, rst,
	input		wire			debclk_10hz,
	input		wire	[4:0]	in_sw,
	output	wire	[4:0]	sw);


	debouncer_clk				SW0 (
	/*	input				*/	.clk			(clk),
	/*	input				*/	.rst			(rst),
	/*	input				*/	.in			(in_sw[0]),
	/*	input				*/	.debclk		(debclk_10hz),
	/*	output			*/	.out			(sw[0]));		

	debouncer_clk				SW1 (
	/*	input				*/	.clk			(clk),
	/*	input				*/	.rst			(rst),
	/*	input				*/	.in			(in_sw[1]),
	/*	input				*/	.debclk		(debclk_10hz),
	/*	output			*/	.out			(sw[1]));	
	
	debouncer_clk				SW2 (
	/*	input				*/	.clk			(clk),
	/*	input				*/	.rst			(rst),
	/*	input				*/	.in			(in_sw[2]),
	/*	input				*/	.debclk		(debclk_10hz),
	/*	output			*/	.out			(sw[2]));		
	
	debouncer_clk				SW3 (
	/*	input				*/	.clk			(clk),
	/*	input				*/	.rst			(rst),
	/*	input				*/	.in			(in_sw[3]),
	/*	input				*/	.debclk		(debclk_10hz),
	/*	output			*/	.out			(sw[3]));	
	
	debouncer_clk				SW4 (
	/*	input				*/	.clk			(clk),
	/*	input				*/	.rst			(rst),
	/*	input				*/	.in			(in_sw[4]),
	/*	input				*/	.debclk		(debclk_10hz),
	/*	output			*/	.out			(sw[4]));
		
endmodule