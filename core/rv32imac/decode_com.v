`timescale 1ns / 10ps
`include "inst_def.v"
module decode_com
(
	// Input
	 input		rst_i
	,input		clk_i
	,input [15:0] 	com_inst_i

	 // Output
	,output [7:0] 	com_inst_o
	,output [4:0] 	com_reg_dr_o
	,output [4:0]	com_reg_sr1_o
	,output [4:0]	com_reg_sr2_o
	,output [31:0] 	com_imm_data_o
	,output  	com_mem_ld_inst_o
	,output  	com_mem_st_inst_o
	,output  	com_int_reg_imm_inst_o
	,output  	com_int_reg_reg_inst_o
	,output  	com_jal_inst_o
	,output  	com_con_br_inst_o
	,output  	com_inst_val_o
);

wire [1:0]	opcode_w = com_inst_i[1:0];
wire [3:0]	funct4_w = com_inst_i[15:12];
wire [2:0]	funct3_w = com_inst_i[15:13];
wire [1:0]	funct2_w = com_inst_i[11:10];

wire clwsp_inst_w = (opcode_w == 2'b10) & (funct3_w == 3'b010);
wire cswsp_inst_w = (opcode_w == 2'b10) & (funct3_w == 3'b110);
wire clw_inst_w = (opcode_w == 2'b00) & (funct3_w == 3'b010);
wire csw_inst_w = (opcode_w == 2'b00) & (funct3_w == 3'b110);

 wire [31:0] caddi_nzimm = {{26{com_inst_i[12]}}, com_inst_i[12], com_inst_i[6:2]};
