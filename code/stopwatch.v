module stopwatch(
	input						clk,
	input						rst,
	input		wire			en_stop,
	input		wire [4:0]	sw,
	input		wire			set_stop,
	output	reg			stop,
	output	wire [15:0]	bcd_stop_hour,
	output	wire [15:0] bcd_stop_min,
	output	wire [15:0] bcd_stop_sec);
	
	reg		[5:0]	hour;	
	reg		[5:0]	min;
	reg 		[6:0]	sec;
	
	bin2bcd #(.BINARY_LENGTH(6),.NUM_OF_DIGIT(2)) BCD_STOP_HOUR (
	/* input		[BINARY_LENGTH-1:0]	*/ .binary	(hour),
	/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_stop_hour)); 	
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) BCD_STOP_MIN (
	/* input		[BINARY_LENGTH-1:0]	*/ .binary	(min),	
	/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_stop_min));
		 
		 
	bin2bcd #(.BINARY_LENGTH(7), .NUM_OF_DIGIT(2)) BCD_STOP_SEC (
	/* input		[BINARY_LENGTH-1:0]	*/ .binary	(sec),		
	/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_stop_sec)); 	   
	
   always @ (posedge clk or negedge rst) begin
   
      if(!rst)
			stop <= 0;
			
		else if(set_stop)
		
			if (sw[1])
			
				if(stop == 0) 
					stop <= 1;
				else if(stop == 1)
					stop <= 0;
   end

	always @ (posedge clk or negedge rst) begin
		
		if(!rst) begin
			hour <= 0;
			min <= 0;
			sec <= 0;	
		end			
		
		else if(stop == 1) begin
		
			if(en_stop) begin
				casex({hour, min, sec})
		
					{6'd59, 6'd59, 7'd100} : begin
						hour	<= 0;
						min	<= 0;
						sec	<= 0;
						
					end
			
					{6'dx, 6'd59, 7'd100} : begin
						hour	<= hour + 1'd1;
						min	<=0;
						sec	<=0;
					end
				
					{6'dx, 6'dx, 7'd100} : begin
			
						hour	<= hour;
						min	<= min +1'd1;
						sec	<= 0;
					end
			
					default : begin
						hour	<= hour;
						min	<= min;
						sec	<= sec + 1'd1;
					end
				endcase
			end
		end
		
		else if(sw[2]) begin
			hour <= 0;
			min <= 0;
			sec <= 0;
		end	
	end

endmodule