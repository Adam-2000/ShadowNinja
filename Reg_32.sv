module reg_32 (				
				input  logic Clk, Reset, Load,
				input  logic [31:0]  D,
            output logic [31:0]  Data_Out
	);
	
	reg_8 Reg8_m0(.Clk, .Reset, .Load(Load), .D(D[7:0]), 		.Data_Out(Data_Out[7:0]));
	reg_8 Reg8_m1(.Clk, .Reset, .Load(Load), .D(D[15:8]), 	.Data_Out(Data_Out[15:8]));
	reg_8 Reg8_m2(.Clk, .Reset, .Load(Load), .D(D[23:16]), 	.Data_Out(Data_Out[23:16]));
	reg_8 Reg8_m3(.Clk, .Reset, .Load(Load), .D(D[31:24]), 	.Data_Out(Data_Out[31:24]));
	
	
endmodule

module reg_8 (				
				input  logic Clk, Reset, Load,
				input  logic [7:0]  D,
            output logic [7:0]  Data_Out
	);
	
	
	always_ff @ (posedge Clk) begin
		if (Reset) 
			Data_Out <= 8'h0;
		else if (Load)
			Data_Out <= D;
   end
	
endmodule
