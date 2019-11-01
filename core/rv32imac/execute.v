`timescale 1ns / 10ps
`include "inst_def.v"
module execute
(
	// Input
	 input 		rst_i
	,input 		clk_i
	,input 		en_i
	,input [7:0]	exe_inst_i
	,input [4:0] 	exe_reg_dr_i
	,input [4:0] 	exe_reg_sr1_i
	,input [31:0] 	exe_imm_data_i
	,input [31:0] 	exe_csr_data_i
	,input [11:0] 	exe_csr_addr_i
	,input [31:0]	exe_mem_data_i
	,input [31:0]	exe_reg1_data_i
	,input [31:0]	exe_reg2_data_i
	,input [31:0]	exe_pc_i
	,input 		exe_exception_i

	// Output
	,output		exe_mem_wr_en_o
	,output [31:0]	exe_mem_addr_o
	,output [31:0]	exe_mem_data_o

	,output		exe_mem_ld_en_o
	,output [31:0]	exe_mem_ld_addr_o
	,input [31:0]	exe_mem_ld_data_i	// Input

	,output		exe_reg_wr_o
	,output [31:0]	exe_reg_data_o
	,output [4:0]	exe_reg_addr_o

	,output 	exe_pc_update_o
	,output [31:0]	exe_pc_o

	,output 	exe_csr_wr_en_o
	,output [31:0]	exe_csr_data_o
	,output [11:0]	exe_csr_addr_o

	,output		exe_ready_o
);

// Internal wires to modules
wire [31:0] muldiv_data_ow;
wire 	muldiv_ready_ow;
wire 	muldiv_exception_ow;

wire auipc_inst_w = (exe_inst_i == `AUIPC);
wire jal_inst_w = (exe_inst_i == `JAL)
		| (exe_inst_i == `CJAL)
		| (exe_inst_i == `CJ)
		;
wire jalr_inst_w = (exe_inst_i == `JALR);
wire con_br_inst_w = (exe_inst_i == `BEQ)
		| (exe_inst_i == `CBEQZ)
		| (exe_inst_i == `CBNEZ)
		| (exe_inst_i == `BNE)
		| (exe_inst_i == `BLT)
		| (exe_inst_i == `BLTU)
		| (exe_inst_i == `BGE)
		| (exe_inst_i == `BGEU)
		;

// Update PC
wire [32:0] pc_update_w = 	(auipc_inst_w 
				| jal_inst_w
				| con_br_inst_w
				) ? (exe_pc_i + exe_imm_data_i) : 33'h0;

wire [32:0] jalr_reg_data_ow = (jalr_inst_w) ? exe_reg1_data_i + exe_imm_data_i : 33'h0;

// Mem load
wire exe_mem_ld_en_o = (exe_inst_i == `LB)
			| (exe_inst_i == `LH)
			| (exe_inst_i == `LW)
			| (exe_inst_i == `LBU)
			| (exe_inst_i == `LHU)
			| (exe_inst_i == `CLWSP)
			| (exe_inst_i == `CLW)
			;
wire [31:0] exe_mem_ld_addr_o = exe_reg1_data_i + exe_imm_data_i;

// Integer Register Immediate Instruction
wire int_reg_imm_inst_w = (exe_inst_i == `ADDI)
			| (exe_inst_i == `SLTI)
			| (exe_inst_i == `SLTIU)
			| (exe_inst_i == `XORI)
			| (exe_inst_i == `ORI)
			| (exe_inst_i == `ANDI)
			| (exe_inst_i == `SLLI)
			| (exe_inst_i == `SRLI)
			| (exe_inst_i == `SRAI)
			| (exe_inst_i == `CADDI)
			| (exe_inst_i == `CADDI16SP)
			| (exe_inst_i == `CADDI4SPN)
			| (exe_inst_i == `CSLLI)
			| (exe_inst_i == `CSRLI)
			| (exe_inst_i == `CSRAI)
			| (exe_inst_i == `CANDI)
			;

