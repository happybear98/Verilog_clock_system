module bin2bcd #(parameter BINARY_LENGTH = 4, NUM_OF_DIGIT = 4) (
	input		wire	[BINARY_LENGTH-1:0]	binary,
	output	wire	[NUM_OF_DIGIT*4-1:0]	bcd);
		
	reg	[3:0]	code[0:3];
		
	assign bcd = {code[3], code[2], code[1], code[0]};
		
	always @(binary) begin
		code[3]		<= (binary  / 10'd1000);
		code[2]		<= (binary  / 8'd100)	%	4'd10;
		code[1]		<= (binary  / 4'd10)		%	4'd10;
		code[0]		<=  binary 	% 4'd10;
	end

endmodule 