`timescale 1ns / 10ps
module wrbk
(
	// Input
	 input 		rst_i
	,input 		clk_i
	,input 		state_wrbk_i
	,input 		wrbk_reg_wr_en_i
	,input [4:0] 	wrbk_reg_addr_i
	,input [31:0] 	wrbk_reg_data_i
	,input 		wrbk_mem_wr_en_i
	,input [31:0] 	wrbk_mem_addr_i
	,input [31:0] 	wrbk_mem_data_i
	,input 		wrbk_csr_wr_en_i
	,input [31:0] 	wrbk_csr_data_i
	,input [11:0] 	wrbk_csr_addr_i

	// Output
	,output 	wrbk_reg_wr_en_o
	,output [4:0] 	wrbk_reg_addr_o
	,output [31:0] 	wrbk_reg_data_o
	,output 	wrbk_mem_wr_en_o
	,output [31:0] 	wrbk_mem_addr_o
	,output [31:0] 	wrbk_mem_data_o
	,output 	wrbk_csr_wr_en_o
	,output [31:0] 	wrbk_csr_data_o
	,output [31:0] 	wrbk_csr_addr_o
);

wire wrbk_reg_wr_en_o = wrbk_reg_wr_en_i && state_wrbk_i;
wire [4:0] wrbk_reg_addr_o = wrbk_reg_addr_i;
wire [31:0] wrbk_reg_data_o = wrbk_reg_data_i;

wire wrbk_mem_wr_en_o = wrbk_mem_wr_en_i && state_wrbk_i;
wire [31:0] wrbk_mem_addr_o = wrbk_mem_addr_i;
wire [31:0] wrbk_mem_data_o = wrbk_mem_data_i;

wire wrbk_csr_wr_en_o = wrbk_csr_wr_en_i && state_wrbk_i;
wire [31:0] wrbk_csr_data_o = wrbk_csr_data_i;
wire [11:0] wrbk_csr_addr_o = wrbk_csr_addr_i;

endmodule