wire [31:0] reg2_data_in_w = (int_reg_imm_inst_w) ? {20'h00, exe_imm_data_i} : exe_reg2_data_i;

// ALU
wire [32:0] add_w = exe_reg1_data_i + reg2_data_in_w;
wire 	slt_w = exe_reg1_data_i < reg2_data_in_w;
wire [31:0] xor_w = exe_reg1_data_i ^ reg2_data_in_w;
wire [31:0] or_w = exe_reg1_data_i | reg2_data_in_w;
wire [31:0] and_w = exe_reg1_data_i & reg2_data_in_w;
wire [31:0] sll_w = exe_reg1_data_i << reg2_data_in_w[4:0];
wire [31:0] srl_w = exe_reg1_data_i >> reg2_data_in_w[4:0];
wire [31:0] sra_w = $signed(exe_reg1_data_i) >>> reg2_data_in_w[4:0];
wire [31:0] sub_w = exe_reg1_data_i - reg2_data_in_w;

// Output to registers
reg		reg_wr_or;
reg [31:0] 	reg_data_or;
reg [4:0] 	reg_addr_or;
always @(posedge clk_i) begin
	if (rst_i) begin
		reg_wr_or <= #1 0;
		reg_data_or <= #1 32'h0;
		reg_addr_or <= #1 5'h0;
	end
	else if (en_i) begin
	if (exe_inst_i == `LUI | exe_inst_i == `CLUI | exe_inst_i == `CLI) begin 	// LUI
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_imm_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `AUIPC) begin 				// AUIPC
		reg_wr_or <= #1 1;
		reg_data_or <= #1 pc_update_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `JAL) begin 				// JAL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_pc_i + 4;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CJAL) begin 				// CJAL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_pc_i + 2;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CJALR) begin 				// CJALR
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_pc_i + 2;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `JALR) begin 				// JALR
		reg_wr_or <= #1 1;
		reg_data_or <= #1 {jalr_reg_data_ow[31:1], 1'h0};
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `LB | exe_inst_i == `LBU) begin		// LB
		reg_wr_or <= #1 1;
		reg_data_or <= #1 {{24{exe_mem_ld_data_i[7]}}, exe_mem_ld_data_i[7:0]};
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `LH | exe_inst_i == `LHU) begin		// LH
		reg_wr_or <= #1 1;
		reg_data_or <= #1 {{16{exe_mem_ld_data_i[7]}}, exe_mem_ld_data_i[15:0]};
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `LW | exe_inst_i == `CLWSP | exe_inst_i == `CLW) begin	// LW
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_mem_ld_data_i[31:0];
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CMV) begin	// CMV
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_reg2_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `ADDI | exe_inst_i == `ADD | exe_inst_i == `CADDI | exe_inst_i == `CADDI16SP | exe_inst_i == `CADDI4SPN | exe_inst_i == `CADD) begin	// ADDI | ADD
		reg_wr_or <= #1 1;
		reg_data_or <= #1 add_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `SLTI | exe_inst_i == `SLT | exe_inst_i == `SLTU | exe_inst_i == `SLTIU) begin	// SLTI | SLT | SLTU
		reg_wr_or <= #1 1;
		reg_data_or <= #1 {31'h00, slt_w};
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `XORI | exe_inst_i == `XOR | exe_inst_i == `CXOR) begin	// XORI | XOR
		reg_wr_or <= #1 1;
		reg_data_or <= #1 xor_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `ORI | exe_inst_i == `OR | exe_inst_i == `COR) begin		// ORI | OR
		reg_wr_or <= #1 1;
		reg_data_or <= #1 or_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `ANDI | exe_inst_i == `AND | exe_inst_i == `CANDI | exe_inst_i == `CAND) begin	// ANDI | AND
		reg_wr_or <= #1 1;
		reg_data_or <= #1 and_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `SLLI | exe_inst_i == `SLL | exe_inst_i == `CSLLI) begin	// SLLI | SLL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 sll_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `SRLI | exe_inst_i == `SRL | exe_inst_i == `CSRLI) begin	// SRLI | SRL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 srl_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `SRAI | exe_inst_i == `SRA | exe_inst_i == `CSRAI) begin	// SRAI | SRA
		reg_wr_or <= #1 1;
		reg_data_or <= #1 sra_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `SUB | exe_inst_i == `CSUB) begin				// SUB
		reg_wr_or <= #1 1;
		reg_data_or <= #1 sub_w;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CSRRW) begin				// CSRRW
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_csr_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CSRRS) begin				// CSRRS
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_csr_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CSRRC) begin				// CSRRC
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_csr_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CSRRWI) begin				// CSRRWI
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_csr_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CSRRSI) begin				// CSRRSI
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_csr_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `CSRRCI) begin				// CSRRCI
		reg_wr_or <= #1 1;
		reg_data_or <= #1 exe_csr_data_i;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `MUL) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `MULH) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `MULHU) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `MULHSU) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `DIV) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `DIVU) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `REM) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else if (exe_inst_i == `REMU) begin				// MUL
		reg_wr_or <= #1 1;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 exe_reg_dr_i;
	end
	else begin 
		reg_wr_or <= #1 0;
		reg_data_or <= #1 32'h00;
		reg_addr_or <= #1 5'h00;
	end
	end
end

// Output to PC
reg [31:0]	pc_r;
reg 		pc_update_r;
always @(posedge clk_i) begin
	if (rst_i) begin
		pc_r <= #1 32'h00;
		pc_update_r <= #1 0;
	end
	else if (en_i) begin
		if (exe_inst_i == `BEQ | exe_inst_i == `CBEQZ) begin		
			if (exe_reg1_data_i == exe_reg2_data_i) begin
				pc_r <= #1 pc_update_w[31:0];
				pc_update_r <= #1 1;
			end
		end
		else if (exe_inst_i == `BNE | exe_inst_i == `CBNEZ) begin
			if (exe_reg1_data_i != exe_reg2_data_i) begin
				pc_r <= #1 pc_update_w[31:0];
				pc_update_r <= #1 1;
			end
		end
		else if (exe_inst_i == `BLT | exe_inst_i == `BLTU) begin	
			if ($signed(exe_reg1_data_i) < $signed(exe_reg2_data_i)) begin
				pc_r <= #1 pc_update_w[31:0];
				pc_update_r <= #1 1;
			end
		end
		else if (exe_inst_i == `BGE | exe_inst_i == `BGEU) begin
			if ($signed(exe_reg1_data_i) >= $signed(exe_reg2_data_i)) begin
				pc_r <= #1 pc_update_w[31:0];
				pc_update_r <= #1 1;
			end
		end
		else if (exe_inst_i == `JAL | exe_inst_i == `CJ | exe_inst_i == `CJAL) begin
			pc_r <= #1 pc_update_w[31:0];
			pc_update_r <= #1 1;
		end
		else if (exe_inst_i == `JALR) begin
			pc_r <= #1 jalr_reg_data_ow;
			pc_update_r <= #1 1;
		end
		else if (exe_inst_i == `CJR | exe_inst_i == `CJALR) begin		
			pc_r <= #1 exe_reg1_data_i;
			pc_update_r <= #1 1;
		end
		else if (exe_exception_i) begin					
			pc_r <= #1 exe_csr_data_i;
			pc_update_r <= #1 1;
		end
//		else if (exe_inst_i == `MRET) begin		
//			pc_r <= #1 exe_csr_data_i;
//			pc_update_r <= #1 1;
//		end
//		else if (exe_inst_i == `ILLEGAL) begin		
//			pc_r <= #1 exe_csr_data_i;
//			pc_update_r <= #1 1;
//		end
		else begin
			pc_r <= #1 32'h00;
			pc_update_r <= #1 0;
		end
	end
