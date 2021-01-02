module RegFile(
		input  logic 				CLK, RESET,
		input  logic 				AVL_READ,					// Avalon-MM Read
		input  logic 				AVL_WRITE,					// Avalon-MM Write
		input  logic 				AVL_CS,						// Avalon-MM Chip Select
		input  logic [3:0] 		AVL_BYTE_EN,				// Avalon-MM Byte Enable
		input  logic [5:0] 		AVL_ADDR,					// Avalon-MM Address
		input  logic [31:0] 		AVL_WRITEDATA,				// Avalon-MM Write Data
		output logic [31:0] 		AVL_READDATA,				// Avalon-MM Read Data
		
		// Exported Conduit
		output logic [31:0] 		EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic [31:0] Data [63:0];
logic [31:0] ReadData, WriteData;
logic [63:0] Load;
logic ReadEn, WriteEn;
logic DONE, START;
assign ReadEn = AVL_READ & AVL_CS;
assign WriteEn = AVL_WRITE & AVL_CS;
assign START = Data[62][0];                                                               

		
always_comb begin
	WriteData = AVL_WRITEDATA;
	Load = 64'b0;
	
	if (ReadEn) begin
		AVL_READDATA = ReadData;
	end else begin
		AVL_READDATA = 32'h0;
	end
		
	ReadData = Data[AVL_ADDR];
	Load[AVL_ADDR] = WriteEn;
		
end


///////////////////////////////////////////////////////////////////Drawer/////////////////////////////////////////////////
logic [7:0] VGA_R;
logic [7:0] VGA_G;
logic [7:0] VGA_B;
logic VGA_CLK;
logic VGA_SYNC_N;
logic VGA_BLANK_N;
logic VGA_VS;
logic VGA_HS;

assign EXPORT_DATA[7:0]		=	VGA_R 		;	
assign EXPORT_DATA[15:8]	=	VGA_G 		;
assign EXPORT_DATA[23:16]	=	VGA_B 		;
assign EXPORT_DATA[24]		=	VGA_CLK 		;
assign EXPORT_DATA[25]		=	VGA_SYNC_N 	;
assign EXPORT_DATA[26]		=	VGA_BLANK_N	;
assign EXPORT_DATA[27]		=	VGA_VS 		;
assign EXPORT_DATA[28]		=	VGA_HS 		;
assign EXPORT_DATA[31:29] 	= 	write_row[2:0];

vga_clk vga_clk_instance(.inclk0(CLK), .c0(VGA_CLK));

logic [9:0] DrawX, DrawY;
logic END, newDONE;
logic buffer_sel, buffer_sel_new;
logic start_signal, start_signal_next;

logic [7:0] color_index_out, color_index_in;

logic [5:0] reg_counter, next_reg_counter;
logic write_en;
logic start_object, done_object;
logic start_boss, done_boss;
//logic start_ninja, done_ninja;
logic start_bgf, done_bgf;
logic start_bgb, done_bgb;
//logic start_dart, done_dart;
logic start_icon, done_icon;
logic start_die, done_die;
logic start_kill, done_kill;
logic start_status, done_status;
logic [8:0] write_row, X_bgf, X_bgb, X_icon, X_status, X_object, X_die, X_boss, X_kill;
logic [7:0] write_col, Y_bgf, Y_bgb, Y_icon, Y_status, Y_object, Y_die, Y_boss, Y_kill;
logic [31:0] data_object;
logic [5:0] write_data;
logic [6:0] color_bgf, color_bgb, color_icon, color_status, color_object, color_die, color_boss, color_kill;
/////////////////////////////////////////////////frame_clock_counter///////////////////////////////
logic [31:0] clock_in, clock;
assign clock_in = clock + 32'b1;
reg_32 Reg_clock (.Clk(VGA_CLK), .Reset(RESET), .Load(END), .D(clock_in), .Data_Out(clock));		
////////////////////////////////////////////////////////////////////////////////////////////////////
VGA_controller vga_controller_instance(.Clk(CLK), .Reset(RESET), .VGA_HS, .VGA_VS, .VGA_CLK, .VGA_BLANK_N, .VGA_SYNC_N, .DrawX, .DrawY, .END);	

background_front 	backgroundf_instance(.clk(VGA_CLK), .start(start_bgf), .reset(RESET), .mapX(Data[0][15:0]), .X(X_bgf), .Y(Y_bgf), .done(done_bgf), .color_index(color_bgf));                       
background_back 	backgroundb_instance(.clk(VGA_CLK), .start(start_bgb), .reset(RESET), .mapX(Data[0][15:0]), .X(X_bgb), .Y(Y_bgb), .done(done_bgb), .color_index(color_bgb));                       
die die_instance(.clk(VGA_CLK), .start(start_die), .reset(RESET), .X(X_die), .Y(Y_die), .done(done_die), .color_index(color_die));
kill kill_instance(.clk(VGA_CLK), .start(start_kill), .reset(RESET), .X(X_kill), .Y(Y_kill), .done(done_kill), .color_index(color_kill));

icon icon_instance(.clk(VGA_CLK), .start(start_icon), .reset(RESET), .X(X_icon), .Y(Y_icon), .done(done_icon), .color_index(color_icon));
status status_instance(.clk(VGA_CLK), .start(start_status), .reset(RESET), .energy_life(Data[1][15:0]), .X(X_status), .Y(Y_status), .done(done_status), .color_index(color_status), .clock_5(clock[5]));
object object_instance(.clk(VGA_CLK), .start(start_object), .reset(RESET), .addr(reg_counter), .mapX(Data[0][15:0]), .Y_X(data_object), .X(X_object), .Y(Y_object), .done(done_object), .color_index(color_object), .clock(clock[7:0]));							    
boss boss_instance(.clk(VGA_CLK), .start(start_boss), .reset(RESET), .mapX(Data[0][15:0]), .Y_X(Data[47]), .X(X_boss), .Y(Y_boss), .done(done_boss), .color_index(color_boss), .clock_3(clock[3]));							    

//ninja ninja_instance(.clk(VGA_CLK), .start(start_ninja), .reset(RESET), .mapX(Data[0][15:0]), .Y_X(Data[1]), .X(X_ninja), .Y(Y_ninja), .done(done_ninja), .color_index_t(color_ninja));     
//dart dart_instance(.clk(VGA_CLK), .start(start_dart), .reset(RESET), .mapX(Data[0][15:0]), .Y_X(data_dart), .X(X_dart), .Y(Y_dart), .done(done_dart), .color_index_t(color_dart));                  
													 
framebuffer framebuffer_m0(.clk(CLK), .reset(RESET), .write_en, .write_row, .read_row(DrawX[9:1]), .write_col, 
									.read_col(DrawY[8:1]), .write_data, .buffer_sel, .read_data(color_index_out));	
palette palette_m0(.index(color_index_out), .R(VGA_R), .G(VGA_G), .B(VGA_B));

always_ff @(posedge VGA_CLK) begin
	if(RESET) begin
		start_signal <= 1'b0;
		buffer_sel <= 1'b0;
	end else begin
		start_signal <= start_signal_next;
		buffer_sel <= buffer_sel_new;
	end
end

always_ff @(posedge VGA_CLK) begin
	if(RESET) begin
		reg_counter <= 6'd32;
		DONE <= 1'b0;
		state <= ongo;
	end else begin
		reg_counter <= next_reg_counter;
		DONE <= newDONE;
		state <= next_state;
	end
end							

enum logic [3:0] {ready, finish, ongo, draw_backgroundb, draw_backgroundf, draw_objects, draw_icons, draw_status, draw_boss, draw_die, draw_kill} state, next_state;

always_comb begin
	start_signal_next = start_signal;
	buffer_sel_new = buffer_sel;
	
	next_reg_counter = reg_counter;
	write_en = 1'b0;
	newDONE = DONE;
	write_row = 0;
	write_col = 0;
	write_data = 0;
	//start_ninja = 1'b0;
	start_bgb = 1'b0;
	start_bgf = 1'b0;
	start_boss = 1'b0;
	start_die = 1'b0;
	start_kill = 1'b0;
	//start_dart = 1'b0;
	start_status = 1'b0;
	start_icon = 1'b0;
	start_object = 1'b0;
	next_state = state;
	data_object = 32'b0;
	//data_dart = Data[2];
	unique case (state)
		ongo: begin
			next_state = draw_backgroundb;
			start_bgb = 1'b1;
		end
		draw_backgroundb: begin
			start_bgb = 1'b0;
			write_row = X_bgb;
			write_col = Y_bgb;
			write_data = color_bgb[5:0];
			write_en = color_bgb[6];
			if (done_bgb) begin
				next_state = draw_backgroundf;
				start_bgf = 1'b1;
			end
		end
		draw_backgroundf: begin
			start_bgf = 1'b0;
			write_row = X_bgf;
			write_col = Y_bgf;
			write_data = color_bgf[5:0];
			write_en = color_bgf[6];
			if (done_bgf) begin
				if(Data[0][17])begin
					next_state = draw_boss;
					start_boss = 1'b1;
				end else begin
					next_state = draw_objects;
					start_object = 1'b1;
				end
			end
		end
		draw_boss: begin
			write_row = X_boss;
			write_col = Y_boss;
			write_data = color_boss[5:0];
			write_en = color_boss[6];
			if (done_boss) begin
				start_object = 1'b1;
				next_reg_counter = 6'd42; ///////////////////////////////////////
				next_state = draw_objects;
			end
		end
		draw_objects: begin
			write_row = X_object;
			write_col = Y_object;
			write_data = color_object[5:0];
			write_en = color_object[6];
			data_object = Data[reg_counter];
			if (done_object) begin
				if (reg_counter == 6'h02) begin
					next_state = draw_icons;
					next_reg_counter = 6'd42;
					start_icon = 1'b1;
				end else begin
					start_object = 1'b1;
					next_reg_counter = reg_counter - 6'b1;
				end
			end
		end
		draw_icons: begin
			start_icon = 1'b0;
			write_row = X_icon;
			write_col = Y_icon;
			write_data = color_icon[5:0];
			write_en = color_icon[6];
			if (done_icon) begin
				next_state = draw_status;
				start_status = 1'b1;
			end
		end
		draw_status: begin
			start_status = 1'b0;
			write_row = X_status;
			write_col = Y_status;
			write_data = color_status[5:0];
			write_en = color_status[6];
			if (done_status) begin
				if (Data[0][16]) begin
					next_state = draw_die;
					start_die = 1'b1;
				end else if (Data[0][18]) begin
					next_state = draw_kill;
					start_kill = 1'b1;
				end else begin
					next_state = finish;
				end
				
				newDONE = 1'b1;
			end
		end
		finish: begin
			if (start_signal) begin
				next_state = ready;
				newDONE = 1'b0;
			end
		end
		ready: begin
			if (END) begin
				start_signal_next = 1'b0;
				buffer_sel_new = ~buffer_sel;
				next_state = ongo;
			end	
		end
		draw_die: begin
			start_die = 1'b0;
			write_row = X_die;
			write_col = Y_die;
			write_data = color_die[5:0];
			write_en = color_die[6];
			if (done_die) begin
				next_state = finish;
			end
		end
		draw_kill: begin
			start_kill = 1'b0;
			write_row = X_kill;
			write_col = Y_kill;
			write_data = color_kill[5:0];
			write_en = color_kill[6];
			if (done_kill) begin
				next_state = finish;
			end
		end
		
		default: ;
	endcase
	
	if (START) begin
		start_signal_next = 1'b1;
	end
	
end	


//////////////////////////////////// STATE MACHINE ///////////////////////////////////////////////////////////
//enum logic [4:0] {}   State, Next_state;   // Internal state logic

///////////////////////////////////REGFILE/////////////////////////////////////////////////////////////////////////

reg_32 Reg0_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[0]), 		.D(WriteData), 		.Data_Out(Data[0]));
reg_32 Reg1_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[1]), 		.D(WriteData), 		.Data_Out(Data[1]));
reg_32 Reg2_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[2]), 		.D(WriteData), 		.Data_Out(Data[2]));
reg_32 Reg3_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[3]), 		.D(WriteData), 		.Data_Out(Data[3]));
	
