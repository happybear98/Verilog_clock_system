
module alarm(
	clk,rst,
	rst_sw,
	
	save_year,
	save_mon,
	save_day,
	save_hour,
	save_min,
	save_sec,
	bin_date,
	bin_watch,
	led);
	
	
	input					clk,rst;
	input		[15:0]	save_year;
	input		[7:0]		save_mon;
	input		[7:0]		save_day;
	input		[7:0]		save_hour;
	input		[7:0]		save_min;
	input		[7:0]		save_sec;
	input					rst_sw;
	//input [15:0]din;
	
	input		[16:0]	bin_watch;
   input		[22:0]	bin_date;
	output	[1:0]		led;
	//input s_signal;
	
	
	wire		[15:0]	compare_year;
	wire		[7:0]		compare_mon;
	wire		[7:0]		compare_day;
	wire		[7:0]		compare_hour;
	wire		[7:0]		compare_min;
	wire		[7:0]		compare_sec;
	
	reg		[7:0]		hour, min, sec;
   reg		[15:0]	year;
   reg		[7:0]		month, day;

	reg 		[1:0]		led;
	reg 					on;
	
	
	always @ (posedge clk) begin
		year <= bin_date[22:10];
		month <= bin_date[9:6];
		day	<= bin_date[4:0];
		sec	<=	bin_watch[5:0];
		min	<= bin_watch[11:6];
		hour	<= bin_watch[16:12];
	end
	
	
	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) SET_HOUR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(hour),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(compare_hour));
	
		 
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) SET_MIN (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(min),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(compare_min));
		 
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) SET_SEC (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(sec),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(compare_sec));

		 
	bin2bcd #(.BINARY_LENGTH(14), .NUM_OF_DIGIT(4)) SET_YEAR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(year),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(compare_year));
		 
	bin2bcd #(.BINARY_LENGTH(4), .NUM_OF_DIGIT(2)) SET_MONTH (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(month),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(compare_month));
		 
	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) SET_DAY (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(day),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(compare_day));	
	
	initial begin
		//signal <=1'b0;
		led <= 2'b00;
		on <= 0;
	end
	
	always @(posedge clk) begin
		if(!rst) begin 
			on <= 0;
		end//signal<= 1'b0;
		else if(rst_sw)
			on	<=	0;
		else if((save_year == compare_year)&& (save_mon == compare_mon) && (save_day == compare_day)&& (save_hour == compare_hour) && (save_min == compare_min) && (save_sec == compare_sec)) begin
			on <= 1;
		end
		

		if(on)
			led <= 2'b11;
		else 
			led <= 2'b00;
	end
	
endmodule
