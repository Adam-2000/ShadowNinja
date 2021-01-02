module framebuffer(
		input logic clk, reset, write_en, 
		input logic [8:0] write_row, read_row,
		input logic [7:0] write_col, read_col,
		input logic [5:0] write_data,
		input logic buffer_sel,
		output logic [5:0] read_data

);

parameter size_y = 240;
parameter size_x = 320;

logic [16:0] address1, address2;
logic [5:0] data1, data2;
logic we1, we2;
buffer buffer1(.clk, .write_en(we1), .address(address1), .data_in(write_data), .data_out(data1));
buffer buffer2(.clk, .write_en(we2), .address(address2), .data_in(write_data), .data_out(data2));


always_comb begin
	if (buffer_sel) begin  // if buffer_sel = 1, then read from 2, write to 1;// if buffer_sel = 0, then read from 1, write to 2;
		address2 = read_row + read_col * size_x;
		we2 = 1'b0;
		read_data = data2;
		
		address1 = write_row + write_col * size_x;
		we1 = write_en;
	end else begin
		address1 = read_row + read_col * size_x;
		we1 = 1'b0;
		read_data = data1;
		
		address2 = write_row + write_col * size_x;
		we2 = write_en;
	end
end

endmodule
