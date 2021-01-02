module  object ( 
					input		logic 			clk, start, reset,   
					input 	logic [5:0] 	addr,
					input   	logic	[15:0] 	mapX,
					input 	logic [31:0]	Y_X,
					input 	logic [7:0]		clock,
					output 	logic [8:0]		X,
					output 	logic [7:0]		Y,
               output 	logic  		   done,      
					output	logic [6:0]		color_index 					
              );
				  
  
				  
		parameter [8:0] Size_X_ninja 		= 9'd24;
		parameter [8:0] Size_X_dart 		= 9'd6;
		parameter [8:0] Size_X_boom 		= 9'd8;
		parameter [8:0] Size_X_iceball 	= 9'd30;
		parameter [8:0] Size_X_icearrow	= 9'd56;
		parameter [8:0] Size_X_bluehead 	= 9'd24;
		parameter [8:0] Size_X_skullhead = 9'd28;
		parameter [8:0] Size_X_lady 		= 9'd25;
		parameter [8:0] Size_X_fireball_hor = 9'd35;
		parameter [8:0] Size_X_swampt 	= 9'd20;
		parameter [8:0] Size_X_zombie 	= 9'd24;
		parameter [8:0] Size_X_campfire 	= 9'd19;
		parameter [8:0] Size_X_campwood 	= 9'd40;
		parameter [8:0] Size_X_fireball 	= 9'd24;   
		
		parameter [7:0] Size_Y_ninja 		= 8'd32;
		parameter [7:0] Size_Y_dart	 	= 8'd6;
		parameter [7:0] Size_Y_boom 		= 8'd8;
		parameter [7:0] Size_Y_iceball 	= 8'd30;
		parameter [7:0] Size_Y_icearrow 	= 8'd14;
		parameter [7:0] Size_Y_bluehead 	= 8'd20;
		parameter [7:0] Size_Y_skullhead = 8'd24;
		parameter [7:0] Size_Y_lady 		= 8'd34;
		parameter [7:0] Size_Y_fireball_hor = 8'd20;
		parameter [7:0] Size_Y_swampt 	= 8'd30;
		parameter [7:0] Size_Y_zombie 	= 8'd34;
		parameter [7:0] Size_Y_campfire 	= 8'd30;
		parameter [7:0] Size_Y_campwood 	= 8'd21;
		parameter [7:0] Size_Y_fireball 	= 8'd24;
		
		logic [8:0] Size_X;
		logic [7:0] Size_Y;
		logic [9:0] idx_tile;
		
		logic [6:0] rom_ninja_stand1 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_stand2 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_air	 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_kneel 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_dead	 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_throw 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_squat 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_run1 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_run2 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_run3 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_run4 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_spin1 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_spin2 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_spin3 	[0: Size_X_ninja * Size_Y_ninja - 1];
		logic [6:0] rom_ninja_spin4 	[0: Size_X_ninja * Size_Y_ninja - 1];
		
		
		
		logic [6:0] rom_dart1 			[0: Size_X_dart * Size_Y_dart - 1];
		logic [6:0] rom_dart2 			[0: Size_X_dart * Size_Y_dart - 1];
		logic [6:0] rom_boom1 			[0: Size_X_boom * Size_Y_boom - 1];
		logic [6:0] rom_boom2 			[0: Size_X_boom * Size_Y_boom - 1];
		logic [6:0] rom_iceball 		[0: Size_X_iceball * Size_Y_iceball - 1];
		logic [6:0] rom_icearrow 		[0: Size_X_icearrow * Size_Y_icearrow - 1];
		logic [6:0] rom_bluehead1 		[0: Size_X_bluehead * Size_Y_bluehead - 1];
		logic [6:0] rom_bluehead2 		[0: Size_X_dart * Size_Y_dart - 1];
		logic [6:0] rom_skullhead1 	[0: Size_X_skullhead * Size_Y_skullhead - 1];
		logic [6:0] rom_skullhead2 	[0: Size_X_skullhead * Size_Y_skullhead - 1];
		logic [6:0] rom_lady1 			[0: Size_X_lady * Size_Y_lady - 1];
		logic [6:0] rom_lady2 			[0: Size_X_lady * Size_Y_lady - 1];
		logic [6:0] rom_swampt1 		[0: Size_X_swampt * Size_Y_swampt - 1];
		logic [6:0] rom_swampt2 		[0: Size_X_swampt * Size_Y_swampt - 1];
		logic [6:0] rom_swampt3 		[0: Size_X_swampt * Size_Y_swampt - 1];
		logic [6:0] rom_zombie1 		[0: Size_X_zombie * Size_Y_zombie - 1];
		logic [6:0] rom_zombie2 		[0: Size_X_zombie * Size_Y_zombie - 1];
		logic [6:0] rom_zombie3 		[0: Size_X_zombie * Size_Y_zombie - 1];
		logic [6:0] rom_campfire1 		[0: Size_X_campfire * Size_Y_campfire - 1];
		logic [6:0] rom_campfire2 		[0: Size_X_campfire * Size_Y_campfire - 1];
		logic [6:0] rom_campfire3 		[0: Size_X_campfire * Size_Y_campfire - 1];
		logic [6:0] rom_campfire4 		[0: Size_X_campfire * Size_Y_campfire - 1];
		logic [6:0] rom_campfire5 		[0: Size_X_campfire * Size_Y_campfire - 1];
		logic [6:0] rom_campfire6 		[0: Size_X_campfire * Size_Y_campfire - 1];
		logic [6:0] rom_campwood1 		[0: Size_X_campwood * Size_Y_campwood - 1];
		logic [6:0] rom_campwood2 		[0: Size_X_campwood * Size_Y_campwood - 1];
		logic [6:0] rom_fireball1 		[0: Size_X_fireball * Size_Y_fireball - 1];
		logic [6:0] rom_fireball2 		[0: Size_X_fireball * Size_Y_fireball - 1];
		logic [6:0] rom_fireball3 		[0: Size_X_fireball_hor * Size_Y_fireball_hor - 1];
		logic [6:0] rom_fireball4 		[0: Size_X_fireball_hor * Size_Y_fireball_hor - 1];
		initial
		begin
			 $readmemb("pictures/ninja_stand1.txt", 		rom_ninja_stand1);
			 $readmemb("pictures/ninja_stand2.txt", 		rom_ninja_stand2);
			 $readmemb("pictures/ninja_squat.txt", 		rom_ninja_squat);
			 $readmemb("pictures/ninja_air.txt",	 		rom_ninja_air	);
			 $readmemb("pictures/ninja_kneel.txt",	 		rom_ninja_kneel);
			 $readmemb("pictures/ninja_dead.txt",	 		rom_ninja_dead	);
			 $readmemb("pictures/ninja_throw.txt",	 		rom_ninja_throw);
			 $readmemb("pictures/ninja_run1.txt", 			rom_ninja_run1 );
			 $readmemb("pictures/ninja_run2.txt", 			rom_ninja_run2 );
			 $readmemb("pictures/ninja_run3.txt", 			rom_ninja_run3 );
			 $readmemb("pictures/ninja_run4.txt", 			rom_ninja_run4 );
			 $readmemb("pictures/ninja_spin1.txt", 		rom_ninja_spin1);
			 $readmemb("pictures/ninja_spin2.txt", 		rom_ninja_spin2);
			 $readmemb("pictures/ninja_spin3.txt", 		rom_ninja_spin3);
			 $readmemb("pictures/ninja_spin4.txt", 		rom_ninja_spin4);
			 
			 $readmemb("pictures/dart1.txt", 		rom_dart1 	);
			 $readmemb("pictures/dart2.txt", 		rom_dart2 	);
			 $readmemb("pictures/boom1.txt", 		rom_boom1 	);
			 $readmemb("pictures/boom2.txt", 		rom_boom2 	);
			 $readmemb("pictures/iceball.txt", 		rom_iceball );
			 $readmemb("pictures/icearrow.txt", 	rom_icearrow );
			 $readmemb("pictures/bluehead1.txt", 	rom_bluehead1);
			 $readmemb("pictures/bluehead2.txt", 	rom_bluehead2);
			 $readmemb("pictures/skullhead1.txt", 	rom_skullhead1);
			 $readmemb("pictures/skullhead2.txt", 	rom_skullhead2);
			 $readmemb("pictures/lady1.txt", 		rom_lady1 	);
			 $readmemb("pictures/lady2.txt", 		rom_lady2 	);
			 $readmemb("pictures/swampt1.txt", 		rom_swampt1 );
			 $readmemb("pictures/swampt2.txt", 		rom_swampt2 );
			 $readmemb("pictures/swampt3.txt", 		rom_swampt3 );
			 $readmemb("pictures/zombie1.txt", 		rom_zombie1 );
			 $readmemb("pictures/zombie2.txt", 		rom_zombie2 );
			 $readmemb("pictures/zombie3.txt", 		rom_zombie3 );
			 $readmemb("pictures/campfire1.txt", 	rom_campfire1);
			 $readmemb("pictures/campfire2.txt", 	rom_campfire2);
			 $readmemb("pictures/campfire3.txt", 	rom_campfire3);
			 $readmemb("pictures/campfire4.txt", 	rom_campfire4);
			 $readmemb("pictures/campfire5.txt", 	rom_campfire5);
			 $readmemb("pictures/campfire6.txt", 	rom_campfire6);
			 $readmemb("pictures/campwood1.txt", 	rom_campwood1);
			 $readmemb("pictures/campwood2.txt", 	rom_campwood2);
			 $readmemb("pictures/fireball1.txt", 	rom_fireball1);
			 $readmemb("pictures/fireball2.txt", 	rom_fireball2);
			 $readmemb("pictures/fireball3.txt", 	rom_fireball3);
			 $readmemb("pictures/fireball4.txt", 	rom_fireball4);
			 
		end
		
		logic [6:0] color_index_buffer;
		
		always_comb begin
			color_index_buffer = 7'b0;
			color_index = 7'b0;
			unique case(addr)
				/////////////////////////////ninja///////////////////////////////////////////
				6'd32: begin //ninja
					Size_X = Size_X_ninja;
					Size_Y = Size_Y_ninja;
					unique case (Y_X[28:26])
						3'b000: begin //stand
							color_index_buffer = clock[4] ? rom_ninja_stand1[idx_tile] : rom_ninja_stand2[idx_tile];
						end
						3'b001: begin //spin
							unique case (clock[4:3])
								2'b00: 
									color_index_buffer = rom_ninja_spin1[idx_tile];
								2'b01: 
									color_index_buffer = rom_ninja_spin2[idx_tile];
								2'b10: 
									color_index_buffer = rom_ninja_spin3[idx_tile];
								2'b11:
									color_index_buffer = rom_ninja_spin4[idx_tile];
							endcase
						end
						3'b010: begin //air
							color_index_buffer = rom_ninja_air[idx_tile];
						end
						3'b011: begin //throw
							color_index_buffer = rom_ninja_throw[idx_tile];
						end
						3'b100: begin //kneel
							color_index_buffer = rom_ninja_kneel[idx_tile];
						end
						3'b101: begin //dead
							color_index_buffer = rom_ninja_dead[idx_tile];
						end
						3'b110: begin //squat
							color_index_buffer = rom_ninja_squat[idx_tile];
						end
						3'b111: begin //run
							unique case (clock[4:2])
								3'b000, 3'b111: 
									color_index_buffer = rom_ninja_run1[idx_tile];
								3'b001, 3'b110: 
									color_index_buffer = rom_ninja_run2[idx_tile];
								3'b010, 3'b101: 
									color_index_buffer = rom_ninja_run3[idx_tile];
								3'b011, 3'b100: 
									color_index_buffer = rom_ninja_run4[idx_tile];
								default:;
							endcase
						end
						
					endcase
					if(Y_X[25] & color_index_buffer[6] & ((~color_index_buffer[5]) | (color_index_buffer[5] & color_index_buffer[1] & color_index_buffer[0]))) begin  
						color_index = 7'h40;
					end else begin
						color_index = color_index_buffer;
					end
				end
				//////////////////////////////////////////////////////////////////////////////
				6'd2, 6'd3, 6'd4, 6'd5: begin //dart
					Size_X = Size_X_dart;
					Size_Y = Size_Y_dart;
					color_index = clock[3] ? rom_dart2[idx_tile] : rom_dart1[idx_tile];
				end
				6'd6, 6'd7, 6'd8, 6'd9: begin //boom
					Size_X = Size_X_boom;
					Size_Y = Size_Y_boom;
					color_index = clock[3] ? rom_boom2[idx_tile] : rom_boom1[idx_tile];
				end
				
				6'd10, 6'd11: begin //iceball
					Size_X = Size_X_iceball;
					Size_Y = Size_Y_iceball;
					color_index = rom_iceball[idx_tile];
				end
				
				6'd12, 6'd13: begin //icearrow
					Size_X = Size_X_icearrow;
					Size_Y = Size_Y_icearrow;
					color_index = rom_icearrow[idx_tile];
				end
				6'd14, 6'd15, 6'd16, 6'd17: begin //bluehead
					Size_X = Size_X_bluehead;
					Size_Y = Size_Y_bluehead;
					color_index = Y_X[28] ? rom_bluehead2[idx_tile] : rom_bluehead1[idx_tile];
				end
				6'd18, 6'd19: begin //skullhead
					Size_X = Size_X_skullhead;
					Size_Y = Size_Y_skullhead;
					color_index = Y_X[28] ? rom_skullhead2[idx_tile] : rom_skullhead1[idx_tile];
				end
				6'd20, 6'd21, 6'd22, 6'd23: begin //lady
					Size_X = Size_X_lady;
					Size_Y = Size_Y_lady;
					color_index = Y_X[28] ? rom_lady2[idx_tile] : rom_lady1[idx_tile];
				end
				6'd25, 6'd26, 6'd27, 6'd28: begin //fireball
					Size_X = Size_X_fireball;
					Size_Y = Size_Y_fireball;
					color_index = clock[2] ? rom_fireball2[idx_tile] : rom_fireball1[idx_tile];
				end
				6'd29, 6'd30, 6'd31: begin //fireball_hor
					Size_X = Size_X_fireball_hor;
					Size_Y = Size_Y_fireball_hor;
					color_index = clock[2] ? rom_fireball4[idx_tile] : rom_fireball3[idx_tile];
				end
				6'd33, 6'd34, 6'd35, 6'd36: begin //swampt
					Size_X = Size_X_swampt;
					Size_Y = Size_Y_swampt;
					if (Y_X[28]) begin
						color_index = rom_swampt3[idx_tile];
					end else begin
						color_index = clock[4] ? rom_swampt2[idx_tile] : rom_swampt1[idx_tile];
					end
				end
				6'd37, 6'd38, 6'd39, 6'd40: begin //zombie
					Size_X = Size_X_zombie;
					Size_Y = Size_Y_zombie;
					if (clock[5]) begin
						color_index = rom_zombie3[idx_tile];
					end else begin
						color_index = clock[4] ? rom_zombie2[idx_tile] : rom_zombie1[idx_tile];
					end
				end
				6'd41: begin //campfire
					Size_X = Size_X_campfire;
					Size_Y = Size_Y_campfire;
					unique case (clock[4:2])
						3'b000, 3'b100:
							color_index =  rom_campfire1[idx_tile];
						3'b001, 3'b101:
							color_index =  rom_campfire2[idx_tile];
						3'b010:
							color_index =  rom_campfire3[idx_tile];
						3'b011:
							color_index =  rom_campfire4[idx_tile];
						3'b110:
							color_index =  rom_campfire5[idx_tile];
						3'b111:
							color_index =  rom_campfire6[idx_tile];
					endcase
				end
				6'd42: begin //campwood
					Size_X = Size_X_campwood;
					Size_Y = Size_Y_campwood;
					color_index = Y_X[28] ? rom_campwood2[idx_tile] : rom_campwood1[idx_tile];
				end
				default: begin
					Size_X = 9'b1;
					Size_Y = 8'b1;
				end
			endcase
			
			
			if (X >= 320 || Y >= 240) begin
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
					if (Y_X[31] == 1'b0 || Y_X[12:0]  >= mapX[12:0] + 13'd320 || Y_X[12:0] + Size_X <= mapX[12:0]) begin
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
		
		assign X = Y_X[8:0] - mapX[8:0] +  x_counter;
		assign Y = Y_X[23:16] +  y_counter;
		always_comb begin
			if (Y_X[30]) begin
				idx_tile = x_counter + y_counter * Size_X;
			end else begin
				idx_tile = Size_X - x_counter + y_counter * Size_X;
			end
		end	
	
endmodule
