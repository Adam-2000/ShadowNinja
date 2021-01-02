module  background_back( 
					input		logic 			clk, start, reset,   
					input   	logic	[15:0] 	mapX,
					output 	logic [8:0]		X,
					output 	logic [7:0]		Y,
               output 	logic  		   done,      
					output	logic [6:0]		color_index				
              );
    
		parameter [8:0] Size_X = 9'd358;		
		parameter [7:0] Size_Y = 8'd240;
		parameter [9:0] Screen_width = 9'd320;
		logic [16:0] idx_tile;
		logic [6:0] rom_back [0: Size_X * Size_Y - 1];
		
		initial
		begin
			 $readmemb("pictures/background_back.txt", rom_back);
		end
		
		enum logic {sleep, awake} state, next_state;
		logic [8:0] x_counter, x_next;
		logic [8:0] x_on_tile;
		logic [7:0] y_counter, y_next;
		logic next_done;
		assign x_on_tile = (x_counter + mapX[13:1]) % Size_X;
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
					if (x_counter + 9'b1 == Screen_width) begin
						x_next = 9'h0;
						if(y_counter + 8'b1 == Size_Y) begin
							next_state = sleep;
							y_next = 8'h0;
							next_done = 1'b1;
						end else begin
							y_next = y_counter + 8'b1;
						end
					end else begin
						x_next = x_counter + 9'b1;
					end
				end
			
			endcase
		end
		assign idx_tile = x_on_tile + y_counter * Size_X;
		assign color_index = rom_back[idx_tile];
		assign X = x_counter;
		assign Y = y_counter;

	 
	 
endmodule

module  background_front ( 
					input		logic 			clk, start, reset,   
					input   	logic	[15:0] 	mapX,
					output 	logic [8:0]		X,
					output 	logic [7:0]		Y,
               output 	logic  		   done,      
					output	logic [6:0]		color_index				
              );
    
		parameter [8:0] Size_X = 9'd473;     	
		parameter [7:0] Size_Y = 8'd240;
		parameter [8:0] Screen_width = 10'd320;
		logic [16:0] idx_tile;
		logic [6:0] rom_front [0: Size_X * Size_Y - 1];
		
		initial
		begin
			 $readmemb("pictures/background_front.txt", rom_front);
		end
		
		enum logic {sleep, awake} state, next_state;
		logic [8:0] x_counter, x_next;
		logic [8:0] x_on_tile;
		logic [7:0] y_counter, y_next;
		logic next_done;
		assign x_on_tile = (x_counter + mapX[12:0]) % Size_X;
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
					if (x_counter + 9'b1 == Screen_width) begin
						x_next = 9'b0;
						if(y_counter + 8'b1 == Size_Y) begin
							next_state = sleep;
							y_next = 8'b0;
							next_done = 1'b1;
						end else begin
							y_next = y_counter + 9'b1;
						end
					end else begin
						x_next = x_counter + 9'b1;
					end
				end
			endcase
			
		end
		assign idx_tile = x_on_tile + y_counter * Size_X;
		assign color_index = rom_front[idx_tile];
		assign X = x_counter;
		assign Y = y_counter;

endmodule

