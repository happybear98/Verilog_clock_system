module fsm (
	clk, rst,
	sw,
	en_state,
	cursor
    );
	 input   clk, rst;
    input   [4:0] sw;
    output  [6:0] en_state;
    output  [4:0] cursor;

	 
	 wire          clk, rst;
    wire    [4:0] sw;
	 reg     [6:0] en_state;
    reg     [4:0] cursor;
    
   parameter  	WATCH 		= 3'b000;
	parameter	SET_WATCH	= 3'b001;
	parameter	SET_DATE		= 3'b010;	
	parameter	ALARM			= 3'b011;	
	parameter	STOP_WATCH	= 3'b100;
	parameter	TIMER			= 3'b101;
    
	reg [4:0]   state, next;

    // FSM
    always @(posedge clk or negedge rst) begin
        if (!rst)
            state <= WATCH;
        else
            state <= next;
    end

    always @(*) begin
       case (state)
            WATCH : begin
                if (sw[4])
                    next    <= SET_WATCH;
                else
                    next    <= WATCH;
            end

            SET_WATCH : begin
                if (sw[4])
                    next    <= SET_DATE;
                else
                    next    <= SET_WATCH;
            end

            SET_DATE : begin
                if (sw[4])
                    next    <= ALARM;
                else
                    next    <= SET_DATE;
            end
				
				ALARM : begin
					if (sw[4])
                    next    <= STOP_WATCH;
               else
                    next    <= ALARM;				
				end
				
				STOP_WATCH : begin
					if (sw[4])
                    next    <= TIMER;
               else
                    next    <= STOP_WATCH;				
				end
				
				TIMER		  : begin
					if (sw[4])
                    next    <= WATCH;
               else
                    next    <= TIMER;				
				end
				
        endcase
		
    end


	 
    always @(state) begin
        case(state)
            WATCH     : en_state    <= 6'b000001;
            SET_WATCH : en_state    <= 6'b000010;
            SET_DATE  : en_state    <= 6'b000100;
				ALARM 	 : en_state		<= 6'b001000;
				STOP_WATCH: en_state		<= 6'b010000;
				TIMER		 :	en_state		<= 6'b100000;
				default	 : en_state		<= 0;
        endcase
    end

	 
	always @(posedge clk or negedge rst) begin
		if (!rst)
			cursor  <= 0;
		else begin
			case(state)
				SET_WATCH : begin
					if (sw[0])
						if (cursor == 4'd5)
							cursor  <= 0;
						else
							cursor  <= cursor + 1'd1;
					else if (sw[3])
						if (cursor == 4'd0)
							cursor  <= 4'd5;
						else
							cursor  <= cursor - 1'd1;
				end
				SET_DATE : begin
					if (sw[0])
						if (cursor == 4'd7)
							cursor  <= 0;
						else
							cursor  <= cursor + 1'd1;
					else if (sw[3])
						if (cursor == 4'd0)
							cursor  <= 4'd7;
						else
							cursor  <= cursor - 1'd1;
				end
				ALARM : begin
					if (sw[0])
						if (cursor == 5'd13)
							cursor  <= 0;
						else
							cursor  <= cursor + 1'd1;
					else if (sw[3])
						if (cursor == 5'd0)
							cursor  <= 5'd13;
						else
							cursor  <= cursor - 1'd1;
				end
				TIMER : begin
					if (sw[0])
						if (cursor >= 4'd5)
							cursor  <= 0;
						else
							cursor  <= cursor + 1'd1;
					else if (sw[3])
						if (cursor == 4'd0)
							cursor  <= 4'd5;
						else
							cursor  <= cursor - 1'd1;
				end
					 
				default : cursor <= 0;
			endcase
		end
	end

endmodule 