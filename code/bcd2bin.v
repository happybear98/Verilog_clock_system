module bcd2bin #(parameter BINARY_LENGTH = 14) (
	input		wire	[15:0]	bcd,
	output	wire	[BINARY_LENGTH-1:0]	binary
	);

	assign	binary	=	bcd[15:12] * 10'd1000 + bcd[11:8] * 7'd100 + bcd[7:4] * 4'd10 + bcd[3:0];

endmodule 