end

// Output to memory
wire [32:0]	mem_addr_w = exe_reg1_data_i + exe_imm_data_i;
reg		mem_wr_en_r;
reg [31:0]	mem_data_or;
reg [31:0]	mem_addr_r;
always @(posedge clk_i) begin
	if (rst_i) begin
		mem_wr_en_r <= #1 0;
		mem_data_or <= #1 32'h00;
		mem_addr_r <= #1 32'h00;
	end
	else if (en_i) begin
	if (exe_inst_i == `SB) begin					// SB
		mem_wr_en_r <= #1 1;
		mem_data_or <= #1 {24'h00, exe_reg2_data_i[7:0]};
		mem_addr_r <= #1 mem_addr_w;
	end
	else if (exe_inst_i == `SH) begin					// SH
		mem_wr_en_r <= #1 1;
		mem_data_or <= #1 {16'h00, exe_reg2_data_i[15:0]};
		mem_addr_r <= #1 mem_addr_w;
	end
	else if (exe_inst_i == `SW | exe_inst_i == `CSWSP | exe_inst_i == `CSW) begin		// SW
		mem_wr_en_r <= #1 1;
		mem_data_or <= #1 exe_reg2_data_i;
		mem_addr_r <= #1 mem_addr_w;
	end
	else begin
		mem_wr_en_r <= #1 0;
		mem_data_or <= #1 32'h00;
		mem_addr_r <= #1 32'h00;
	end
	end
end

// Output to CSR
reg csr_wr_en_r;
reg [31:0] csr_data_r;
reg [11:0] csr_addr_r;
always @(posedge clk_i) begin
	if (rst_i) begin
		csr_wr_en_r <= #1 0;
		csr_data_r <= #1 32'h00;
		csr_addr_r <= #1 12'h00;
	end
	else if (en_i) begin
		if (exe_inst_i == `CSRRW) begin					// CSRRW
			csr_wr_en_r <= #1 (exe_reg_sr1_i) ? 1 : 0;
			csr_data_r <= #1 exe_reg1_data_i;
			csr_addr_r <= #1 exe_csr_addr_i;
		end
		else if (exe_inst_i == `CSRRS) begin					// CSRRS
			csr_wr_en_r <= #1 (exe_reg_sr1_i) ? 1 : 0;
			csr_data_r <= #1 (exe_reg1_data_i | exe_csr_data_i);
			csr_addr_r <= #1 exe_csr_addr_i;
		end
		else if (exe_inst_i == `CSRRC) begin					// CSRRC
			csr_wr_en_r <= #1 (exe_reg_sr1_i) ? 1 : 0;
			csr_data_r <= #1 (!exe_reg1_data_i & exe_csr_addr_i);
			csr_addr_r <= #1 exe_csr_addr_i;
		end
		else if (exe_inst_i == `CSRRWI) begin				// CSRRWI
			csr_wr_en_r <= #1 1;
			csr_data_r <= #1 exe_imm_data_i;
			csr_addr_r <= #1 exe_csr_addr_i;
		end
		else if (exe_inst_i == `CSRRSI) begin				// CSRRSI
			csr_wr_en_r <= #1 1;
			csr_data_r <= #1 (exe_imm_data_i | exe_csr_data_i);
			csr_addr_r <= #1 exe_csr_addr_i;
		end
		else if (exe_inst_i == `CSRRCI) begin				// CSRRCI
			csr_wr_en_r <= #1 1;
			csr_data_r <= #1 (!exe_imm_data_i & exe_csr_addr_i);
			csr_addr_r <= #1 exe_csr_addr_i;
		end
	end
	else begin
		csr_wr_en_r <= #1 0;
		csr_data_r <= #1 32'h00;
		csr_addr_r <= #1 12'h00;
	end
end

// Output to memory
wire exe_mem_wr_en_o = mem_wr_en_r;
wire [31:0] exe_mem_addr_o = mem_addr_r;
wire [31:0] exe_mem_data_o = mem_data_or;

// Output to register
wire muldiv_inst_w = (exe_inst_i == `MUL)
		| (exe_inst_i == `MULH)
		| (exe_inst_i == `MULHSU)
		| (exe_inst_i == `MULHU)
		| (exe_inst_i == `DIV)
		| (exe_inst_i == `DIVU)
		| (exe_inst_i == `REM)
		| (exe_inst_i == `REMU)
		;
wire exe_reg_wr_o = reg_wr_or;
wire [31:0] exe_reg_data_o = (muldiv_inst_w) ? muldiv_data_ow : reg_data_or;
wire [4:0] exe_reg_addr_o = reg_addr_or;

// Output to PC
wire exe_pc_update_o = pc_update_r;
wire [31:0] exe_pc_o = pc_r;

// Output to csr
wire exe_csr_wr_en_o = csr_wr_en_r;
wire [11:0] exe_csr_addr_o = csr_addr_r;
wire [31:0] exe_csr_data_o = csr_data_r;

wire exe_ready_o = (muldiv_inst_w) ? muldiv_ready_ow : en_i;

//-----------------------------------------------------------------------------
// MulDiv
//-----------------------------------------------------------------------------
muldiv u_muldiv
(
	// Input
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.inst_i (exe_inst_i)
	,.reg1_data_i (exe_reg1_data_i)
	,.reg2_data_i (exe_reg2_data_i)

	,.data_o (muldiv_data_ow)
	,.ready_o (muldiv_ready_ow)
	,.exception_o (muldiv_exception_ow)
);

endmodule
