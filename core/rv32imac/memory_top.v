`timescale 1ns / 10ps
`include "mem_def.v"
module memory_top
(
	// Inpput
	 input 		rst_i
	,input 		clk_i
	,input [31:0]	fet_addr_i
	,input 		mem_wr_en_i
	,input [31:0]	mem_wr_addr_i
	,input [31:0]	mem_wr_data_i
	,input 		mem_rd_en_i
	,input [31:0]	mem_rd_addr_i

	// Output
	,output [31:0]	fet_data_o
	,output [31:0]	mem_rd_data_o

	,output		timer_wr_en_o
	,output [19:0]	timer_wr_addr_o	
	,output [31:0]	timer_wr_data_o	
	,output		timer_rd_en_o
	,output [19:0]	timer_rd_addr_o	
	,input [31:0]	timer_rd_data_i	
);

//-----------------------------------------------------------------------------
// Internal wires
//-----------------------------------------------------------------------------
wire [19:0]	rom_fet_addr_w;	
wire		rom_wr_en_w;
wire [19:0]	rom_wr_addr_w;	
wire [31:0]	rom_wr_data_w;	
wire		rom_rd_en_w;
wire [19:0]	rom_rd_addr_w;	
wire [31:0]	rom_fet_data_ow;	
wire [31:0]	rom_rd_data_ow;	

wire		ram_wr_en_w;
wire [19:0]	ram_wr_addr_w;	
wire [31:0]	ram_wr_data_w;	
wire		ram_rd_en_w;
wire [19:0]	ram_rd_addr_w;	
wire [31:0]	ram_rd_data_ow;	

wire		timer_wr_en_o;
wire [19:0]	timer_wr_addr_o;	
wire [31:0]	timer_wr_data_o;	
wire		timer_rd_en_o;
wire [19:0]	timer_rd_addr_o;	

assign rom_fet_addr_w = fet_addr_i[19:0];
assign fet_data_o = rom_fet_data_ow;
// To ROM
assign rom_wr_en_w = ({mem_wr_addr_i[31:20], 20'h00} == `ROM_ORI) && mem_wr_en_i;
assign rom_wr_addr_w = (rom_wr_en_w) ? mem_wr_addr_i[19:0] : 20'h00;
assign rom_wr_data_w = (rom_wr_en_w) ? mem_wr_data_i : 32'h00;
assign rom_rd_en_w = ({mem_rd_addr_i[31:20], 20'h00} == `ROM_ORI) && mem_rd_en_i;
assign rom_rd_addr_w = (rom_rd_en_w) ? mem_rd_addr_i[19:0] : 20'h00;

// To RAM
assign ram_wr_en_w = ({mem_wr_addr_i[31:20], 20'h00} == `RAM_ORI) && mem_wr_en_i;
assign ram_wr_addr_w = (ram_wr_en_w) ? mem_wr_addr_i[19:0] : 20'h00;
assign ram_wr_data_w = (ram_wr_en_w) ? mem_wr_data_i : 32'h00;
assign ram_rd_en_w = ({mem_rd_addr_i[31:20], 20'h00} == `RAM_ORI) && mem_rd_en_i;
assign ram_rd_addr_w = (ram_rd_en_w) ? mem_rd_addr_i[19:0] : 20'h00;

// To TIMER
assign timer_wr_en_o = ({mem_wr_addr_i[31:20], 20'h00} == `TIMER_ORI) && mem_wr_en_i;
assign timer_wr_addr_o = (timer_wr_en_o) ? mem_wr_addr_i[19:0] : 20'h00;
assign timer_wr_data_o = (timer_wr_en_o) ? mem_wr_data_i : 32'h00;
assign timer_rd_en_o = ({mem_rd_addr_i[31:20], 20'h00} == `TIMER_ORI) && mem_rd_en_i;
assign timer_rd_addr_o = (timer_rd_en_o) ? mem_rd_addr_i[19:0] : 20'h00;

wire [31:0] mem_rd_data_o = (rom_rd_en_w) ? rom_rd_data_ow
		: (ram_rd_en_w) ? ram_rd_data_ow
		: (timer_rd_en_o) ? timer_rd_data_i
		: 32'h0;

//-----------------------------------------------------------------------------
// ROM
//-----------------------------------------------------------------------------
rom u_rom
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.rom_fet_addr_i (rom_fet_addr_w)
	,.rom_wr_en_i (rom_wr_en_w)
	,.rom_wr_addr_i (rom_wr_addr_w)
	,.rom_wr_data_i (rom_wr_data_w)
	,.rom_rd_en_i (rom_rd_en_w)
	,.rom_rd_addr_i (rom_rd_addr_w)

	// Output
	,.rom_fet_data_o (rom_fet_data_ow)
	,.rom_rd_data_o (rom_rd_data_ow)
);

//-----------------------------------------------------------------------------
// RAM
//-----------------------------------------------------------------------------
ram u_ram
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.ram_wr_en_i (ram_wr_en_w)
	,.ram_wr_addr_i (ram_wr_addr_w)
	,.ram_wr_data_i (ram_wr_data_w)
	,.ram_rd_en_i (ram_rd_en_w)
	,.ram_rd_addr_i (ram_rd_addr_w)

	// Output
	,.ram_rd_data_o (ram_rd_data_ow)
);

endmodule