reg_32 Reg4_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[4]), 		.D(WriteData), 		.Data_Out(Data[4]));
reg_32 Reg5_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[5]), 		.D(WriteData), 		.Data_Out(Data[5]));
reg_32 Reg6_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[6]), 		.D(WriteData), 		.Data_Out(Data[6]));
reg_32 Reg7_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[7]), 		.D(WriteData), 		.Data_Out(Data[7]));
	
reg_32 Reg8_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[8]), 		.D(WriteData), 		.Data_Out(Data[8]));
reg_32 Reg9_0	(.Clk(CLK), .Reset(RESET),	 .Load(Load[9]), 		.D(WriteData), 		.Data_Out(Data[9]));
reg_32 Rega_0	(.Clk(CLK), .Reset(RESET),  .Load(Load[10]), 	.D(WriteData), 		.Data_Out(Data[10]));
reg_32 Regb_0	(.Clk(CLK), .Reset(RESET),  .Load(Load[11]), 	.D(WriteData), 		.Data_Out(Data[11]));
 
reg_32 Regc_0	(.Clk(CLK), .Reset(RESET),  .Load(Load[12]), 	.D(WriteData), 		.Data_Out(Data[12]));
reg_32 Regd_0	(.Clk(CLK), .Reset(RESET),  .Load(Load[13]), 	.D(WriteData), 		.Data_Out(Data[13]));
reg_32 Rege_0	(.Clk(CLK), .Reset(RESET),  .Load(Load[14]), 	.D(WriteData), 		.Data_Out(Data[14]));
reg_32 Regf_0	(.Clk(CLK), .Reset(RESET),  .Load(Load[15]), 	.D(WriteData), 		.Data_Out(Data[15]));
 
