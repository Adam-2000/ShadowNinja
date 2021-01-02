module  status ( 
					input		logic 			clk, start, reset,   
					input 	logic [15:0]	energy_life,
					input  	logic 			clock_5, 
					output 	logic [8:0]		X,
					output 	logic [7:0]		Y,
               output 	logic  		   done,      
					output	logic [6:0]		color_index					
              );
		parameter [8:0] start_x = 9'd40;
		parameter [7:0] height = 8'd6;
		
		parameter [7:0] life_y = 10;
		parameter [8:0] life_width = 9'd100;
		
		parameter [8:0] energy_width = 9'd80;
		parameter [7:0] energy_y = 8'd20;
		
		logic [6:0] life_val;
		logic [6:0] energy_val;
		assign life_val = energy_life[6:0];
		assign energy_val = energy_life[14:8];

		
		enum logic [2:0] {sleep, frame_life, frame_energy, life, energy} state, next_state;
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
		X = x_counter + start_x;
		Y = 8'h0;
		color_index = 7'h0;
		unique case(state) 
			sleep: begin
				if (start) begin
					next_state = frame_life;
				end
			end

			life: begin
				X = x_counter + start_x + 9'h1;
				Y = y_counter + life_y + 8'h1;
				color_index = 7'b1110000;
				if (x_counter[6:0] + 7'b1 == life_val) begin
					x_next = 9'h0;
					if(y_counter + 8'b1 == height) begin
						next_state = energy;
						y_next = 8'h0;
					end else begin
						y_next = y_counter + 1;
					end
				end else begin
					x_next = x_counter + 1;
				end
			end
			energy: begin
				X = x_counter + start_x + 9'h1;
				Y = y_counter + energy_y + 8'h1;
				color_index = 7'b1000011;
				if (x_counter[6:0] + 7'b1 == energy_val) begin
					x_next = 9'h0;
					if(y_counter + 8'b1 == height) begin
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
			frame_life: begin
				X = x_counter + start_x;
				Y = y_counter + life_y;
				color_index = (energy_life[7] & clock_5) ? 7'b1010100: 7'hff;
				if (x_counter == life_width + 9'b1) begin
					x_next = 9'h0;
					if(y_counter == height + 8'b1) begin
						next_state = frame_energy;
						y_next = 8'h0;
					end else begin
						y_next = y_counter + 1;
					end
				end else begin
					if (y_counter == 8'b0 || y_counter == height + 8'b1) begin
						x_next = x_counter + 1;
					end else begin
						x_next = life_width + 9'b1;
					end
				end
			end
			frame_energy: begin
				X = x_counter + start_x;
				Y = y_counter + energy_y;
				if (energy_life[15]) begin 
					color_index = (clock_5) ? 7'b1111000: 7'b1111100;
				end else begin
					color_index = 7'hff;
				end
				
				if (x_counter == energy_width + 9'b1) begin
					x_next = 9'h0;
					if(y_counter == height + 8'b1) begin
						next_state = life;
						y_next = 8'h0;
					end else begin
						y_next = y_counter + 1;
					end
				end else begin
					if (y_counter == 8'b0 || y_counter == height + 8'b1) begin
						x_next = x_counter + 1;
					end else begin
						x_next = energy_width + 9'b1;
					end
				end
			end
		endcase
		end
		
		
	 
endmodule
