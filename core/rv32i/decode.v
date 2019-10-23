`timescale 1ns / 10ps
`include "inst_def.v"
module decode
(
	// Input
	 input		rst_i
	,input		clk_i
	,input [31:0] 	dec_inst_i

	 // Output
	,output [7:0] 	dec_inst_o
	,output [4:0] 	dec_reg_dr_o
	,output [4:0]	dec_reg_sr1_o
	,output [4:0]	dec_reg_sr2_o
	,output [31:0] 	dec_imm_data_o
	,output [11:0] 	dec_csr_addr_o
	,output  	dec_lui_inst_o
	,output  	dec_auipc_inst_o
	,output  	dec_jal_inst_o
	,output  	dec_jalr_inst_o
	,output  	dec_con_br_inst_o
	,output  	dec_mem_ld_inst_o
	,output  	dec_mem_st_inst_o
	,output  	dec_int_reg_imm_inst_o
	,output  	dec_int_reg_reg_inst_o
	,output  	dec_mem_model_inst_o
	,output  	dec_csr_inst_o
	,output  	dec_csr_imm_inst_o
);

wire [6:0]	opcode_w = dec_inst_i[6:0];
wire [2:0]	funct3_w = dec_inst_i[14:12];
wire [6:0]	funct7_w = dec_inst_i[31:25];

