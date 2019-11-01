`timescale 1ns / 10ps
module memory 
(
	// Input
	 input 		rst_i
	,input 		clk_i
	,input [31:0] 	rom_addr_i
	,input 		ram_wr_en_i
	,input [31:0] 	ram_wr_addr_i
	,input [31:0] 	ram_wr_data_i
	,input 		ram_rd_en_i
	,input [31:0] 	ram_rd_addr_i

	// Output
	,output [31:0] 	rom_data_o
	,output [31:0] 	ram_rd_data_o
	,output 	mem_inst_addr_mis_o
);

// ROM
parameter ROM_LEN = 'h10_0000;
parameter ROM_ORI = 'h0_0000;
// RAM
parameter RAM_LEN = 'h10_0000;
parameter RAM_ORI = 'h20_0000;

reg [7:0] ROM[0:ROM_ORI + ROM_LEN];
reg [7:0] RAM[0:RAM_LEN];

integer i;

initial begin
	$readmemh("/home/pnson/tmp/RISCV/rocket-tools/riscv-tests/isa/rv32ui-p-add.hex", ROM);
	$readmemh("/home/pnson/tmp/RISCV/rocket-tools/riscv-tests/isa/rv32ui-p-add.hex", RAM);
/*	for ( i = 0 ; i < RAM_LEN ; i = i+1 )
		RAM[i] = 32'h00;
		*/
end

wire [31:0] ram_wr_addr_w = {11'b0, ram_wr_addr_i[20:0]};
wire [31:0] ram_rd_addr_w = {11'b0, ram_rd_addr_i[20:0]};

wire [31:0] ram_wr_addr_1 = ram_wr_addr_w + 1;
wire [31:0] ram_wr_addr_2 = ram_wr_addr_w + 2;
wire [31:0] ram_wr_addr_3 = ram_wr_addr_w + 3;

wire [31:0] ram_rd_addr_1 = ram_rd_addr_w + 1;
wire [31:0] ram_rd_addr_2 = ram_rd_addr_w + 2;
wire [31:0] ram_rd_addr_3 = ram_rd_addr_w + 3;

always @(posedge clk_i) begin
	if (ram_wr_en_i)
		RAM[ram_wr_addr_w] <= #1 ram_wr_data_i[7:0];
		RAM[ram_wr_addr_1] <= #1 ram_wr_data_i[15:8];
		RAM[ram_wr_addr_2] <= #1 ram_wr_data_i[23:16];
		RAM[ram_wr_addr_3] <= #1 ram_wr_data_i[31:24];
end

// Read instruction
wire [31:0] rom_addr_1 = rom_addr_i + 1;
wire [31:0] rom_addr_2 = rom_addr_i + 2;
wire [31:0] rom_addr_3 = rom_addr_i + 3;

//wire [31:0] rom_data_o = (rom_addr_i == 32'h00) ? {32'h04c0006f} : (!rst_i) ? {ROM[rom_addr_3], ROM[rom_addr_2], ROM[rom_addr_1], ROM[rom_addr_i]} : 32'h00;
wire [31:0] rom_data_o = (!rst_i) ? {ROM[rom_addr_3], ROM[rom_addr_2], ROM[rom_addr_1], ROM[rom_addr_i]} : 32'h00;

wire [31:0] ram_rd_data_o = (!rst_i && ram_rd_en_i) ? {RAM[ram_rd_addr_3], RAM[ram_rd_addr_2], RAM[ram_rd_addr_1], RAM[ram_rd_addr_w]} : 32'h00;

wire mem_inst_addr_mis_o = (rom_addr_i >= ROM_LEN + ROM_ORI) | (rom_addr_i < ROM_ORI);

endmodule
