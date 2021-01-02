module buffer(
		input 	logic 			clk, write_en,
		input 	logic [16:0]	address,
		input 	logic [5:0]		data_in,
		output 	logic [5:0]		data_out
);
	
logic [5:0] mem [0:76799];

initial
begin
	 $readmemb("pictures/zeros.txt", mem);
end


always_ff @ (posedge clk) begin
	if (write_en)
		mem[address] <= data_in;
	data_out<= mem[address];
end

endmodule