reg_32 Reg0_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[16]), 	.D(WriteData), 		.Data_Out(Data[16]));
reg_32 Reg1_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[17]), 	.D(WriteData), 		.Data_Out(Data[17]));
reg_32 Reg2_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[18]), 	.D(WriteData), 		.Data_Out(Data[18]));
reg_32 Reg3_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[19]), 	.D(WriteData), 		.Data_Out(Data[19]));
														 					
reg_32 Reg4_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[20]), 	.D(WriteData), 		.Data_Out(Data[20]));
reg_32 Reg5_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[21]), 	.D(WriteData), 		.Data_Out(Data[21]));
reg_32 Reg6_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[22]), 	.D(WriteData), 		.Data_Out(Data[22]));
reg_32 Reg7_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[23]), 	.D(WriteData), 		.Data_Out(Data[23]));
														 					
reg_32 Reg8_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[24]), 	.D(WriteData), 		.Data_Out(Data[24]));
reg_32 Reg9_1	(.Clk(CLK), .Reset(RESET),	 .Load(Load[25]), 	.D(WriteData), 		.Data_Out(Data[25]));
reg_32 Rega_1	(.Clk(CLK), .Reset(RESET),  .Load(Load[26]), 	.D(WriteData), 		.Data_Out(Data[26]));
reg_32 Regb_1	(.Clk(CLK), .Reset(RESET),  .Load(Load[27]), 	.D(WriteData), 		.Data_Out(Data[27]));
														 					
