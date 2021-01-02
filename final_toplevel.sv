/************************************************************************
Lab 9 Quartus Project Top Level

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module final_toplevel (
	input  logic        	CLOCK_50,
	input  logic [3:0]  	KEY,
	output logic [7:0]  	LEDG,
	output logic [17:0] 	LEDR,
	output logic [6:0]  	HEX0,
	output logic [6:0]  	HEX1,
	output logic [6:0]  	HEX2,
	output logic [6:0]  	HEX3,
	output logic [6:0]  	HEX4,
	output logic [6:0]  	HEX5,
	output logic [6:0]  	HEX6,
	output logic [6:0]  	HEX7,
	output logic [12:0] 	DRAM_ADDR,
	output logic [1:0]  	DRAM_BA,
	output logic        	DRAM_CAS_N,
	output logic        	DRAM_CKE,
	output logic        	DRAM_CS_N,
	inout  logic [31:0] 	DRAM_DQ,
	output logic [3:0]  	DRAM_DQM,
	output logic        	DRAM_RAS_N,
	output logic        	DRAM_WE_N,
	output logic        	DRAM_CLK,
	
	output logic [7:0]  	VGA_R,        //VGA Red
								VGA_G,        //VGA Green
								VGA_B,        //VGA Blue
	output logic			VGA_CLK,      //VGA Clock
								VGA_SYNC_N,   //VGA Sync signal
								VGA_BLANK_N,  //VGA Blank signal
								VGA_VS,       //VGA virtical sync signal
								VGA_HS,       //VGA horizontal sync signal
	// CY7C67200 Interface
	inout  wire  [15:0] 	OTG_DATA,     //CY7C67200 Data bus 16 Bits
	output logic [1:0]  	OTG_ADDR,     //CY7C67200 Address 2 Bits
	output logic        	OTG_CS_N,     //CY7C67200 Chip Select
								OTG_RD_N,     //CY7C67200 Write
								OTG_WR_N,     //CY7C67200 Read
								OTG_RST_N,    //CY7C67200 Reset
	input               	OTG_INT      //CY7C67200 Interrupt
);

// Exported data to show on Hex displays
logic [31:0] Regfile_export;
assign VGA_R 			= Regfile_export[7:0];
assign VGA_G 			= Regfile_export[15:8];
assign VGA_B 			= Regfile_export[23:16];
assign VGA_CLK 		= Regfile_export[24];
assign VGA_SYNC_N 	= Regfile_export[25];
assign VGA_BLANK_N 	= Regfile_export[26];
assign VGA_VS 			= Regfile_export[27];
assign VGA_HS 			= Regfile_export[28];
// Instantiation of Qsys design
	final_soc final_qsystem (
				  .clk_clk(Clk),         
				  .reset_reset_n(KEY[0]),    // Never reset NIOS
				  .sdram_wire_addr(DRAM_ADDR), 
				  .sdram_wire_ba(DRAM_BA),   
				  .sdram_wire_cas_n(DRAM_CAS_N),
				  .sdram_wire_cke(DRAM_CKE),  
				  .sdram_wire_cs_n(DRAM_CS_N), 
				  .sdram_wire_dq(DRAM_DQ),   
				  .sdram_wire_dqm(DRAM_DQM),  
				  .sdram_wire_ras_n(DRAM_RAS_N),
				  .sdram_wire_we_n(DRAM_WE_N), 
				  .sdram_clk_clk(DRAM_CLK),
				  .keycode_export(keycode),  
				  .otg_hpi_address_export(hpi_addr),
				  .otg_hpi_data_in_port(hpi_data_in),
				  .otg_hpi_data_out_port(hpi_data_out),
				  .otg_hpi_cs_export(hpi_cs),
				  .otg_hpi_r_export(hpi_r),
				  .otg_hpi_w_export(hpi_w),
				  .otg_hpi_reset_export(hpi_reset),
				  
				  .register_file_0_export_data_export_data(Regfile_export)
	);
logic Reset_h, Clk;
logic [7:0] keycode;

assign Clk = CLOCK_50;
always_ff @ (posedge Clk) begin
	Reset_h <= ~(KEY[0]);        // The push buttons are active low
end

logic [1:0] hpi_addr;
logic [15:0] hpi_data_in, hpi_data_out;
logic hpi_r, hpi_w, hpi_cs, hpi_reset;

// Interface between NIOS II and EZ-OTG chip
hpi_io_intf hpi_io_inst(
				 .Clk(Clk),
				 .Reset(Reset_h),
				 // signals connected to NIOS II
				 .from_sw_address(hpi_addr),
				 .from_sw_data_in(hpi_data_in),
				 .from_sw_data_out(hpi_data_out),
				 .from_sw_r(hpi_r),
				 .from_sw_w(hpi_w),
				 .from_sw_cs(hpi_cs),
				 .from_sw_reset(hpi_reset),
				 // signals connected to EZ-OTG chip
				 .OTG_DATA(OTG_DATA),    
				 .OTG_ADDR(OTG_ADDR),    
				 .OTG_RD_N(OTG_RD_N),    
				 .OTG_WR_N(OTG_WR_N),    
				 .OTG_CS_N(OTG_CS_N),
				 .OTG_RST_N(OTG_RST_N)
);
       
                                           
// Display keycode on hex display                  
//    hexdriver hex_inst_0 (keycode[3:0], HEX0);
//    hexdriver hex_inst_1 (keycode[7:4], HEX1);
	 
	 
	 

// Display the first 4 and the last 4 hex values of the received message
hexdriver hexdrv0 (
	.In(Regfile_export[3:0]),
   .Out(HEX0)
);
hexdriver hexdrv1 (
	.In(Regfile_export[7:4]),
   .Out(HEX1)
);
hexdriver hexdrv2 (
	.In(Regfile_export[11:8]),
   .Out(HEX2)
);
hexdriver hexdrv3 (
	.In(Regfile_export[15:12]),
   .Out(HEX3)
);
hexdriver hexdrv4 (
	.In(Regfile_export[19:16]),
   .Out(HEX4)
);
hexdriver hexdrv5 (
	.In(Regfile_export[23:20]),
   .Out(HEX5)
);
hexdriver hexdrv6 (
	.In(Regfile_export[27:24]),
   .Out(HEX6)
);
hexdriver hexdrv7 (
	.In(Regfile_export[31:28]),
   .Out(HEX7)
);
assign LEDR[0] = Regfile_export[29];
assign LEDR[1] = Regfile_export[30];
assign LEDR[2] = Regfile_export[31];
endmodule

