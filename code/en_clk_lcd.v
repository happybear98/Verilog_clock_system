module en_clk_lcd(
		clk,
		rst,
		en_clk1);
	
		input 	clk;
		input 	rst;
		output	en_clk1;

		reg	[16:0]cnt_en;
		reg	en_clk1;
		
		always @ (posedge clk or negedge rst) begin
			if(!rst) begin
				cnt_en <=0;
				en_clk1 <=0;
			end
			else begin
				if(cnt_en == 99999) begin
					cnt_en <= 0;
					en_clk1 <= 1'b1;
				end
				else begin
					cnt_en <= cnt_en + 1'b1;
					en_clk1 <= 0;
				end
			end
		end
endmodule
