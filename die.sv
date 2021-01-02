module  die ( 
					input		logic 			clk, start, reset,   
					output 	logic [8:0]		X,
					output 	logic [7:0]		Y,
               output 	logic  		   done,      
					output	logic [6:0]		color_index 					
              );
		
		parameter [8:0] head_x = 9'd105;
		parameter [7:0] head_y = 8'd60;
		parameter [8:0] Size_X = 9'd110;
		parameter [7:0] Size_Y = 8'd120;

		logic [13:0] idx_tile;
		logic [6:0] rom [0: Size_X * Size_Y - 1];
		
		initial
		begin
			 $readmemb("pictures/die.txt", rom);
		end
		
		enum logic {sleep, awake} state, next_state;
		logic [8:0] x_counter, x_next;
		logic [7:0] y_counter, y_next;
		logic next_done;
		always_ff @ (posedge clk) begin
			if (reset) begin
				state <= sleep;
				x_counter <= 9'h0;
				y_counter <= 8'h0;
				done <= 1'b0;
			end else begin
				state <= next_state;
				x_counter <= x_next;
				y_counter <= y_next;
				done <= next_done;
			end
		end
    
		always_comb begin
		next_state = state;
		x_next = x_counter;
		y_next =	y_counter;
		next_done = 1'b0;
		unique case(state) 
			sleep: begin
				if (start) begin
					next_state = awake;
				end
			end
			
			awake: begin
				if (x_counter + 1 == Size_X) begin
					x_next = 9'h0;
					if(y_counter + 1 == Size_Y) begin
						next_state = sleep;
						y_next = 8'h0;
						next_done = 1'b1;
					end else begin
						y_next = y_counter + 1;
					end
				end else begin
					x_next = x_counter + 1;
				end
			end
		endcase
		end
		
		assign X = head_x +  x_counter;
		assign Y = head_y +  y_counter;
		assign idx_tile = x_counter + y_counter * Size_X;
		
		always_comb begin
			color_index = rom[idx_tile];
//			if (X < 0 || X >= 320 || Y < 0 || Y >= 240) begin
//				color_index_t[7] = 1'b0;
//			end
		end		
	 
endmodule