wire lui_inst_w = (opcode_w[6:0] == 7'b0110111);
wire auipc_inst_w = (opcode_w[6:0] == 7'b0010111);
wire jal_inst_w = (opcode_w[6:0] == 7'b1101111);
wire jalr_inst_w = (opcode_w[6:0] == 7'b1100111);
wire con_br_inst_w = (opcode_w[6:0] == 7'b1100011);
wire mem_ld_inst_w = (opcode_w[6:0] == 7'b0000011);
wire mem_st_inst_w = (opcode_w[6:0] == 7'b0100011);
wire int_reg_imm_inst_w = (opcode_w[6:0] == 7'b0010011);
wire int_reg_reg_inst_w = (opcode_w[6:0] == 7'b0110011);
wire mem_model_inst_w = (opcode_w[6:0] == 7'b0001111);
wire env_brkpt_inst_w = (opcode_w[6:0] == 7'b1110011);
wire csr_inst_w = (opcode_w[6:0] == 7'b1110011) & (funct3_w[2] == 1'b0);
wire csr_imm_inst_w = (opcode_w[6:0] == 7'b1110011) & (funct3_w[2] == 1'b1);

wire reg_sr1_w = (jalr_inst_w
		| con_br_inst_w
		| mem_ld_inst_w
		| mem_st_inst_w
		| int_reg_imm_inst_w
		| int_reg_reg_inst_w
		| csr_inst_w 
		);

wire reg_sr2_w = (con_br_inst_w
		| mem_st_inst_w
		| int_reg_reg_inst_w
		);

wire reg_dr_w = (lui_inst_w
		| auipc_inst_w
		| jal_inst_w
		| jalr_inst_w
		| mem_ld_inst_w
		| int_reg_imm_inst_w
		| int_reg_reg_inst_w
		| csr_inst_w
		| csr_imm_inst_w
		);

wire valid_inst = lui_inst_w
		| auipc_inst_w
		| jal_inst_w
		| jalr_inst_w
		| con_br_inst_w
		| mem_ld_inst_w
		| mem_st_inst_w
		| int_reg_imm_inst_w
		| int_reg_reg_inst_w
		| mem_model_inst_w
		| csr_inst_w
		| csr_imm_inst_w;

reg [4:0]	dec_reg_dr_o;
reg [4:0]	dec_reg_sr1_o;
reg [4:0]	dec_reg_sr2_o;
reg [11:0]	dec_csr_addr_o;

always @(posedge clk_i) begin
	if (rst_i) begin
		dec_reg_dr_o <= #1 5'h00;
		dec_reg_sr1_o <= #1 5'h00;
		dec_reg_sr2_o <= #1 5'h00;
		dec_csr_addr_o <= #1 12'h00;
	end
	else begin
		if (reg_dr_w) dec_reg_dr_o <= #1 dec_inst_i[11:7];
		else dec_reg_dr_o <= #1 5'h0;	
		if (reg_sr1_w) dec_reg_sr1_o <= #1 dec_inst_i[19:15];
		else dec_reg_sr1_o <= #1 5'h0;
		if (reg_sr2_w) dec_reg_sr2_o <= #1 dec_inst_i[24:20];
		else dec_reg_sr2_o <= #1 5'h0;
		if (csr_inst_w | csr_imm_inst_w) dec_csr_addr_o <= #1 dec_inst_i[31:20];
		else dec_csr_addr_o <= #1 12'h00;
	end
end

reg dec_lui_inst_o;
reg dec_auipc_inst_o;
reg dec_jal_inst_o;
reg dec_jalr_inst_o;
reg dec_con_br_inst_o;
reg dec_mem_ld_inst_o;
reg dec_mem_st_inst_o;
reg dec_int_reg_imm_inst_o;
reg dec_int_reg_reg_inst_o;
reg dec_mem_model_inst_o;
reg dec_csr_inst_o;
reg dec_csr_imm_inst_o;

always @(posedge clk_i) begin
	if (rst_i) begin
		dec_lui_inst_o <= #1 0;
		dec_auipc_inst_o <= #1 0;
		dec_jal_inst_o <= #1 0;
		dec_jalr_inst_o <= #1 0;
		dec_con_br_inst_o <= #1 0;
		dec_mem_ld_inst_o <= #1 0;
		dec_mem_st_inst_o <= #1 0;
		dec_int_reg_imm_inst_o <= #1 0;
		dec_int_reg_reg_inst_o <= #1 0;
		dec_mem_model_inst_o <= #1 0;
		dec_csr_inst_o <= #1 0;
		dec_csr_imm_inst_o <= #1 0;
	end
	else begin
		dec_lui_inst_o <= #1 lui_inst_w;
		dec_auipc_inst_o <= #1 auipc_inst_w;
		dec_jal_inst_o <= #1 jal_inst_w;
		dec_jalr_inst_o <= #1 jalr_inst_w;
		dec_con_br_inst_o <= #1 con_br_inst_w;
		dec_mem_ld_inst_o <= #1 mem_ld_inst_w;
		dec_mem_st_inst_o <= #1 mem_st_inst_w;
		dec_int_reg_imm_inst_o <= #1 int_reg_imm_inst_w;
		dec_int_reg_reg_inst_o <= #1 int_reg_reg_inst_w;
		dec_mem_model_inst_o <= #1 mem_model_inst_w;
		dec_csr_inst_o <= #1 csr_inst_w;
		dec_csr_imm_inst_o <= #1 csr_imm_inst_w;
	end
end

reg [7:0] 	dec_inst_o;
reg [31:0]	dec_imm_data_o;
//For debug
reg [63:0]	inst_name;

always @(posedge clk_i) begin
	if (rst_i) begin
		dec_inst_o <= #1 8'h0;
		dec_imm_data_o <= #1 32'h0;
		inst_name <= #1 "000";
	end
	else if (lui_inst_w) begin
		dec_inst_o <= #1 `LUI;	// load upper immediate
		dec_imm_data_o <= #1 {dec_inst_i[31:12], 12'h0};
		inst_name <= #1 "LUI";
	end
	else if (auipc_inst_w) begin
		dec_inst_o <= #1 `AUIPC;	// add upper immediate to pc
		dec_imm_data_o <= #1 {dec_inst_i[31:12], 12'h0};
		inst_name <= #1 "AUIPC";
	end
	else if (jal_inst_w) begin
		dec_inst_o <= #1 `JAL;	// jump and link
		dec_imm_data_o <= #1 {{11{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[19:12], dec_inst_i[20], dec_inst_i[30:21], 1'b0};
		inst_name <= #1 "JAL";
	end
	else if (jalr_inst_w) begin
		dec_inst_o <= #1 `JALR;	// jump and link register 
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "JALR";
	end
	else if (con_br_inst_w && funct3_w == 3'b000) begin
		dec_inst_o <= #1 `BEQ;	// branch on equal
		dec_imm_data_o <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BEQ";
	end
	else if (con_br_inst_w && funct3_w == 3'b001) begin
		dec_inst_o <= #1 `BNE;	// branch on not equal
		dec_imm_data_o <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BNE";
	end
	else if (con_br_inst_w && funct3_w == 3'b100) begin
		dec_inst_o <= #1 `BLT;	// branch on less than
		dec_imm_data_o <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BLT";
	end
	else if (con_br_inst_w && funct3_w == 3'b101) begin
		dec_inst_o <= #1 `BGE;	// branch on greater than
		dec_imm_data_o <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BGE";
	end
	else if (con_br_inst_w && funct3_w == 3'b110) begin
		dec_inst_o <= #1 `BLTU;	// branch on equal
		dec_imm_data_o <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BLTU";
	end
	else if (con_br_inst_w && funct3_w == 3'b111) begin
		dec_inst_o <= #1 `BGEU;	// branch on equal
		dec_imm_data_o <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BGEU";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b000) begin
		dec_inst_o <= #1 `LB;	// load byte
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LB";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b001) begin
		dec_inst_o <= #1 `LH;	// load halfword
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LH";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b010) begin
		dec_inst_o <= #1 `LW;	// load word
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LW";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b100) begin
		dec_inst_o <= #1 `LBU;	// load ......
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LBU";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b101) begin
		dec_inst_o <= #1 `LHU;	// load ......
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LHU";
	end
	else if (mem_st_inst_w && funct3_w == 3'b000) begin
		dec_inst_o <= #1 `SB;	// store byte
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:25], dec_inst_i[11:7]};
		inst_name <= #1 "SB";
	end
	else if (mem_st_inst_w && funct3_w == 3'b001) begin
		dec_inst_o <= #1 `SH;	// store halfword
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:25], dec_inst_i[11:7]};
		inst_name <= #1 "SH";
	end
	else if (mem_st_inst_w && funct3_w == 3'b010) begin
		dec_inst_o <= #1 `SW;	// store word
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:25], dec_inst_i[11:7]};
		inst_name <= #1 "SW";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b000) begin
		dec_inst_o <= #1 `ADDI;	// ADDI
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "ADDI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b010) begin
		dec_inst_o <= #1 `SLTI;	// SLTI
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "SLTI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b011) begin
		dec_inst_o <= #1 `SLTIU;	// SLTIU
		dec_imm_data_o <= #1 {20'h0, dec_inst_i[31:20]};
		inst_name <= #1 "SLTIU";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b100) begin
		dec_inst_o <= #1 `XORI;	// XORI
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "XORI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b110) begin
		dec_inst_o <= #1 `ORI;	// ORI
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "ORI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b111) begin
		dec_inst_o <= #1 `ANDI;	// ANDI
		dec_imm_data_o <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "ANDI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b001) begin
		dec_inst_o <= #1 `SLLI;	// SLLI
		dec_imm_data_o <= #1 {27'h0, dec_inst_i[24:20]};
		inst_name <= #1 "SLLI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `SRLI;	// SRLI
		dec_imm_data_o <= #1 {27'h0, dec_inst_i[24:20]};
		inst_name <= #1 "SRLI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0100000) begin
		dec_inst_o <= #1 `SRAI;	// SRAI
		dec_imm_data_o <= #1 {27'h0, dec_inst_i[24:20]};
		inst_name <= #1 "SRAI";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b000 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `ADD;	// ADD
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "ADD";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b000 && funct7_w == 7'b0100000) begin
		dec_inst_o <= #1 `SUB;	// SUB
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "SUB";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b001 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `SLL;	// SLL
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "SLL";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b010 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `SLT;	// SLT
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "SLT";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b011 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `SLTU;	// SLTU
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "SLTU";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b100 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `XOR;	// XOR
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "XOR";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `SRL;	// SRL
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "SRL";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0100000) begin
		dec_inst_o <= #1 `SRA;	// SRA
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "SRA";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b110 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `OR;	// OR
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "OR";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b111 && funct7_w == 7'b0000000) begin
		dec_inst_o <= #1 `AND;	// AND
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "AND";
	end
	else if (mem_model_inst_w && funct3_w == 3'b000) begin
		dec_inst_o <= #1 `FENCE;	// FENCE
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "FENCE";
	end
	else if (mem_model_inst_w && funct3_w == 3'b001) begin
		dec_inst_o <= #1 `FENCEI;	// FENCEI
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "FENCEI";
	end
	else if (csr_inst_w && funct3_w == 3'b001) begin
		dec_inst_o <= #1 `CSRRW;	// CSRRW
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CSRRW";
	end
	else if (csr_inst_w && funct3_w == 3'b010) begin
		dec_inst_o <= #1 `CSRRS;	// CSRRS
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CSRRS";
	end
	else if (csr_inst_w && funct3_w == 3'b011) begin
		dec_inst_o <= #1 `CSRRC;	// CSRRC
		dec_imm_data_o <= #1 32'h00;
		inst_name <= #1 "CSRRC";
	end
	else if (csr_imm_inst_w && funct3_w == 3'b101) begin
		dec_inst_o <= #1 `CSRRWI;	// CSRRWI
		dec_imm_data_o <= #1 {27'h00, dec_inst_i[19:15]};
		inst_name <= #1 "CSRRWI";
	end
	else if (csr_imm_inst_w && funct3_w == 3'b110) begin
		dec_inst_o <= #1 `CSRRSI;	// CSRRSI
		dec_imm_data_o <= #1 {27'h00, dec_inst_i[19:15]};
		inst_name <= #1 "CSRRSI";
	end
	else if (csr_imm_inst_w && funct3_w == 3'b111) begin
		dec_inst_o <= #1 `CSRRCI;	// CSRRCI
		dec_imm_data_o <= #1 {27'h00, dec_inst_i[19:15]};
		inst_name <= #1 "CSRRCI";
	end
	else begin
		dec_inst_o <= #1 8'h0;
		dec_imm_data_o <= #1 32'h0;
		inst_name <= #1 "000";
	end
end
	
endmodule
