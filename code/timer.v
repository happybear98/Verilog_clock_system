module timer (
	input		wire 				clk, rst, set_timer, stop,en_1clk,
	input		wire	[7:0]		timer_hour,timer_min,timer_sec,
	
	output	reg	[4:0]		bin_timer_hour,
	output	reg	[5:0]		bin_timer_min, bin_timer_sec
	);
	
	
	wire en_timer;
	
	
	bcd2bin #(.BINARY_LENGTH(5))			BIN_HOUR (
		/* input	[15:0]						*/	.bcd		(timer_hour),
		/* output	[BINARY_LENGTH-1:0]  */	.binary	(bin_timer_hour1));
		 
    bcd2bin #(.BINARY_LENGTH(6))			BIN_MIN (
		/* input	[15:0]						*/	.bcd		(timer_min),	       
		/* output	[BINARY_LENGTH-1:0]  */	.binary	(bin_timer_min1));
	
    bcd2bin #(.BINARY_LENGTH(6))			BIN_SEC (
		/* input	[15:0]						*/	.bcd		(timer_sec),	
		/* output	[BINARY_LENGTH-1:0]	*/	.binary	(bin_timer_sec1));
	
	
	wire	[4:0]	bin_timer_hour1;
	wire	[5:0] bin_timer_min1, bin_timer_sec1;
	

	always @(posedge clk or negedge rst) begin
		if (!rst)
			{bin_timer_hour, bin_timer_min, bin_timer_sec}	<= 0;
			
		else if(stop) begin
			bin_timer_hour		<= bin_timer_hour1;
			bin_timer_min		<= bin_timer_min1;
			bin_timer_sec		<= bin_timer_sec1;
		end
		
		else if(en_1clk) begin
			casex({bin_timer_hour, bin_timer_min, bin_timer_sec})
				{5'd00, 6'd00, 6'd00} : begin
					bin_timer_hour		<= bin_timer_hour;
					bin_timer_min		<= bin_timer_min;
					bin_timer_sec		<= bin_timer_sec;
				end
				{5'dx, 6'd00, 6'd00} : begin
					bin_timer_hour		<= bin_timer_hour - 1'h1;
					bin_timer_min		<= 59;
					bin_timer_sec		<= 59;
				end
						
				{5'dx, 6'dx, 6'd00} : begin
					bin_timer_hour		<= bin_timer_hour;
					bin_timer_min		<= bin_timer_min - 1'h1;
					bin_timer_sec		<= 59;
				end
						
				default : begin
					bin_timer_hour		<= bin_timer_hour;
					bin_timer_min		<= bin_timer_min;
					bin_timer_sec		<= bin_timer_sec - 1'h1;
				end
			endcase
		end
	end
endmodule		