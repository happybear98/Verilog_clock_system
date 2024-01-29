module debouncer_clk	(
	clk, rst,
	in,
	debclk,
	out);

	
	input			clk, rst;
	input			in;
	input			debclk;
	output		out;
	
	wire			clk, rst;
	wire			in;
	wire			debclk;
	wire			out;
	wire			q, q3, qb2, qb4;
	wire			out2;
	
	
	d_ff					DFF0	(							// 1st D-FF 인스턴스화
	/*	input				*/	.clk		(debclk),
	/*	input				*/	.rst		(rst),
	/* input				*/	.set		(1'b1),
	/*	input				*/	.d			(in),
	/*	output			*/	.q			(q));
	
	d_ff					DFF1	(							// 2nd D-FF 인스턴스화
	/*	input				*/	.clk		(debclk),
	/*	input				*/	.rst		(rst),
	/* input				*/	.set		(1'b1),
	/*	input				*/	.d			(q),
	/*	output			*/	.qb		(qb2));
	
	d_ff					DFF3	(							// 3rd D-FF 인스턴스화
	/*	input				*/	.clk		(clk),
	/*	input				*/	.rst		(rst),
	/* input				*/	.set		(1'b1),
	/*	input				*/	.d			(out2),
	/*	output			*/	.q			(q3));
	
	d_ff					DFF4	(							// 4th D-FF 인스턴스화
	/*	input				*/	.clk		(clk),
	/*	input				*/	.rst		(rst),
	/* input				*/	.set		(1'b1),
	/*	input				*/	.d			(q3),
	/*	output			*/	.qb		(qb4));
	
	assign	out2 =  q & qb2;
	assign	out  = q3 & qb4;
	
endmodule 