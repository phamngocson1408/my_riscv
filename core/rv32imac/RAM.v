`timescale 1ns / 10ps
`include "mem_def.v"
module ram 
(
	// Input
	 input 		rst_i
	,input 		clk_i
	,input		ram_wr_en_i
	,input [19:0] 	ram_wr_addr_i
	,input [31:0] 	ram_wr_data_i
	,input		ram_rd_en_i
	,input [19:0] 	ram_rd_addr_i

	// Output
	,output [31:0] 	ram_rd_data_o
);

// RAM
reg [31:0] ram[0:`RAM_LEN];

integer i;

initial begin
		for ( i = 0 ; i < `RAM_LEN ; i = i+1 )
		ram[i] = 32'h00;
end

always @(posedge clk_i) begin
	if (ram_wr_en_i)
		ram[ram_wr_addr_i] <= #1 ram_wr_data_i[31:0];
end

// Read instruction
wire [31:0] ram_rd_data_o = (!rst_i && ram_rd_en_i) ? ram[ram_rd_addr_i] : 32'h00;

endmodule
