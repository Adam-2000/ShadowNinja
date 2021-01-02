module RegFile_ghost(
		input  logic 				CLK, RESET,
		input  logic 				AVL_READ,					// Avalon-MM Read
		input  logic 				AVL_WRITE,					// Avalon-MM Write
		input  logic 				AVL_CS,						// Avalon-MM Chip Select
		input  logic [3:0] 		AVL_BYTE_EN,				// Avalon-MM Byte Enable
		input  logic [5:0] 		AVL_ADDR,					// Avalon-MM Address
		input  logic [31:0] 		AVL_WRITEDATA,				// Avalon-MM Write Data
		output logic [31:0] 		AVL_READDATA,				// Avalon-MM Read Data
		output logic [31:0] 		EXPORT_DATA					// Exported Conduit Signal to LEDs
);

RegFile RegFile_m0(.*);

endmodule
