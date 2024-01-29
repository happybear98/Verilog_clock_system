module en_timer (
    input   wire  clk, rst,
    output  reg   en_1hz
);

    reg     [25:0] en_1hz_cnt;

    always @(posedge clk or negedge rst) begin 
        if (!rst) begin
            en_1hz      <= 0;
            en_1hz_cnt  <= 0;
        end
        else if (en_1hz_cnt == 26'd49_999_999) begin
            en_1hz      <= 1'd1;
            en_1hz_cnt  <= 0;
        end 
        else begin
            en_1hz      <= 0;
            en_1hz_cnt  <= en_1hz_cnt + 1'b1;
        end
		end
endmodule