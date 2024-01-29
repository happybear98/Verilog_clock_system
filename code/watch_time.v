module watch_time (
	clk, rst, 
	en_1hz, 
	set_watch,
	ampm_sw,
	bin_watch,
	ampm,	
	hour, 
	min, sec,
	en_day);
	
	input					clk, rst, en_1hz;
	input					set_watch;
	input					ampm_sw;
	input		[16:0]	bin_watch;
	output				ampm;
	output	[4:0]		hour;
	output	[5:0]		min, sec;
	output				en_day;
	
	wire					ampm_sw;
	wire		[16:0]	bin_watch;
	wire					ampm;
	wire		[4:0]		hour_ampm;
	reg		[5:0]		min, sec;
	reg					en_day;
	
	reg		[4:0]		hour;
	reg					ampm_mode;

	assign	ampm			=	hour >= 4'd12 ? 1'd1 : 1'd0;




	always @(posedge clk or negedge rst) begin
		if (!rst)
		{hour, min, sec, en_day}	<= 0;
		
		else if (set_watch) begin
			{hour, min, sec}	<= bin_watch;
			en_day				<= 0;
		end
		else begin
			hour	<= hour;
			min		<= min;
			sec		<= sec;
			en_day	<= 0;
			if (en_1hz) begin
				casex({hour, min, sec})
					{5'd23, 6'd59, 6'd59} : begin
						hour		<= 0;
						min			<= 0;
						sec			<= 0;
						en_day		<= 1'd1;
					end
					
					{5'dx, 6'd59, 6'd59} : begin
						hour	<= hour + 1'd1;
						min		<= 0;
						sec		<= 0;
					end
					
					{5'dx, 6'dx, 6'd59} : begin
						hour	<= hour;
						min		<= min + 1'd1;
						sec		<= 0;
					end
					
					default : begin
						hour	<= hour;
						min		<= min;
						sec		<= sec + 1'd1;
					end
				endcase
			end
		end
	end
endmodule