reg_32 Regc_1	(.Clk(CLK), .Reset(RESET),  .Load(Load[28]), 	.D(WriteData), 		.Data_Out(Data[28]));
reg_32 Regd_1	(.Clk(CLK), .Reset(RESET),  .Load(Load[29]), 	.D(WriteData), 		.Data_Out(Data[29]));
reg_32 Rege_1	(.Clk(CLK), .Reset(RESET),  .Load(Load[30]), 	.D(WriteData), 		.Data_Out(Data[30]));
reg_32 Regf_1	(.Clk(CLK), .Reset(RESET),  .Load(Load[31]), 	.D(WriteData), 		.Data_Out(Data[31]));
														 					
reg_32 Reg0_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[32]), 	.D(WriteData), 		.Data_Out(Data[32]));
reg_32 Reg1_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[33]), 	.D(WriteData), 		.Data_Out(Data[33]));
reg_32 Reg2_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[34]), 	.D(WriteData), 		.Data_Out(Data[34]));
reg_32 Reg3_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[35]), 	.D(WriteData), 		.Data_Out(Data[35]));
														 					
reg_32 Reg4_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[36]), 	.D(WriteData), 		.Data_Out(Data[36]));
reg_32 Reg5_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[37]), 	.D(WriteData), 		.Data_Out(Data[37]));
reg_32 Reg6_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[38]), 	.D(WriteData), 		.Data_Out(Data[38]));
reg_32 Reg7_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[39]), 	.D(WriteData), 		.Data_Out(Data[39]));
														 					
