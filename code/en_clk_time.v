module en_clk_time (
	input		wire	clk, rst,
	output	reg	en_1clk,
	output	reg	debclk_10hz,
	output	reg	en_clk
);

	
	reg		[6:0]		cnt_1clk;
	reg		[25:0]	en_cnt;
	reg		[21:0]	debclk_10hz_cnt;

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			en_clk      <= 0;
			en_cnt  <= 0;
		end
		else if (en_cnt == 499999) begin
			en_clk      <= 1'd1;
			en_cnt  <= 0;
		end 
		else begin
			en_clk      <= 0;
			en_cnt  <= en_cnt + 1'b1;
		end
	end
	 
	always @ (posedge clk or negedge rst) begin
		if (!rst) begin
			en_1clk			<= 0;
			cnt_1clk			<= 0;
		end
		else if (en_clk == 1) begin
			if(cnt_1clk == 100) begin
				en_1clk		<= 1'b1;
				cnt_1clk		<= 0;
			end
			else begin
				en_1clk		<= 0;
				cnt_1clk		<= cnt_1clk + 1'b1;
			end
		end
		else begin
			en_1clk			<= 0;
			cnt_1clk			<= cnt_1clk;
		end
	end

	always @(posedge clk or negedge rst) begin : DEBCLK_10HZ
		if (!rst) begin
			debclk_10hz     <= 0;
			debclk_10hz_cnt <= 0;
		end
		else if (debclk_10hz_cnt == 22'd2_499_999) begin
			debclk_10hz		<= ~debclk_10hz;
			debclk_10hz_cnt <= 0;
		end
		else
			debclk_10hz_cnt	<= debclk_10hz_cnt + 1'b1;
	end

endmodule 