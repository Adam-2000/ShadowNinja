module avalon_aes_interface_ghost(
		input  logic 				CLK, RESET,
		input  logic 				AVL_READ,					// Avalon-MM Read
		input  logic 				AVL_WRITE,					// Avalon-MM Write
		input  logic 				AVL_CS,						// Avalon-MM Chip Select
		input  logic [3:0] 		AVL_BYTE_EN,				// Avalon-MM Byte Enable
		input  logic [3:0] 		AVL_ADDR,					// Avalon-MM Address
		input  logic [31:0] 		AVL_WRITEDATA,				// Avalon-MM Write Data
		output logic [31:0] 		AVL_READDATA,				// Avalon-MM Read Data
		
		// Exported Conduit
		output logic [31:0] 		EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic [31:0] Data [15:0];
logic [31:0] ReadData, WriteData;
logic [10:0] Load;
logic [4:0] LoadRd;
logic ReadEn, WriteEn;
logic AES_DONE;
logic [127:0] AES_MSG_DEC;

assign ReadEn = AVL_READ & AVL_CS;
assign WriteEn = AVL_WRITE & AVL_CS;
assign EXPORT_DATA = {Data[0][31:16], Data[3][15:0]};

reg_32 Reg_AES_KEY0		(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[0]), 	.D(WriteData), 				.Data_Out(Data[0]));
reg_32 Reg_AES_KEY1		(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[1]), 	.D(WriteData), 				.Data_Out(Data[1]));
reg_32 Reg_AES_KEY2		(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[2]), 	.D(WriteData), 				.Data_Out(Data[2]));
reg_32 Reg_AES_KEY3		(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[3]), 	.D(WriteData), 				.Data_Out(Data[3]));
				
reg_32 Reg_AES_MSG_EN0	(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[4]), 	.D(WriteData), 				.Data_Out(Data[4]));
reg_32 Reg_AES_MSG_EN1	(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[5]), 	.D(WriteData), 				.Data_Out(Data[5]));
reg_32 Reg_AES_MSG_EN2	(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[6]), 	.D(WriteData), 				.Data_Out(Data[6]));
reg_32 Reg_AES_MSG_EN3	(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(Load[7]), 	.D(WriteData), 				.Data_Out(Data[7]));
				
reg_32 Reg_AES_MSG_DE0	(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(LoadRd[0]), .D(AES_MSG_DEC[127:96]), 	.Data_Out(Data[8]));
reg_32 Reg_AES_MSG_DE1	(.Clk(CLK), .Reset(RESET),	.ByteEn(AVL_BYTE_EN),	.Load(LoadRd[1]), .D(AES_MSG_DEC[95:64]), 	.Data_Out(Data[9]));
reg_32 Reg_AES_MSG_DE2	(.Clk(CLK), .Reset(RESET), .ByteEn(AVL_BYTE_EN),	.Load(LoadRd[2]), .D(AES_MSG_DEC[63:32]), 	.Data_Out(Data[10]));
reg_32 Reg_AES_MSG_DE3	(.Clk(CLK), .Reset(RESET), .ByteEn(AVL_BYTE_EN),	.Load(LoadRd[3]), .D(AES_MSG_DEC[31:0]), 		.Data_Out(Data[11]));
				
reg_32 Reg12				(.Clk(CLK), .Reset(RESET), .ByteEn(AVL_BYTE_EN),	.Load(Load[8]), 	.D(WriteData), 				.Data_Out(Data[12]));
reg_32 Reg13				(.Clk(CLK), .Reset(RESET), .ByteEn(AVL_BYTE_EN),	.Load(Load[9]), 	.D(WriteData), 				.Data_Out(Data[13]));
reg_32 Reg_AES_START		(.Clk(CLK), .Reset(RESET), .ByteEn(AVL_BYTE_EN),	.Load(Load[10]), 	.D(WriteData), 				.Data_Out(Data[14]));
reg_32 Reg_AES_DONE		(.Clk(CLK), .Reset(RESET), .ByteEn(AVL_BYTE_EN),	.Load(LoadRd[4]), .D({{31'b0}, AES_DONE}), 	.Data_Out(Data[15]));

AES AES_m0
(	.CLK, .RESET, .AES_START(Data[14]), .AES_DONE, 
	.AES_KEY({Data[0], Data[1], Data[2], Data[3]}), 
	.AES_MSG_ENC({Data[4], Data[5], Data[6], Data[7]}), 
	.AES_MSG_DEC
	//,.EXPORT_DATA
);
                                                                   
		
always_comb begin
	WriteData = AVL_WRITEDATA;
	Load = 11'b0;
	AVL_READDATA = 32'h0;
	if (ReadEn) 
		AVL_READDATA = ReadData;
		
	unique case (AVL_ADDR) 
		4'h0: begin 
			ReadData = Data[0][31:0];
			Load[0] = WriteEn;
		end
		4'h1: begin 
			ReadData = Data[1][31:0];
			Load[1] = WriteEn;
		end
		4'h2: begin 
			ReadData = Data[2][31:0];
			Load[2] = WriteEn;
		end
		4'h3: begin 
			ReadData = Data[3][31:0];
			Load[3] = WriteEn;
		end
		4'h4: begin 
			ReadData = Data[4][31:0];
			Load[4] = WriteEn;
		end
		4'h5: begin 
			ReadData = Data[5][31:0];
			Load[5] = WriteEn;
		end
		4'h6: begin 
			ReadData = Data[6][31:0];
			Load[6] = WriteEn;
		end
		4'h7: begin 
			ReadData = Data[7][31:0];
			Load[7] = WriteEn;
		end
		4'h8: begin 
			ReadData = Data[8][31:0];
		end
		4'h9: begin 
			ReadData = Data[9][31:0];
		end
		4'ha: begin 
			ReadData = Data[10][31:0];
		end
		4'hb: begin 
			ReadData = Data[11][31:0];
		end
		4'hc: begin 
			ReadData = Data[12][31:0];
			Load[8] = WriteEn;
		end
		4'hd: begin 
			ReadData = Data[13][31:0];
			Load[9] = WriteEn;
		end
		4'he: begin 
			ReadData = Data[14][31:0];
			Load[10] = WriteEn;
		end
		4'hf: begin 
			ReadData = Data[15][31:0]; 
		end
		default: begin
			ReadData = 32'h0;
		end
	endcase
end

always_comb begin
	LoadRd = 5'b00000;
	if (AES_DONE) begin
		LoadRd = 5'b11111;
	end
end

endmodule

