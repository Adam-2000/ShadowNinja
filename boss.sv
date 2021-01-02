module  boss ( 
					input		logic 			clk, start, reset,   
					input   	logic	[15:0] 	mapX,
					input 	logic [31:0]	Y_X,
					input 	logic 			clock_3,
					output 	logic [8:0]		X,
					output 	logic [7:0]		Y,
               output 	logic  		   done,      
					output	logic [6:0]		color_index 					
              );
				  
  
				  
		parameter [8:0] Size_X 		= 9'd270;
		parameter [7:0] Size_Y	 	= 8'd240;
		
		logic [15:0] idx_tile;
		
		logic [6:0] rom_boss0 	[0: Size_X * Size_Y - 1];
//		logic [6:0] rom_boss1 	[0: Size_X * Size_Y - 1];
//		logic [6:0] rom_boss2	[0: Size_X * Size_Y - 1];
//		logic [6:0] rom_boss3	[0: Size_X * Size_Y - 1];
		logic [6:0] rom_boss4	[0: Size_X * Size_Y - 1];
//		logic [6:0] rom_boss5	[0: Size_X * Size_Y - 1];
//		logic [6:0] rom_boss6	[0: Size_X * Size_Y - 1];

		
		initial
		begin
			 $readmemb("pictures/boss0.txt", 	rom_boss0);
//			 $readmemb("pictures/boss1.txt", 	rom_boss1);
//			 $readmemb("pictures/boss2.txt", 	rom_boss2);
//			 $readmemb("pictures/boss3.txt",	 	rom_boss3);
			 $readmemb("pictures/boss4.txt",	 	rom_boss4);
//			 $readmemb("pictures/boss5.txt",	 	rom_boss5);
//			 $readmemb("pictures/boss6.txt",	 	rom_boss6);
			 
		end
		
		logic [10:0] X_buffer;
		
		always_comb begin
			color_index = 7'b0;
			unique case (Y_X[28])
				1'b0: begin 
					color_index = rom_boss0[idx_tile];
				end
//				3'b001: begin 
//					color_index = rom_boss1[idx_tile];
//				end
//				3'b010: begin 
//					color_index = rom_boss2[idx_tile];
//				end
//				3'b011: begin 
//					color_index = rom_boss3[idx_tile];
//				end
				1'b1: begin 
					color_index = rom_boss4[idx_tile];
				end
//				3'b101: begin 
//					color_index = rom_boss5[idx_tile];
//				end
//				3'b110: begin 
//					color_index = rom_boss6[idx_tile];
//				end
			endcase
			if (X_buffer >= 11'd320) begin
				color_index[6] = 1'b0;
			end
		end		
		
		
		enum logic [1:0] {sleep, check, awake} state, next_state;
		logic [8:0] x_counter, x_next;
		logic [7:0] y_counter, y_next;
		logic next_done;
		always_ff @ (posedge clk) begin
			if (reset) begin
				state <= sleep;
				x_counter <= 9'h00;
				y_counter <= 8'h00;
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
							next_state = check;
					end
				end
				
				check: begin
					if (~Y_X[31] | (clock_3 & Y_X[29])) begin
						next_done = 1'b1;
						next_state = sleep;
					end else begin
						next_state = awake;
					end
				end
				
				awake: begin
					if (x_counter + 9'b1 == Size_X) begin
						x_next = 9'h00;
						if(y_counter + 8'b1 == Size_Y) begin
							next_state = sleep;
							y_next = 8'h00;
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
		
		assign X_buffer = Y_X[10:0] - mapX[10:0] +  x_counter;
		assign X = X_buffer[8:0];
		assign Y = y_counter;
		always_comb begin
			if (Y_X[30]) begin
				idx_tile = x_counter + y_counter * Size_X;
			end else begin
				idx_tile = Size_X - x_counter + y_counter * Size_X;
			end
		end	
	
endmodule
