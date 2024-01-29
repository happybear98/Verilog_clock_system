module watch_date (
	clk, rst, 
	en_day, 
	set_date,
				
	bin_date,
	max_date,
	year,
	month,
	day,
	week
	);
	
	input					clk, rst, en_day;
	input					set_date;
	input		[22:0]	bin_date;
	output	[4:0]		max_date;
	output	[13:0]	year;
	output	[3:0]		month;
	output	[4:0]		day;
	output	[2:0]		week;
	
	wire					clk, rst, en_day;
	wire		[22:0]	bin_date;
	reg		[4:0]		max_date;
	reg		[13:0]	year;
	reg		[3:0]		month;
	reg		[4:0]		day;
	wire		[2:0]		week;

	wire 	leap_year;
	

	// leap_year
	assign leap_year = (((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0) ? 1'b1 : 1'b0;
			
			
	//define of week
	wire	[7:0] k = (month == 1 || month == 2) ? (year - 1'd1) % 7'd100 : year % 7'd100;
	wire	[3:0] j = (month == 1 || month == 2) ? (year - 1'd1) / 7'd100 : year / 7'd100;
	wire	[3:0] m = (month == 1 || month == 2) ? month + 4'd12 : month;
	
	
	assign week = (day + ((m + 1'b1) * 8'd13 / 3'd5) + k + (k / 3'd4) + (j / 3'd4) - (8'd2 * j)) % 3'd7;
	
	
	
	always @ (*) begin
		case (month)
			4'd1		:	max_date	<= 5'd31;
			4'd2		:	max_date	<= 5'd28 + leap_year;
			4'd3		:	max_date	<= 5'd31;
			4'd4		:	max_date	<= 5'd30;
			4'd5		:	max_date	<= 5'd31;
			4'd6		:	max_date	<= 5'd30;
			4'd7		:	max_date	<= 5'd31;
			4'd8		:	max_date	<= 5'd31;
			4'd9		:	max_date	<= 5'd30;
			4'd10		:	max_date	<= 5'd31;
			4'd11		:	max_date	<= 5'd30;
			4'd12		:	max_date	<= 5'd31;
			default	:	max_date	<= 0;
		endcase
	end

	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			{year, month, day}	<= 0;
		end
		else if (set_date)
			{year, month, day}	<= bin_date;
			
		else begin
			year		<= year;
			month		<= month;
			day		<= day;
			
			if (en_day) begin
				casex({year, month, day})
					{14'd9999, 4'd12, max_date} : begin
						year		<= 1'd1;
						month		<= 1'd1;
						day		<= 1'd1;
					end
					
					{14'dx, 4'd12, max_date} : begin
						year		<= year + 1'd1;
						month		<= 1'd1;
						day		<= 1'd1;
					end
					
					{14'dx, 4'dx, max_date} : begin
						year		<= year;
						month		<= month + 1'd1;
						day		<= 1'd1;
					end
					
					default : begin
						year		<= year;
						month		<= month;
						day		<= day + 1'd1;
					end
				endcase
			end
		end
	end
endmodule