wire caddi_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b000) & (caddi_nzimm != 32'd0);
 wire [31:0] caddi16sp_nzimm = {{22{com_inst_i[12]}}, com_inst_i[12], com_inst_i[4:3], com_inst_i[5], com_inst_i[2], com_inst_i[6], 4'h0};
wire caddi16sp_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b011) & (com_inst_i[11:7] == 2) & (caddi16sp_nzimm != 32'd0);
 wire [9:0] caddi4spn_nzuimm = {com_inst_i[10:7], com_inst_i[12:11], com_inst_i[5], com_inst_i[6], 2'h0};
wire caddi4spn_inst_w = (opcode_w == 2'b00) & (funct3_w == 3'b000) & (caddi4spn_nzuimm != 10'd0);
 wire [4:0] cslli_shamt = com_inst_i[6:2];
wire cslli_inst_w = (opcode_w == 2'b10) & (funct3_w == 3'b000);
 wire [4:0] csrli_shamt = com_inst_i[6:2];
wire csrli_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b100) & (funct2_w == 2'b00);
 wire [4:0] csrai_shamt = com_inst_i[6:2];
wire csrai_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b100) & (funct2_w == 2'b01);
 wire [31:0] candi_shamt = {{26{com_inst_i[12]}}, com_inst_i[12], com_inst_i[6:2]};
wire candi_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b100) & (funct2_w == 2'b10);

wire cmv_inst_w = (opcode_w == 2'b10) & (funct3_w == 3'b100) & (com_inst_i[12] == 0) & (com_inst_i[6:2] != 0);
wire cadd_inst_w = (opcode_w == 2'b10) & (funct3_w == 3'b100) & (com_inst_i[12] == 1) & (com_inst_i[6:2] != 0);
wire cand_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b100) & (com_inst_i[12] == 0) & (com_inst_i[11:10] == 2'b11 & com_inst_i[6:5] == 2'b11);
wire cor_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b100) & (com_inst_i[12] == 0) & (com_inst_i[11:10] == 2'b11 & com_inst_i[6:5] == 2'b10);
wire cxor_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b100) & (com_inst_i[12] == 0) & (com_inst_i[11:10] == 2'b11 & com_inst_i[6:5] == 2'b01);
wire csub_inst_w = (opcode_w == 2'b01) & (funct3_w == 3'b100) & (com_inst_i[12] == 0) & (com_inst_i[11:10] == 2'b11 & com_inst_i[6:5] == 2'b00);

wire cnop_inst_w = com_inst_i == 16'h01;

wire cli_inst_w =  (opcode_w == 2'b01) & (funct3_w == 3'b010) & (com_inst_i[11:7] != 0);
 wire [31:0] clui_nzimm = {{14{com_inst_i[12]}}, com_inst_i[12], com_inst_i[6:2], 12'h00};
wire clui_inst_w =  (opcode_w == 2'b01) & (funct3_w == 3'b011) & (com_inst_i[11:7] != 2) & (com_inst_i[11:7] != 0);

wire cj_inst_w =  (opcode_w == 2'b01) & (funct3_w == 3'b101);
wire cjal_inst_w =  (opcode_w == 2'b01) & (funct3_w == 3'b001);
wire cjr_inst_w =  (opcode_w == 2'b10) & (funct3_w == 3'b100) & (com_inst_i[12] == 0) & (com_inst_i[6:2] == 5'd0);
wire cjalr_inst_w =  (opcode_w == 2'b10) & (funct3_w == 3'b100) & (com_inst_i[12] == 1) & (com_inst_i[6:2] == 5'd0);
wire cbeqz_inst_w =  (opcode_w == 2'b01) & (funct3_w == 3'b110);
wire cbnez_inst_w =  (opcode_w == 2'b01) & (funct3_w == 3'b111);

wire com_int_reg_imm_inst_w = (caddi_inst_w
				| caddi16sp_inst_w
				| caddi4spn_inst_w
				| cslli_inst_w
				| csrli_inst_w
				| csrai_inst_w
				| candi_inst_w
				);

wire com_int_reg_reg_inst_w = (cmv_inst_w
				| cadd_inst_w
				| cand_inst_w
				| cor_inst_w
				| cxor_inst_w
				| csub_inst_w
				);

wire com_mem_ld_inst_w = (clwsp_inst_w
			| clw_inst_w
			);

wire com_mem_st_inst_w = (cswsp_inst_w
			| csw_inst_w
			);

wire com_jal_inst_w = (cj_inst_w
			| cjal_inst_w
			);

wire com_jalr_inst_w = (cjr_inst_w
			| cjalr_inst_w
			);

wire com_con_br_inst_w = (cbeqz_inst_w
			| cbnez_inst_w
			);

wire com_inst_val_o = ( com_int_reg_imm_inst_w
		| com_int_reg_reg_inst_w
		| cli_inst_w
		| clui_inst_w
		| com_mem_ld_inst_w
		| com_mem_st_inst_w
		| com_jal_inst_w
		| com_jalr_inst_w
		| com_con_br_inst_w
		| cnop_inst_w
		);

wire [4:0] reg_sr1b_w = (com_inst_i[9:7] == 3'b000) ? 5'd8
			: (com_inst_i[9:7] == 3'b001) ? 5'd9
			: (com_inst_i[9:7] == 3'b010) ? 5'd10
			: (com_inst_i[9:7] == 3'b011) ? 5'd11
			: (com_inst_i[9:7] == 3'b100) ? 5'd12
			: (com_inst_i[9:7] == 3'b101) ? 5'd13
			: (com_inst_i[9:7] == 3'b110) ? 5'd14
			: (com_inst_i[9:7] == 3'b111) ? 5'd15
			: 0;

wire [4:0] reg_sr2b_w = (com_inst_i[4:2] == 3'b000) ? 5'd8
			: (com_inst_i[4:2] == 3'b001) ? 5'd9
			: (com_inst_i[4:2] == 3'b010) ? 5'd10
			: (com_inst_i[4:2] == 3'b011) ? 5'd11
			: (com_inst_i[4:2] == 3'b100) ? 5'd12
			: (com_inst_i[4:2] == 3'b101) ? 5'd13
			: (com_inst_i[4:2] == 3'b110) ? 5'd14
			: (com_inst_i[4:2] == 3'b111) ? 5'd15
			: 0;

wire [4:0] reg_drb_w = (com_inst_i[4:2] == 3'b000) ? 5'd8
			: (com_inst_i[4:2] == 3'b001) ? 5'd9
			: (com_inst_i[4:2] == 3'b010) ? 5'd10
			: (com_inst_i[4:2] == 3'b011) ? 5'd11
			: (com_inst_i[4:2] == 3'b100) ? 5'd12
			: (com_inst_i[4:2] == 3'b101) ? 5'd13
			: (com_inst_i[4:2] == 3'b110) ? 5'd14
			: (com_inst_i[4:2] == 3'b111) ? 5'd15
			: 0;

wire reg_sr1_val_w = (caddi_inst_w
			| caddi16sp_inst_w
			| caddi4spn_inst_w
			| cslli_inst_w
			| csrli_inst_w
			| csrai_inst_w
			| candi_inst_w
			| cadd_inst_w
			| cand_inst_w
			| cor_inst_w
			| cxor_inst_w
			| csub_inst_w
			| com_mem_ld_inst_w
			| com_mem_st_inst_w
			| cjr_inst_w
			| cjalr_inst_w
			| com_con_br_inst_w
			);

wire reg_sr2_val_w = (	cmv_inst_w
			| cadd_inst_w
			| cand_inst_w
			| cor_inst_w
			| cxor_inst_w
			| csub_inst_w
			| com_mem_st_inst_w
			| com_con_br_inst_w
			);

wire reg_dr_val_w = (caddi_inst_w
			| caddi16sp_inst_w
			| caddi4spn_inst_w
			| cslli_inst_w
			| csrli_inst_w
			| csrai_inst_w
			| candi_inst_w
			| cmv_inst_w
			| cadd_inst_w
			| cand_inst_w
			| cor_inst_w
			| cxor_inst_w
			| csub_inst_w
			| cli_inst_w
			| clui_inst_w
			| com_mem_ld_inst_w
			| cjal_inst_w
			| cjalr_inst_w
			);

wire [4:0] reg_sr1_w = (caddi_inst_w) ? com_inst_i[11:7]
			: (caddi16sp_inst_w) ? com_inst_i[11:7]
			: (caddi4spn_inst_w) ? 2
			: (cslli_inst_w) ? com_inst_i[11:7]
			: (cadd_inst_w) ? com_inst_i[11:7]
			: (clwsp_inst_w) ? 2
			: (cswsp_inst_w) ? 2
			: (cjr_inst_w) ? com_inst_i[11:7]
			: (cjalr_inst_w) ? com_inst_i[11:7]
			: reg_sr1b_w;

wire [4:0] reg_sr2_w =  (cmv_inst_w) ? com_inst_i[6:2]
			: (cadd_inst_w) ? com_inst_i[6:2]
			: (cswsp_inst_w) ? com_inst_i[6:2]
			: (com_con_br_inst_w) ? 0
			: reg_sr2b_w;

wire [4:0] reg_dr_w = (caddi_inst_w) ? com_inst_i[11:7]
			: (caddi16sp_inst_w) ? com_inst_i[11:7]
			: (cslli_inst_w) ? com_inst_i[11:7]
			: (csrli_inst_w) ? reg_sr1b_w
			: (csrai_inst_w) ? reg_sr1b_w
			: (candi_inst_w) ? reg_sr1b_w
			: (cmv_inst_w) ? com_inst_i[11:7]
			: (cadd_inst_w) ? reg_sr1_w
			: (cand_inst_w) ? reg_sr1_w
			: (cor_inst_w) ? reg_sr1_w
			: (cxor_inst_w) ? reg_sr1_w
			: (csub_inst_w) ? reg_sr1_w
			: (cli_inst_w) ? com_inst_i[11:7]
			: (clui_inst_w) ? com_inst_i[11:7]
			: (clwsp_inst_w) ? com_inst_i[11:7]
			: (cjal_inst_w) ? 1
			: (cjalr_inst_w) ? 1
			: reg_drb_w;

reg [4:0]	com_reg_dr_o;
reg [4:0]	com_reg_sr1_o;
reg [4:0]	com_reg_sr2_o;

always @(posedge clk_i) begin
	if (rst_i) begin
		com_reg_dr_o <= #1 5'h00;
		com_reg_sr1_o <= #1 5'h00;
		com_reg_sr2_o <= #1 5'h00;
	end
	else begin
		if (reg_dr_val_w) com_reg_dr_o <= #1 reg_dr_w;
		else com_reg_dr_o <= #1 5'h0;	
		if (reg_sr1_val_w) com_reg_sr1_o <= #1 reg_sr1_w;
		else com_reg_sr1_o <= #1 5'h0;
		if (reg_sr2_val_w) com_reg_sr2_o <= #1 reg_sr2_w;
		else com_reg_sr2_o <= #1 5'h0;
	end
end

reg com_mem_ld_inst_o;
reg com_mem_st_inst_o;
reg com_int_reg_imm_inst_o;
reg com_int_reg_reg_inst_o;
reg com_cnop_inst_o;
reg com_clui_inst_o;
reg com_jal_inst_o;
reg com_con_br_inst_o;

always @(posedge clk_i) begin
	if (rst_i) begin
		com_mem_ld_inst_o <= #1 0;
		com_mem_st_inst_o <= #1 0;
		com_int_reg_imm_inst_o <= #1 0;
		com_int_reg_reg_inst_o <= #1 0;
		com_cnop_inst_o <= #1 0;
		com_clui_inst_o <= #1 0;
		com_jal_inst_o <= #1 0;
		com_con_br_inst_o <= #1 0;
	end
	else begin
		com_mem_ld_inst_o <= #1 com_mem_ld_inst_w;
		com_mem_st_inst_o <= #1 com_mem_st_inst_w;
		com_int_reg_imm_inst_o <= #1 com_int_reg_imm_inst_w;
		com_int_reg_reg_inst_o <= #1 com_int_reg_reg_inst_w;
		com_cnop_inst_o <= #1 cnop_inst_w;
		com_clui_inst_o <= #1 clui_inst_w;
		com_jal_inst_o <= #1 com_jal_inst_w;
		com_con_br_inst_o <= #1 com_con_br_inst_w;
	end
end

reg [7:0] 	com_inst_o;
reg [31:0]	com_imm_data_o;
//For debug
reg [63:0]	inst_name;

always @(posedge clk_i) begin
	if (rst_i) begin
		com_inst_o <= #1 8'h0;
		com_imm_data_o <= #1 32'h0;
		inst_name <= #1 "000";
	end
	else if (clwsp_inst_w) begin
		com_inst_o <= #1 `CLWSP;	// CLWSP
		com_imm_data_o <= #1 {24'h00, com_inst_i[3:2], com_inst_i[12], com_inst_i[6:4], 2'h0};
		inst_name <= #1 "CLWSP";
	end
	else if (cswsp_inst_w) begin
		com_inst_o <= #1 `CSWSP;	// CSWSP
		com_imm_data_o <= #1 {24'h00, com_inst_i[8:7], com_inst_i[12:9], 2'h0};
		inst_name <= #1 "CSWSP";
	end
	else if (caddi_inst_w) begin
		com_inst_o <= #1 `CADDI;	// CADDI
		com_imm_data_o <= #1 caddi_nzimm;
		inst_name <= #1 "CADDI";
	end
	else if (caddi16sp_inst_w) begin
		com_inst_o <= #1 `CADDI16SP;	// CADDI16SP
		com_imm_data_o <= #1 caddi16sp_nzimm;
		inst_name <= #1 "CADDI16SP";
	end
	else if (caddi4spn_inst_w) begin
		com_inst_o <= #1 `CADDI4SPN;	// CADDI4SPN
		com_imm_data_o <= #1 {22'h00, caddi4spn_nzuimm};
		inst_name <= #1 "CADDI4SPN";
	end
	else if (cslli_inst_w) begin
		com_inst_o <= #1 `CSLLI;	// CSLLI
		com_imm_data_o <= #1 {27'h00, cslli_shamt};
		inst_name <= #1 "CSLLI";
	end
	else if (csrli_inst_w) begin
		com_inst_o <= #1 `CSRLI;	// CSRLI
		com_imm_data_o <= #1 {27'h00, csrli_shamt};
		inst_name <= #1 "CSRLI";
	end
	else if (csrai_inst_w) begin
		com_inst_o <= #1 `CSRAI;	// CSRAI
		com_imm_data_o <= #1 {27'h00, csrai_shamt};
		inst_name <= #1 "CSRAI";
	end
	else if (candi_inst_w) begin
		com_inst_o <= #1 `CANDI;	// CANDI
		com_imm_data_o <= #1 candi_shamt;
		inst_name <= #1 "CANDI";
	end
	else if (cmv_inst_w) begin
		com_inst_o <= #1 `CMV;		// CMV
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CMV";
	end
	else if (cadd_inst_w) begin
		com_inst_o <= #1 `CADD;		// CADD
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CADD";
	end
	else if (cand_inst_w) begin
		com_inst_o <= #1 `CAND;		// CAND
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CAND";
	end
	else if (cor_inst_w) begin
		com_inst_o <= #1 `COR;		// CAND
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "COR";
	end
	else if (cxor_inst_w) begin
		com_inst_o <= #1 `CXOR;		// CXOR
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CXOR";
	end
	else if (csub_inst_w) begin
		com_inst_o <= #1 `CSUB;		// CSUB
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CSUB";
	end
	else if (cnop_inst_w) begin
		com_inst_o <= #1 `CNOP;		// CNOP
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CNOP";
	end
	else if (cli_inst_w) begin
		com_inst_o <= #1 `CLI;		// CLI
		com_imm_data_o <= #1 {{26{com_inst_i[12]}}, com_inst_i[12], com_inst_i[6:2]};
		inst_name <= #1 "CLI";
	end
	else if (clui_inst_w) begin
		com_inst_o <= #1 `CLUI;		// CLUI
		com_imm_data_o <= #1 clui_nzimm;
		inst_name <= #1 "CLUI";
	end
	else if (clw_inst_w) begin
		com_inst_o <= #1 `CLW;		// CLW
		com_imm_data_o <= #1 {25'h00, com_inst_i[5], com_inst_i[12:10], com_inst_i[6], 2'd0};
		inst_name <= #1 "CLW";
	end
	else if (csw_inst_w) begin
		com_inst_o <= #1 `CSW;		// CSW
		com_imm_data_o <= #1 {25'h00, com_inst_i[5], com_inst_i[12:10], com_inst_i[6], 2'd0};
		inst_name <= #1 "CSW";
	end
	else if (cj_inst_w) begin
		com_inst_o <= #1 `CJ;		// CJ
		com_imm_data_o <= #1 {{20{com_inst_i[12]}}, com_inst_i[12], com_inst_i[8], com_inst_i[10:9], com_inst_i[6], com_inst_i[7], com_inst_i[2], com_inst_i[11], com_inst_i[5:3], 1'b0};
		inst_name <= #1 "CJ";
	end
	else if (cjal_inst_w) begin
		com_inst_o <= #1 `CJAL;		// CJAl
		com_imm_data_o <= #1 {{20{com_inst_i[12]}}, com_inst_i[12], com_inst_i[8], com_inst_i[10:9], com_inst_i[6], com_inst_i[7], com_inst_i[2], com_inst_i[11], com_inst_i[5:3], 1'b0};
		inst_name <= #1 "CJAL";
	end
	else if (cjr_inst_w) begin
		com_inst_o <= #1 `CJR;		// CJR
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CJR";
	end
	else if (cjalr_inst_w) begin
		com_inst_o <= #1 `CJALR;		// CJALR
		com_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CJALR";
	end
	else if (cbeqz_inst_w) begin
		com_inst_o <= #1 `CBEQZ;		// CBEQZ
		com_imm_data_o <= #1 {{23{com_inst_i[12]}}, com_inst_i[12], com_inst_i[6:5], com_inst_i[2], com_inst_i[11:10], com_inst_i[4:3], 1'b0};
		inst_name <= #1 "CBEQZ";
	end
	else if (cbnez_inst_w) begin
		com_inst_o <= #1 `CBNEZ;		// CBNEZ
		com_imm_data_o <= #1 {{23{com_inst_i[12]}}, com_inst_i[12], com_inst_i[6:5], com_inst_i[2], com_inst_i[11:10], com_inst_i[4:3], 1'b0};
		inst_name <= #1 "CBNEZ";
	end
	else begin
		com_inst_o <= #1 8'h0;
		com_imm_data_o <= #1 32'h0;
		inst_name <= #1 "000";
	end
end

endmodule
