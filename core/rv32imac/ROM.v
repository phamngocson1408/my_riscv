`timescale 1ns / 10ps
`include "mem_def.v"
module rom 
(
	// Input
	 input 		rst_i
	,input 		clk_i
	,input [19:0] 	rom_fet_addr_i
	,input		rom_wr_en_i
	,input [19:0] 	rom_wr_addr_i
	,input [31:0] 	rom_wr_data_i
	,input		rom_rd_en_i
	,input [19:0] 	rom_rd_addr_i

	// Output
	,output [31:0] 	rom_fet_data_o
	,output [31:0] 	rom_rd_data_o
);

// ROM
reg [7:0] rom[0:`ROM_LEN];

initial begin
	$readmemh("/home/pnson/tmp/RISCV/test/riscv-tests-modified/isa/rv32ui-p-add.hex", rom);
//	$readmemh("/home/pnson/tmp/RISCV/my_riscv/tb/test_vector/c_code/simple/a.hex", rom);
end

wire [19:0] rom_wr_addr_1 = rom_wr_addr_i + 1;
wire [19:0] rom_wr_addr_2 = rom_wr_addr_i + 2;
wire [19:0] rom_wr_addr_3 = rom_wr_addr_i + 3;

wire [19:0] rom_rd_addr_1 = rom_rd_addr_i + 1;
wire [19:0] rom_rd_addr_2 = rom_rd_addr_i + 2;
wire [19:0] rom_rd_addr_3 = rom_rd_addr_i + 3;

always @(posedge clk_i) begin
	if (rom_wr_en_i)
		rom[rom_wr_addr_i] <= #1 rom_wr_data_i[7:0];
		rom[rom_wr_addr_1] <= #1 rom_wr_data_i[15:8];
		rom[rom_wr_addr_2] <= #1 rom_wr_data_i[23:16];
		rom[rom_wr_addr_3] <= #1 rom_wr_data_i[31:24];
end

// Read instruction
wire [19:0] rom_fet_addr_1 = rom_fet_addr_i + 1;
wire [19:0] rom_fet_addr_2 = rom_fet_addr_i + 2;
wire [19:0] rom_fet_addr_3 = rom_fet_addr_i + 3;

//wire [31:0] rom_fet_data_o = (!rst_i) ? {rom[rom_fet_addr_3], rom[rom_fet_addr_2], rom[rom_fet_addr_1], rom[rom_fet_addr_i]} : 32'h00;
wire [31:0] rom_fet_data_o = (rst_i) ? 32'h00 : (rom_fet_addr_i == 0) ? 32'h06c0006f : {rom[rom_fet_addr_3], rom[rom_fet_addr_2], rom[rom_fet_addr_1], rom[rom_fet_addr_i]};

wire [31:0] rom_rd_data_o = (!rst_i && rom_rd_en_i) ? {rom[rom_rd_addr_3], rom[rom_rd_addr_2], rom[rom_rd_addr_1], rom[rom_rd_addr_i]} : 32'h00;

endmodule
