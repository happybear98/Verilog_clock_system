module set (
  clk, rst,
  
  en_state,
  sw,
  cursor,
  
  bcd_hour,
  bcd_min,
  bcd_sec,
  bcd_year,
  bcd_month, 
  bcd_day,
  
  max_date,
  
  bin_watch,
  bin_date,
  
  save_hour,
  save_min,
  save_sec,
  save_year,
  save_mon,
  save_day,
  
  timer_hour, 
  timer_min,
  timer_sec);
	input					clk, rst;
	input		[5:0]		en_state;
	input		[4:0]		sw;
	input		[4:0]		cursor;
	input		[7:0]		bcd_hour, bcd_min, bcd_sec;
	input		[15:0]	bcd_year;
	input		[7:0]		bcd_month, bcd_day;
	input		[4:0]		max_date;
	output	[16:0]	bin_watch;
	output	[22:0]	bin_date;
	 	 
	output	[7:0]		save_hour, save_min, save_sec;
	output	[15:0]	save_year;
	output	[7:0]		save_mon, save_day;
	 
	output	[7:0]		timer_hour, timer_min, timer_sec;
	
	wire					clk, rst;
	wire		[5:0]		en_state;
	wire		[4:0]		sw;
	wire		[4:0]		cursor;
	wire		[7:0]		bcd_hour, bcd_min, bcd_sec;
	wire		[15:0]	bcd_year;
	wire		[7:0]		bcd_month, bcd_day;
	wire		[4:0]		max_date;
	wire		[16:0]	bin_watch;
	wire		[22:0]	bin_date;
	 
	wire		[4:0]		bin_hour;
	wire		[5:0]		bin_min, bin_sec;
	wire		[13:0]	bin_year;
	wire		[3:0]		bin_month;
	wire		[4:0]		bin_day;

	reg 		[7:0]		hour, min, sec;
	reg 		[15:0]	year;
	reg 		[7:0]		month, day;
	 
	 
	reg		[7:0]		save_hour, save_min, save_sec;
	reg		[15:0]	save_year;
	reg		[7:0]		save_mon, save_day;
	
	reg		[7:0]		timer_hour, timer_min, timer_sec;

	 
	 
	bcd2bin #(.BINARY_LENGTH(5))	BIN_HOUR (
	    /* input	[15:0]					*/	.bcd		(hour),
	    /* output	[BINARY_LENGTH-1:0]	*/	.binary	(bin_hour));
		 
	bcd2bin #(.BINARY_LENGTH(6))	BIN_MIN (
	    /* input 	[15:0]					*/	.bcd		(min),
	    /* output	[BINARY_LENGTH-1:0]	*/	.binary	(bin_min));
	
	bcd2bin #(.BINARY_LENGTH(6))	BIN_SEC (
	    /* input	[15:0]					*/	.bcd		(sec),
	    /* output	[BINARY_LENGTH-1:0]	*/	.binary	(bin_sec));

	bcd2bin #(.BINARY_LENGTH(14))	BIN_YEAR (
		/* input		[15:0]					*/	.bcd		(year),
		/* output	[BINARY_LENGTH-1:0]	*/	.binary	(bin_year));
		 
	bcd2bin #(.BINARY_LENGTH(4))	BIN_MONTH (
		/*	input		[15:0]					*/	.bcd		(month),
		/*	output	[BINARY_LENGTH-1:0]	*/	.binary	(bin_month));
	
	bcd2bin #(.BINARY_LENGTH(5))	BIN_DAY (
		/* input [15:0]                */ 	.bcd		(day),
		/* output [BINARY_LENGTH-1:0]  */	.binary	(bin_day));
		

	assign	bin_watch	=	{bin_hour, bin_min, bin_sec};
	assign	bin_date		=	{bin_year, bin_month, bin_day};

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			hour <= 0; min <= 0; sec <= 0;
			year <= 0; month <= 0; day <= 0;            
		end
		else begin
			hour <= hour; min <= min; sec <= sec;
			year <= year; month <= month; day <= day;
			case(en_state)
				6'b000001 : begin
					hour <= bcd_hour;
					min <= bcd_min; 
					sec <= bcd_sec;
					year <= bcd_year;
					month <= bcd_month; 
					day <= bcd_day;
				end
				6'b000010 : begin
					case(cursor)
						3'd0 : begin
							if (sw[1])
								if (sec[3:0] == 4'd9)
									sec[3:0]   <= 4'd0;
								else
									sec[3:0]   <= sec[3:0] + 1'd1;
									
							else if (sw[2])
								if (sec[3:0] == 4'd0)
									sec[3:0]   <= 4'd9;
								else
									sec[3:0]   <= sec[3:0] - 1'd1;
						end
						
						3'd1 : begin
							if (sw[1])
								if (sec[7:4] == 4'd5)
									sec[7:4]   <= 4'd0;
								else
									sec[7:4]   <= sec[7:4] + 1'd1;
									
							else if (sw[2])
								if (sec[7:4] == 4'd0)
									sec[7:4]   <= 4'd5;
								else
									sec[7:4]   <= sec[7:4] - 1'd1;
						end
						
						3'd2 : begin
							if (sw[1])
								if (min[3:0] == 4'd9)
									min[3:0]   <= 4'd0;
								else
									min[3:0]   <= min[3:0] + 1'd1;
									
							else if (sw[2])
								if (min[3:0] == 4'd0)
									min[3:0]   <= 4'd9;
								else
									min[3:0]   <= min[3:0] - 1'd1;
						end
						3'd3 : begin
							if (sw[1])
								if (min[7:4] == 4'd5)
									min[7:4]   <= 4'd0;
								else
									min[7:4]   <= min[7:4] + 1'd1;
									
							else if (sw[2])
								if (min[7:4] == 4'd0)
									min[7:4]   <= 4'd5;
								else
									min[7:4]   <= min[7:4] - 1'd1;
						end
						3'd4 : begin
							if (sw[1])
								if ((hour[7:4] == 4'd2) && (hour[3:0] >= 4'd4))
									hour[3:0]   <= 4'd0;
								else if (hour[3:0] == 4'd9)
									hour[3:0]   <= 4'd0;
								else
									hour[3:0]   <= hour[3:0] + 1'd1;  
							else if (sw[2])
								if ((hour[7:4] == 4'd2) && (hour[3:0] == 4'd0))
									hour[3:0]   <= 4'd3;
								else if (hour[3:0] == 4'd0)
									hour[3:0]   <= 4'd9;
								else
									hour[3:0]   <= hour[3:0] - 1'd1;
						end
						3'd5 : begin
							if (sw[1])
								if ((hour[7:4] == 4'd1) && (hour[3:0] >= 4'd4))
									hour[7:4]   <= 4'd0;
								else if (hour[7:4] == 4'd2)
									hour[7:4]   <= 4'd0;
								else
								hour[7:4]   <= hour[7:4] + 1'd1; 
								
							else if (sw[2])
								if ((hour[7:4] == 4'd0) && (hour[3:0] >= 4'd4))
									hour[7:4]   <= 4'd1;
								else if (hour[7:4] == 4'd0)
									hour[7:4]   <= 4'd2;
								else
									hour[7:4]   <= hour[7:4] - 1'd1;
						end
					endcase
				end
				6'b000100 : begin
					case(cursor)
						3'd0 : begin
							if (sw[1])
								if ((day[7:4] == (max_date / 4'd10)) && (day[3:0] >= (max_date % 4'd10)))
									day[3:0]    <= day[7:4] ? 4'd0 : 4'd1;
								else if (day[3:0] == 4'd9)
									day[3:0]    <= 4'd0;
								else
									day[3:0]    <= day[3:0] + 1'd1;
							else if (sw[2])
								if ((day[7:4] == (max_date / 4'd10)) && (day[3:0] == 4'd0))
									day[3:0]    <= (max_date % 4'd10);
								else if (((day[7:4] == 0) && (day[3:0] == 4'd1)) || (day[3:0] == 4'd0))
									day[3:0]    <= 4'd9;
								else
									day[3:0]    <= day[3:0] - 1'd1;
						end
						3'd1 : begin
							if (sw[1])
								if ((day[7:4] == (max_date / 4'd10 - 1'd1)) && (day[3:0] >= (max_date % 4'd10)))
									day[7:4]    <= 4'd0;
								else if (day[7:4] == (max_date / 4'd10))
									day[7:4]    <= day[3:0] ? 4'd0 : 4'd1;
								else
									day[7:4]    <= day[7:4] + 1'd1;
							else if (sw[2])
								if ((day[7:4] == (max_date / 4'd10)) && (day[3:0] == 4'd0))
									day[3:0]    <= (max_date % 4'd10);
								else if (day[7:4] == 4'd0)
									day[7:4]    <= 4'd9;
								else
									day[3:0]    <= day[3:0] - 1'd1;
						end
						3'd2 : begin
							if (sw[1])
								if ((month[7:4] == 4'd1) && (month[3:0] >= 4'd2))
									month[3:0]   <= 4'd0;
								else if (month[3:0] == 4'd9)
									month[3:0]   <= 4'd1;
								else
									month[3:0]  <= month[3:0] + 1'd1;
							else if (sw[2])
								if ((month[7:4] == 4'd1) && (month[3:0] == 4'd0))
									month[3:0]   <= 4'd2;
								else if (month[3:0] <= 4'd1)
									month[3:0]   <= 4'd9;
								else
									month[3:0]  <= month[3:0] - 1'd1;
						end
						3'd3 : begin
							if (sw[1])
								if ((month[7:4] == 4'd1) && (month[3:0] != 4'd0))
									month[7:4]  <= 4'd0;
								else if (month[3:0] > 4'd2)
									month[7:4]  <= 4'd0;
								else
									month[7:4]  <= month[7:4] + 1'd1;
							else if (sw[2])
								if ((month[7:4] == 4'd0) && (month[3:0] > 4'd2))
									month[7:4]  <= 4'd0;
								else
									month[7:4]  <= !month[7:4];
						end
						3'd4 : begin
							if(sw[1])
								if (year[3:0] == 4'd9)
									year[3:0]   <= year[15:4] ? 4'd0 : 4'd1;
								else
									year[3:0]   <= year[3:0] + 1'd1;
							else if (sw[2])
								if ((!year[15:4] && (year[3:0] <= 4'd1)) || (year[3:0] == 4'd0))
									year[3:0]   <= 4'd9;
								else
									year[3:0]   <= year[3:0] - 4'd1;
						end
						3'd5 : begin
							if(sw[1])
								if (year[7:4] == 4'd9)
									year[7:4]   <= {year[15:8], year[3:0]} ? 4'd0 : 4'd1;
								else
									year[7:4]   <= year[7:4] + 1'd1;
							else if (sw[2])
									if ((!{year[15:8], year[3:0]} && (year[7:4] <= 4'd1)) || (year[7:4] == 4'd0))
										year[7:4]   <= 4'd9;
									else
										year[7:4]   <= year[7:4] - 4'd1;
						end
						3'd6 : begin
							if(sw[1])
								if (year[11:8] == 4'd9)
									year[11:8]   <= {year[15:12], year[7:0]} ? 4'd0 : 4'd1;
								else
									year[11:8]   <= year[11:8] + 1'd1;
							else if (sw[2])
								if ((!{year[15:12], year[7:0]} && (year[11:8] <= 4'd1)) || (year[11:8] == 4'd0))
									year[11:8]   <= 4'd9;
								else
									year[11:8]   <= year[11:8] - 4'd1;
						end
						3'd7 : begin
							if(sw[1])
								if (year[15:12] == 4'd9)
									year[15:12]   <= year[11:0] ? 4'd0 : 4'd1;
								else
									year[15:12]   <= year[15:12] + 1'd1;
							else if (sw[2])
								if ((!year[11:0] && (year[15:12] <= 4'd1)) || (year[15:12] == 4'd0))
									year[15:12]   <= 4'd9;
								else
									year[15:12]   <= year[15:12] - 4'd1;
						end
					endcase
				end
				6'b001000	:	begin
					case(cursor)
						4'd0 : begin
							if (sw[1])
								if (save_sec[3:0] == 4'd9)
									save_sec[3:0]   <= 4'd0;
								else
									save_sec[3:0]   <= save_sec[3:0] + 1'd1;
							else if (sw[2])
								if (save_sec[3:0] == 4'd0)
									save_sec[3:0]   <= 4'd9;
								else
									save_sec[3:0]   <= save_sec[3:0] - 1'd1;
						end
						4'd1 : begin
							if (sw[1])
								if (save_sec[7:4] == 4'd5)
									save_sec[7:4]   <= 4'd0;
								else
									sec[7:4]   <= save_sec[7:4] + 1'd1;
							else if (sw[2])
								if (save_sec[7:4] == 4'd0)
									save_sec[7:4]   <= 4'd5;
								else
									save_sec[7:4]   <= save_sec[7:4] - 1'd1;
						end
						4'd2 : begin
							if (sw[1])
								if (save_min[3:0] == 4'd9)
									save_min[3:0]   <= 4'd0;
								else
									save_min[3:0]   <= save_min[3:0] + 1'd1;
							else if (sw[2])
								if (save_min[3:0] == 4'd0)
									save_min[3:0]   <= 4'd9;
								else
									save_min[3:0]   <= save_min[3:0] - 1'd1;
						end
						4'd3 : begin
							if (sw[1])
								if (save_min[7:4] == 4'd5)
									save_min[7:4]   <= 4'd0;
								else
									save_min[7:4]   <= save_min[7:4] + 1'd1;
							else if (sw[2])
								if (save_min[7:4] == 4'd0)
									save_min[7:4]   <= 4'd5;
								else
									save_min[7:4]   <= save_min[7:4] - 1'd1;
						end
						4'd4 : begin
							if (sw[1])
								if ((save_hour[7:4] == 4'd2) && (save_hour[3:0] >= 4'd4))
									save_hour[3:0]   <= 4'd0;
								else if (save_hour[3:0] == 4'd9)
									save_hour[3:0]   <= 4'd0;
								else
									save_hour[3:0]   <= save_hour[3:0] + 1'd1;  
							else if (sw[2])
								if ((save_hour[7:4] == 4'd2) && (save_hour[3:0] == 4'd0))
									save_hour[3:0]   <= 4'd3;
								else if (save_hour[3:0] == 4'd0)
									save_hour[3:0]   <= 4'd9;
								else
									save_hour[3:0]   <= save_hour[3:0] - 1'd1;
						end
						4'd5 : begin
							if (sw[1])
								if ((save_hour[7:4] == 4'd1) && (save_hour[3:0] >= 4'd4))
									save_hour[7:4]   <= 4'd0;
								else if (save_hour[7:4] == 4'd2)
									save_hour[7:4]   <= 4'd0;
								else
									save_hour[7:4]   <= save_hour[7:4] + 1'd1;  
							else if (sw[2])
								if ((save_hour[7:4] == 4'd0) && (save_hour[3:0] >= 4'd4))
									save_hour[7:4]   <= 4'd1;
								else if (save_hour[7:4] == 4'd0)
									save_hour[7:4]   <= 4'd2;
								else
									save_hour[7:4]   <= save_hour[7:4] - 1'd1;
						end
						4'd6 : begin
							if (sw[1])
								if ((save_day[7:4] == (max_date / 4'd10)) && (save_day[3:0] >= (max_date % 4'd10)))
									save_day[3:0]    <= save_day[7:4] ? 4'd0 : 4'd1;
								else if (save_day[3:0] == 4'd9)
									save_day[3:0]    <= 4'd0;
								else
									save_day[3:0]    <= save_day[3:0] + 1'd1;
							else if (sw[2])
								if ((save_day[7:4] == (max_date / 4'd10)) && (save_day[3:0] == 4'd0))
									save_day[3:0]    <= (max_date % 4'd10);
								else if (((save_day[7:4] == 0) && (save_day[3:0] == 4'd1)) || (save_day[3:0] == 4'd0))
									save_day[3:0]    <= 4'd9;
								else
									save_day[3:0]    <= save_day[3:0] - 1'd1;
						end
						4'd7 : begin
							if (sw[1])
								if ((save_day[7:4] == (max_date / 4'd10 - 1'd1)) && (save_day[3:0] >= (max_date % 4'd10)))
									save_day[7:4]    <= 4'd0;
								else if (save_day[7:4] == (max_date / 4'd10))
									save_day[7:4]    <= save_day[3:0] ? 4'd0 : 4'd1;
								else
									save_day[7:4]    <= save_day[7:4] + 1'd1;
							else if (sw[2])
								if ((save_day[7:4] == (max_date / 4'd10)) && (save_day[3:0] == 4'd0))
									save_day[3:0]    <= (max_date % 4'd10);
								else if (save_day[7:4] == 4'd0)
									save_day[7:4]    <= 4'd9;
								else
									save_day[3:0]    <= save_day[3:0] - 1'd1;
						end
						4'd8 : begin
							if (sw[1])
								if ((save_mon[7:4] == 4'd1) && (save_mon[3:0] >= 4'd2))
									save_mon[3:0]   <= 4'd0;
								else if (save_mon[3:0] == 4'd9)
									save_mon[3:0]   <= 4'd1;
								else
									save_mon[3:0]  <= save_mon[3:0] + 1'd1;
							else if (sw[2])
								if ((save_mon[7:4] == 4'd1) && (save_mon[3:0] == 4'd0))
									save_mon[3:0]   <= 4'd2;
								else if (save_mon[3:0] <= 4'd1)
									save_mon[3:0]   <= 4'd9;
								else
									save_mon[3:0]  <= save_mon[3:0] - 1'd1;
						end
						4'd9 : begin
							if (sw[1])
								if ((save_mon[7:4] == 4'd1) && (save_mon[3:0] != 4'd0))
									save_mon[7:4]  <= 4'd0;
								else if (save_mon[3:0] > 4'd2)
									save_mon[7:4]  <= 4'd0;
								else
									save_mon[7:4]  <= save_mon[7:4] + 1'd1;
							else if (sw[2])
								if ((save_mon[7:4] == 4'd0) && (save_mon[3:0] > 4'd2))
									save_mon[7:4]  <= 4'd0;
								else
									save_mon[7:4]  <= !save_mon[7:4];
						end
						4'd10 : begin
							if(sw[1])
								if (save_year[3:0] == 4'd9)
									save_year[3:0]   <= save_year[15:4] ? 4'd0 : 4'd1;
								else
									save_year[3:0]   <= save_year[3:0] + 1'd1;
							else if (sw[2])
								if ((!save_year[15:4] && (save_year[3:0] <= 4'd1)) || (save_year[3:0] == 4'd0))
									save_year[3:0]   <= 4'd9;
								else
									save_year[3:0]   <= save_year[3:0] - 4'd1;
						end
						4'd11 : begin
							if(sw[1])
								if (save_year[7:4] == 4'd9)
									save_year[7:4]   <= {save_year[15:8], save_year[3:0]} ? 4'd0 : 4'd1;
								else
									save_year[7:4]   <= save_year[7:4] + 1'd1;
							else if (sw[2])
								if ((!{save_year[15:8], save_year[3:0]} && (save_year[7:4] <= 4'd1)) || (save_year[7:4] == 4'd0))
									save_year[7:4]   <= 4'd9;
								else
									save_year[7:4]   <= save_year[7:4] - 4'd1;
						end
						4'd12 : begin
							if(sw[1])
								if (save_year[11:8] == 4'd9)
									save_year[11:8]   <= {save_year[15:12], save_year[7:0]} ? 4'd0 : 4'd1;
								else
									save_year[11:8]   <= save_year[11:8] + 1'd1;
							else if (sw[2])
								if ((!{save_year[15:12], save_year[7:0]} && (save_year[11:8] <= 4'd1)) || (save_year[11:8] == 4'd0))
									save_year[11:8]   <= 4'd9;
								else
									save_year[11:8]   <= save_year[11:8] - 4'd1;
						end
						4'd13 : begin
							if(sw[1])
								if (save_year[15:12] == 4'd9)
									save_year[15:12]   <= save_year[11:0] ? 4'd0 : 4'd1;
								else
									save_year[15:12]   <= save_year[15:12] + 1'd1;
							else if (sw[2])
								if ((!save_year[11:0] && (save_year[15:12] <= 4'd1)) || (save_year[15:12] == 4'd0))
									save_year[15:12]   <= 4'd9;
								else
									save_year[15:12]   <= save_year[15:12] - 4'd1;
						end	
					endcase  
				end
				6'b100000 	: 	begin
					case(cursor)
						3'd0 : begin
							if (sw[1])
								if (timer_sec[3:0] == 4'd9)
									timer_sec[3:0]   <= 4'd0;
								else
									timer_sec[3:0]   <= timer_sec[3:0] + 1'd1;
							else if (sw[2])
								if (timer_sec[3:0] == 4'd0)
									timer_sec[3:0]   <= 4'd9;
								else
									timer_sec[3:0]   <= timer_sec[3:0] - 1'd1;
						end
						3'd1 : begin
							if (sw[1])
								if (timer_sec[7:4] == 4'd5)
									timer_sec[7:4]   <= 4'd0;
								else
									timer_sec[7:4]   <= timer_sec[7:4] + 1'd1;
							else if (sw[2])
								if (timer_sec[7:4] == 4'd0)
									timer_sec[7:4]   <= 4'd5;
								else
									timer_sec[7:4]   <= timer_sec[7:4] - 1'd1;
						end
						3'd2 : begin
							if (sw[1])
								if (timer_min[3:0] == 4'd9)
									timer_min[3:0]   <= 4'd0;
								else
									timer_min[3:0]   <= timer_min[3:0] + 1'd1;
							else if (sw[2])
								if (timer_min[3:0] == 4'd0)
									timer_min[3:0]   <= 4'd9;
								else
									timer_min[3:0]   <= timer_min[3:0] - 1'd1;
						end
						3'd3 : begin
							if (sw[1])
								if (timer_min[7:4] == 4'd5)
									timer_min[7:4]   <= 4'd0;
								else
									timer_min[7:4]   <= timer_min[7:4] + 1'd1;
							else if (sw[2])
								if (timer_min[7:4] == 4'd0)
									timer_min[7:4]   <= 4'd5;
								else
									timer_min[7:4]   <= timer_min[7:4] - 1'd1;
						end
						3'd4 : begin
							if (sw[1])
								if ((timer_hour[7:4] == 4'd2) && (timer_hour[3:0] >= 4'd4))
									timer_hour[3:0]   <= 4'd0;
								else if (timer_hour[3:0] == 4'd9)
									timer_hour[3:0]   <= 4'd0;
								else
									timer_hour[3:0]   <= timer_hour[3:0] + 1'd1;  
							else if (sw[2])
								if ((timer_hour[7:4] == 4'd0) && (timer_hour[3:0] == 4'd0))
									timer_hour[3:0]   <= 4'd3;
								else if (timer_hour[3:0] == 4'd0)
									timer_hour[3:0]   <= 4'd9;
								else
									timer_hour[3:0]   <= timer_hour[3:0] - 1'd1;
						end
						3'd5 : begin
							if (sw[1])
								if ((timer_hour[7:4] == 4'd2) && (timer_hour[3:0] >= 4'd4))
									timer_hour[7:4]   <= 4'd0;
								else if (timer_hour[7:4] == 4'd2)
									timer_hour[7:4]   <= 4'd0;
								else
									timer_hour[7:4]   <= timer_hour[7:4] + 1'd1;  
							else if (sw[2])
								if ((timer_hour[7:4] == 4'd0) && (timer_hour[3:0] >= 4'd0))
									timer_hour[7:4]   <= 4'd2;
								else if (hour[7:4] == 4'd0)
									timer_hour[7:4]   <= 4'd2;
								else
									timer_hour[7:4]   <= timer_hour[7:4] - 1'd1;
						end
					endcase
				end
						
			endcase
		end 
	end

endmodule