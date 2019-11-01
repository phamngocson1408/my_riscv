`timescale 1ns / 10ps
module core
(
	// Input
	 input rst_i
	,input clk_i

	// Output

);

wire [31:0] 	mem_data_ow;
wire 	 	mem_inst_addr_mis_ow;
wire [31:0] 	reg1_data_ow;
wire [31:0] 	reg2_data_ow;
wire [31:0] 	pc_in_w;
wire [31:0] 	fet_pc_ow;
wire		fet_ready_ow;

wire [7:0] 	dec_inst_ow;
wire [4:0] 	dec_reg_dr_ow;
wire [4:0]	dec_reg_sr1_ow;
wire [4:0]	dec_reg_sr2_ow;
wire [31:0] 	dec_imm_data_ow;
wire  		dec_com_inst_ow;
wire  		dec_ready_ow;

wire 		exe_reg_wr_en_ow;
wire [31:0] 	exe_reg_data_ow;
wire [4:0] 	exe_reg_addr_ow;
wire 		exe_mem_wr_en_ow;
wire [31:0] 	exe_mem_data_ow;
wire [31:0] 	exe_mem_addr_ow;
wire 		exe_mem_ld_en_ow;
wire [31:0] 	mem_ld_data_ow;
wire [31:0] 	exe_mem_ld_addr_ow;
wire		exe_pc_update_ow;
wire [31:0]	exe_pc_ow;
wire 		exe_csr_wr_en_ow;
wire [31:0]	exe_csr_data_ow;
wire [11:0]	exe_csr_addr_ow;
wire 		exe_ready_ow;

wire 		wrbk_reg_wr_en_ow;
wire [31:0] 	wrbk_reg_data_ow;
wire [4:0] 	wrbk_reg_addr_ow;
wire 		wrbk_mem_wr_en_ow;
wire [31:0] 	wrbk_mem_data_ow;
wire [31:0] 	wrbk_mem_addr_ow;
wire [11:0]	dec_csr_addr_ow;
wire 		wrbk_csr_wr_en_ow;
wire [31:0]	wrbk_csr_data_ow;
wire [11:0]	wrbk_csr_addr_ow;
wire		wrbk_ready_ow;

wire [31:0]	csr_data_ow;
wire 		csr_exception_ow;


//-------------------------------------------------------------
// State
reg [1:0] state; // 0-fetch, 1-decode, 2-execute, 3-wrbk

wire state_0 = state == 2'h0;	
wire state_1 = state == 2'h1;	
wire state_2 = state == 2'h2;	
wire state_3 = state == 2'h3;	

always @(posedge clk_i) begin
	if (rst_i)
		state <= #1 2'h0;
	else if (csr_exception_ow)
		state <= #1 2'h1;
	else if (state_0 && fet_ready_ow)
		state <= #1 2'h1;
	else if (state_1 && dec_ready_ow)
		state <= #1 2'h2;
	else if (state_2 && exe_ready_ow)
		state <= #1 2'h3;	
	else if (state_3 && wrbk_ready_ow)
		state <= #1 2'h0;
end

//-------------------------------------------------------------
// Initiate memory
//-------------------------------------------------------------

//wire [31:0] rom_addr_iw =  (csr_exception_ow) ? csr_data_ow
//			: fet_pc_ow;

memory u_memory
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.rom_addr_i (fet_pc_ow)
	,.ram_wr_en_i (wrbk_mem_wr_en_ow)
	,.ram_wr_addr_i (wrbk_mem_addr_ow)
	,.ram_wr_data_i (wrbk_mem_data_ow)
	,.ram_rd_en_i (exe_mem_ld_en_ow)
	,.ram_rd_addr_i (exe_mem_ld_addr_ow)

	// Output
	,.rom_data_o (mem_data_ow)
	,.ram_rd_data_o (mem_ld_data_ow)
	,.mem_inst_addr_mis_o (mem_inst_addr_mis_ow)
);

//-------------------------------------------------------------
// Initiate register file
//-------------------------------------------------------------

reg_file u_reg_file
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.reg_wr_en_i (wrbk_reg_wr_en_ow)
	,.reg_dr_i (wrbk_reg_addr_ow)
	,.reg1_sr_i (dec_reg_sr1_ow)
	,.reg2_sr_i (dec_reg_sr2_ow)
	,.reg_data_i (wrbk_reg_data_ow)

	// Output
	,.reg1_data_o (reg1_data_ow)
	,.reg2_data_o (reg2_data_ow)
);

//-------------------------------------------------------------
// Initiate csr_ctrl
//-------------------------------------------------------------

csr_ctrl u_csr_ctrl
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.en_i (state_2)
	,.csr_addr_i (dec_csr_addr_ow)
	,.csr_wr_en_i (wrbk_csr_wr_en_ow)
	,.csr_data_i (wrbk_csr_data_ow)
	,.csr_inst_i (dec_inst_ow)
	,.csr_inst_addr_mis_i (mem_inst_addr_mis_ow)

	// Output
	,.csr_data_o (csr_data_ow)
	,.csr_exception_o (csr_exception_ow)
);

//-------------------------------------------------------------
// Initiate fetch
//-------------------------------------------------------------

fetch u_fetch
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.en_i (state_0)
	,.fet_pc_update_i (exe_pc_update_ow)
	,.fet_pc_i (exe_pc_ow)
	,.com_inst_i (dec_com_inst_ow)
	,.csr_exception_i (csr_exception_ow)
	,.csr_pc_i (csr_data_ow)
	
	// Output
	,.fet_pc_o (fet_pc_ow)
	,.fet_ready_o (fet_ready_ow)
);

//-------------------------------------------------------------
// Initiate decode
//-------------------------------------------------------------

//wire [31:0] dec_inst_iw = (state_1) ? mem_data_ow : 32'h00;

decode u_decode
(
	// Input
	 .rst_i(rst_i)
	,.clk_i(clk_i)
	,.dec_inst_i(mem_data_ow)

	// Output
	,.dec_inst_o (dec_inst_ow)
	,.dec_reg_dr_o (dec_reg_dr_ow)
	,.dec_reg_sr1_o (dec_reg_sr1_ow)
	,.dec_reg_sr2_o (dec_reg_sr2_ow)
	,.dec_imm_data_o (dec_imm_data_ow)
	,.dec_csr_addr_o (dec_csr_addr_ow)

	,.dec_com_inst_o (dec_com_inst_ow)

	,.dec_ready_o (dec_ready_ow)
);

//-------------------------------------------------------------
// Initiate execute
//-------------------------------------------------------------

execute u_execute
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.en_i (state_2)
	,.exe_inst_i (dec_inst_ow)
	,.exe_reg_dr_i (dec_reg_dr_ow)
	,.exe_reg_sr1_i (dec_reg_sr1_ow)
	,.exe_imm_data_i (dec_imm_data_ow)
	,.exe_csr_data_i (csr_data_ow)
	,.exe_csr_addr_i (dec_csr_addr_ow)
	,.exe_mem_data_i (mem_data_ow)
	,.exe_reg1_data_i (reg1_data_ow)
	,.exe_reg2_data_i (reg2_data_ow)
	,.exe_pc_i (fet_pc_ow)
	,.exe_exception_i (csr_exception_ow)

	// Output
	,.exe_mem_wr_en_o (exe_mem_wr_en_ow)
	,.exe_mem_addr_o (exe_mem_addr_ow)
	,.exe_mem_data_o (exe_mem_data_ow)

	,.exe_mem_ld_en_o (exe_mem_ld_en_ow)
	,.exe_mem_ld_addr_o (exe_mem_ld_addr_ow)
	,.exe_mem_ld_data_i (mem_ld_data_ow)
	
	,.exe_reg_wr_o (exe_reg_wr_en_ow)
	,.exe_reg_data_o (exe_reg_data_ow)
	,.exe_reg_addr_o (exe_reg_addr_ow)
	
	,.exe_pc_update_o (exe_pc_update_ow)
	,.exe_pc_o (exe_pc_ow)

	,.exe_csr_wr_en_o (exe_csr_wr_en_ow)
	,.exe_csr_data_o (exe_csr_data_ow)
	,.exe_csr_addr_o (exe_csr_addr_ow)

	,.exe_ready_o (exe_ready_ow)
);

//-------------------------------------------------------------
// Initiate wrbk
//-------------------------------------------------------------

wrbk u_wrbk
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.state_wrbk_i (state_3)
	,.wrbk_reg_wr_en_i (exe_reg_wr_en_ow)
	,.wrbk_reg_addr_i (exe_reg_addr_ow)
	,.wrbk_reg_data_i (exe_reg_data_ow)
	,.wrbk_mem_wr_en_i (exe_mem_wr_en_ow)
	,.wrbk_mem_addr_i (exe_mem_addr_ow)
	,.wrbk_mem_data_i (exe_mem_data_ow)
	,.wrbk_csr_wr_en_i (exe_csr_wr_en_ow)
	,.wrbk_csr_data_i (exe_csr_data_ow)
	,.wrbk_csr_addr_i (exe_csr_addr_ow)

	// Output
	,.wrbk_reg_wr_en_o (wrbk_reg_wr_en_ow)
	,.wrbk_reg_addr_o (wrbk_reg_addr_ow)
	,.wrbk_reg_data_o (wrbk_reg_data_ow)
	,.wrbk_mem_wr_en_o (wrbk_mem_wr_en_ow)
	,.wrbk_mem_addr_o (wrbk_mem_addr_ow)
	,.wrbk_mem_data_o (wrbk_mem_data_ow)
	,.wrbk_csr_wr_en_o (wrbk_csr_wr_en_ow)
	,.wrbk_csr_data_o (wrbk_csr_data_ow)
	,.wrbk_csr_addr_o (wrbk_csr_addr_ow)
	,.wrbk_ready_o (wrbk_ready_ow)
);


endmodule
