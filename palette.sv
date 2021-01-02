module palette(
		input 	logic [5:0] 	index,
		output 	logic [7:0] 	R, G, B
);

	
	always_comb begin
		R = 85 * index[5:4];
		G = 85 * index[3:2];
		B = 85 * index[1:0];
	end
	
		
endmodule