reg_32 Reg8_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[40]), 	.D(WriteData), 		.Data_Out(Data[40]));
reg_32 Reg9_2	(.Clk(CLK), .Reset(RESET),	 .Load(Load[41]), 	.D(WriteData), 		.Data_Out(Data[41]));
reg_32 Rega_2	(.Clk(CLK), .Reset(RESET),  .Load(Load[42]), 	.D(WriteData), 		.Data_Out(Data[42]));
reg_32 Regb_2	(.Clk(CLK), .Reset(RESET),  .Load(Load[43]), 	.D(WriteData), 		.Data_Out(Data[43]));
														 					
reg_32 Regc_2	(.Clk(CLK), .Reset(RESET),  .Load(Load[44]), 	.D(WriteData), 		.Data_Out(Data[44]));
reg_32 Regd_2	(.Clk(CLK), .Reset(RESET),  .Load(Load[45]), 	.D(WriteData), 		.Data_Out(Data[45]));
reg_32 Rege_2	(.Clk(CLK), .Reset(RESET),  .Load(Load[46]), 	.D(WriteData), 		.Data_Out(Data[46]));
reg_32 Regf_2	(.Clk(CLK), .Reset(RESET),  .Load(Load[47]), 	.D(WriteData), 		.Data_Out(Data[47]));
														 					
//reg_32 Reg0_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[48]), 	.D(WriteData), 		.Data_Out(Data[48]));
//reg_32 Reg1_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[49]), 	.D(WriteData), 		.Data_Out(Data[49]));
//reg_32 Reg2_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[50]), 	.D(WriteData), 		.Data_Out(Data[50]));
//reg_32 Reg3_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[51]), 	.D(WriteData), 		.Data_Out(Data[51]));
//														 					
//reg_32 Reg4_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[52]), 	.D(WriteData), 		.Data_Out(Data[52]));
//reg_32 Reg5_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[53]), 	.D(WriteData), 		.Data_Out(Data[53]));
//reg_32 Reg6_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[54]), 	.D(WriteData), 		.Data_Out(Data[54]));
//reg_32 Reg7_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[55]), 	.D(WriteData), 		.Data_Out(Data[55]));
														 					
//reg_32 Reg8_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[56]), 	.D(WriteData), 		.Data_Out(Data[56]));
//reg_32 Reg9_3	(.Clk(CLK), .Reset(RESET),	 .Load(Load[57]), 	.D(WriteData), 		.Data_Out(Data[57]));
//reg_32 Rega_3	(.Clk(CLK), .Reset(RESET),  .Load(Load[58]), 	.D(WriteData), 		.Data_Out(Data[58]));
//reg_32 Regb_3	(.Clk(CLK), .Reset(RESET),  .Load(Load[59]), 	.D(WriteData), 		.Data_Out(Data[59]));
														 					
//reg_32 Regc_3	(.Clk(CLK), .Reset(RESET),  .Load(Load[60]), 	.D(WriteData), 		.Data_Out(Data[60]));
//reg_32 Regd_3	(.Clk(CLK), .Reset(RESET),  .Load(Load[61]), 	.D(WriteData), 		.Data_Out(Data[61]));
reg_32 Rege_3	(.Clk(CLK), .Reset(RESET),  .Load(Load[62]), 	.D(WriteData), 		.Data_Out(Data[62]));
reg_32 Regf_3	(.Clk(CLK), .Reset(RESET),  .Load(1'b1), 		.D({31'b0, DONE}), 	.Data_Out(Data[63]));

endmodule

