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

	,output  	dec_com_inst_o

	,output  	dec_ready_o
);

wire [7:0] com_inst_ow;
wire [4:0] com_reg_dr_ow;
wire [4:0] com_reg_sr1_ow;
wire [4:0] com_reg_sr2_ow;
wire [31:0] com_imm_data_ow;
wire com_inst_val_ow;

decode_com u_decode_com(
	 .rst_i (rst_i)
	,.clk_i (clk_i)
	,.com_inst_i (dec_inst_i[15:0])

	,.com_inst_o (com_inst_ow)
	,.com_reg_dr_o (com_reg_dr_ow)
	,.com_reg_sr1_o (com_reg_sr1_ow)
	,.com_reg_sr2_o (com_reg_sr2_ow)
	,.com_imm_data_o (com_imm_data_ow)
	,.com_inst_val_o (com_inst_val_ow)
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
wire int_reg_reg_inst_w = (opcode_w[6:0] == 7'b0110011 & funct7_w != 7'b0000001 );
wire mem_model_inst_w = (opcode_w[6:0] == 7'b0001111);
wire env_brkpt_inst_w = (opcode_w[6:0] == 7'b1110011);
wire csr_imm_inst_w = (opcode_w[6:0] == 7'b1110011) & (funct3_w[2] == 1'b1);
wire muldiv_inst_w = (opcode_w[6:0] == 7'b0110011) & (funct7_w == 7'b0000001);
wire ecall_inst_w = (opcode_w[6:0] == 7'b1110011) & (dec_inst_i[31:7] == 25'h00);
wire mret_inst_w = (opcode_w[6:0] == 7'b1110011) & (funct7_w == 7'b0011000) & (dec_inst_i[24:20] == 5'b00010) & (dec_inst_i[19:7] == 13'h00);
wire uret_inst_w = (opcode_w[6:0] == 7'b1110011) & (funct7_w == 7'b000_0000) & (dec_inst_i[24:20] == 5'b00010) & (dec_inst_i[19:7] == 13'h00);
wire csr_inst_w = (opcode_w[6:0] == 7'b1110011) & (funct3_w[2] == 1'b0) & !mret_inst_w;

wire reg_sr1_w = (jalr_inst_w
		| con_br_inst_w
		| mem_ld_inst_w
		| mem_st_inst_w
		| int_reg_imm_inst_w
		| int_reg_reg_inst_w
		| csr_inst_w 
		| muldiv_inst_w 
		);

wire reg_sr2_w = (con_br_inst_w
		| mem_st_inst_w
		| int_reg_reg_inst_w
		| muldiv_inst_w
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
		| muldiv_inst_w
		);

wire valid_inst = (lui_inst_w
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
		| csr_imm_inst_w
		| muldiv_inst_w
		| ecall_inst_w
		| mret_inst_w
		| (dec_inst_o == `ILLEGAL)
		);

reg [4:0]	dec_reg_dr_or;
reg [4:0]	dec_reg_sr1_or;
reg [4:0]	dec_reg_sr2_or;
reg [11:0]	dec_csr_addr_o;

always @(posedge clk_i) begin
	if (rst_i) begin
		dec_reg_dr_or <= #1 5'h00;
		dec_reg_sr1_or <= #1 5'h00;
		dec_reg_sr2_or <= #1 5'h00;
		dec_csr_addr_o <= #1 12'h00;
	end
	else begin
		if (reg_dr_w) dec_reg_dr_or <= #1 dec_inst_i[11:7];
		else dec_reg_dr_or <= #1 5'h0;	
		if (reg_sr1_w) dec_reg_sr1_or <= #1 dec_inst_i[19:15];
		else dec_reg_sr1_or <= #1 5'h0;
		if (reg_sr2_w) dec_reg_sr2_or <= #1 dec_inst_i[24:20];
		else dec_reg_sr2_or <= #1 5'h0;
		if (csr_inst_w | csr_imm_inst_w) dec_csr_addr_o <= #1 dec_inst_i[31:20];
		else dec_csr_addr_o <= #1 12'h00;
	end
end

reg [7:0] 	dec_inst_or;
reg [31:0]	dec_imm_data_or;
//For debug
reg [63:0]	inst_name;

always @(posedge clk_i) begin
	if (rst_i) begin
		dec_inst_or <= #1 8'h0;
		dec_imm_data_or <= #1 32'h0;
		inst_name <= #1 "000";
	end
	else if (lui_inst_w) begin
		dec_inst_or <= #1 `LUI;	// load upper immediate
		dec_imm_data_or <= #1 {dec_inst_i[31:12], 12'h0};
		inst_name <= #1 "LUI";
	end
	else if (auipc_inst_w) begin
		dec_inst_or <= #1 `AUIPC;	// add upper immediate to pc
		dec_imm_data_or <= #1 {dec_inst_i[31:12], 12'h0};
		inst_name <= #1 "AUIPC";
	end
	else if (jal_inst_w) begin
		dec_inst_or <= #1 `JAL;	// jump and link
		dec_imm_data_or <= #1 {{11{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[19:12], dec_inst_i[20], dec_inst_i[30:21], 1'b0};
		inst_name <= #1 "JAL";
	end
	else if (jalr_inst_w) begin
		dec_inst_or <= #1 `JALR;	// jump and link register 
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "JALR";
	end
	else if (con_br_inst_w && funct3_w == 3'b000) begin
		dec_inst_or <= #1 `BEQ;	// branch on equal
		dec_imm_data_or <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BEQ";
	end
	else if (con_br_inst_w && funct3_w == 3'b001) begin
		dec_inst_or <= #1 `BNE;	// branch on not equal
		dec_imm_data_or <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BNE";
	end
	else if (con_br_inst_w && funct3_w == 3'b100) begin
		dec_inst_or <= #1 `BLT;	// branch on less than
		dec_imm_data_or <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BLT";
	end
	else if (con_br_inst_w && funct3_w == 3'b101) begin
		dec_inst_or <= #1 `BGE;	// branch on greater than
		dec_imm_data_or <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BGE";
	end
	else if (con_br_inst_w && funct3_w == 3'b110) begin
		dec_inst_or <= #1 `BLTU;	// branch on equal
		dec_imm_data_or <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BLTU";
	end
	else if (con_br_inst_w && funct3_w == 3'b111) begin
		dec_inst_or <= #1 `BGEU;	// branch on equal
		dec_imm_data_or <= #1 {{19{dec_inst_i[31]}}, dec_inst_i[31], dec_inst_i[7], dec_inst_i[30:25], dec_inst_i[11:8], 1'h0};
		inst_name <= #1 "BGEU";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b000) begin
		dec_inst_or <= #1 `LB;	// load byte
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LB";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b001) begin
		dec_inst_or <= #1 `LH;	// load halfword
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LH";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b010) begin
		dec_inst_or <= #1 `LW;	// load word
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LW";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b100) begin
		dec_inst_or <= #1 `LBU;	// load ......
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LBU";
	end
	else if (mem_ld_inst_w && funct3_w == 3'b101) begin
		dec_inst_or <= #1 `LHU;	// load ......
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "LHU";
	end
	else if (mem_st_inst_w && funct3_w == 3'b000) begin
		dec_inst_or <= #1 `SB;	// store byte
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:25], dec_inst_i[11:7]};
		inst_name <= #1 "SB";
	end
	else if (mem_st_inst_w && funct3_w == 3'b001) begin
		dec_inst_or <= #1 `SH;	// store halfword
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:25], dec_inst_i[11:7]};
		inst_name <= #1 "SH";
	end
	else if (mem_st_inst_w && funct3_w == 3'b010) begin
		dec_inst_or <= #1 `SW;	// store word
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:25], dec_inst_i[11:7]};
		inst_name <= #1 "SW";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b000) begin
		dec_inst_or <= #1 `ADDI;	// ADDI
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "ADDI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b010) begin
		dec_inst_or <= #1 `SLTI;	// SLTI
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "SLTI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b011) begin
		dec_inst_or <= #1 `SLTIU;	// SLTIU
		dec_imm_data_or <= #1 {20'h0, dec_inst_i[31:20]};
		inst_name <= #1 "SLTIU";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b100) begin
		dec_inst_or <= #1 `XORI;	// XORI
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "XORI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b110) begin
		dec_inst_or <= #1 `ORI;	// ORI
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "ORI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b111) begin
		dec_inst_or <= #1 `ANDI;	// ANDI
		dec_imm_data_or <= #1 {{20{dec_inst_i[31]}}, dec_inst_i[31:20]};
		inst_name <= #1 "ANDI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b001) begin
		dec_inst_or <= #1 `SLLI;	// SLLI
		dec_imm_data_or <= #1 {27'h0, dec_inst_i[24:20]};
		inst_name <= #1 "SLLI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `SRLI;	// SRLI
		dec_imm_data_or <= #1 {27'h0, dec_inst_i[24:20]};
		inst_name <= #1 "SRLI";
	end
	else if (int_reg_imm_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0100000) begin
		dec_inst_or <= #1 `SRAI;	// SRAI
		dec_imm_data_or <= #1 {27'h0, dec_inst_i[24:20]};
		inst_name <= #1 "SRAI";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b000 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `ADD;	// ADD
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "ADD";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b000 && funct7_w == 7'b0100000) begin
		dec_inst_or <= #1 `SUB;	// SUB
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "SUB";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b001 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `SLL;	// SLL
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "SLL";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b010 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `SLT;	// SLT
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "SLT";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b011 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `SLTU;	// SLTU
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "SLTU";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b100 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `XOR;	// XOR
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "XOR";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `SRL;	// SRL
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "SRL";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b101 && funct7_w == 7'b0100000) begin
		dec_inst_or <= #1 `SRA;	// SRA
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "SRA";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b110 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `OR;	// OR
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "OR";
	end
	else if (int_reg_reg_inst_w && funct3_w == 3'b111 && funct7_w == 7'b0000000) begin
		dec_inst_or <= #1 `AND;	// AND
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "AND";
	end
	else if (mem_model_inst_w && funct3_w == 3'b000) begin
		dec_inst_or <= #1 `FENCE;	// FENCE
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "FENCE";
	end
	else if (mem_model_inst_w && funct3_w == 3'b001) begin
		dec_inst_or <= #1 `FENCEI;	// FENCEI
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "FENCEI";
	end
	else if (csr_inst_w && funct3_w == 3'b001) begin
		dec_inst_or <= #1 `CSRRW;	// CSRRW
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "CSRRW";
	end
	else if (csr_inst_w && funct3_w == 3'b010) begin
		dec_inst_or <= #1 `CSRRS;	// CSRRS
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "CSRRS";
	end
	else if (csr_inst_w && funct3_w == 3'b011) begin
		dec_inst_or <= #1 `CSRRC;	// CSRRC
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "CSRRC";
	end
	else if (csr_imm_inst_w && funct3_w == 3'b101) begin
		dec_inst_or <= #1 `CSRRWI;	// CSRRWI
		dec_imm_data_or <= #1 {27'h00, dec_inst_i[19:15]};
		inst_name <= #1 "CSRRWI";
	end
	else if (csr_imm_inst_w && funct3_w == 3'b110) begin
		dec_inst_or <= #1 `CSRRSI;	// CSRRSI
		dec_imm_data_or <= #1 {27'h00, dec_inst_i[19:15]};
		inst_name <= #1 "CSRRSI";
	end
	else if (csr_imm_inst_w && funct3_w == 3'b111) begin
		dec_inst_or <= #1 `CSRRCI;	// CSRRCI
		dec_imm_data_or <= #1 {27'h00, dec_inst_i[19:15]};
		inst_name <= #1 "CSRRCI";
	end
	else if (muldiv_inst_w && funct3_w == 3'b000) begin
		dec_inst_or <= #1 `MUL;	// MUL
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "MUL";
	end
	else if (muldiv_inst_w && funct3_w == 3'b001) begin
		dec_inst_or <= #1 `MULH;	// MUL
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "MULH";
	end
	else if (muldiv_inst_w && funct3_w == 3'b010) begin
		dec_inst_or <= #1 `MULHSU;	// MUL
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "MULHSU";
	end
	else if (muldiv_inst_w && funct3_w == 3'b011) begin
		dec_inst_or <= #1 `MULHU;	// MUL
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "MULHU";
	end
	else if (muldiv_inst_w && funct3_w == 3'b100) begin
		dec_inst_or <= #1 `DIV;	// DIV
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "DIV";
	end
	else if (muldiv_inst_w && funct3_w == 3'b101) begin
		dec_inst_or <= #1 `DIVU;	// DIV
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "DIVU";
	end
	else if (muldiv_inst_w && funct3_w == 3'b110) begin
		dec_inst_or <= #1 `REM;	// DIV
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "REM";
	end
	else if (muldiv_inst_w && funct3_w == 3'b111) begin
		dec_inst_or <= #1 `REMU;	// DIV
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "REMU";
	end
	else if (ecall_inst_w) begin
		dec_inst_or <= #1 `ECALL;	// ECALL
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "ECALL";
	end
	else if (mret_inst_w) begin
		dec_inst_or <= #1 `MRET;	// MRET
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "MRET";
	end
	else if (uret_inst_w) begin
		dec_inst_or <= #1 `URET;	// URET
		dec_imm_data_or <= #1 32'h00;
		inst_name <= #1 "URET";
	end
	else begin
		dec_inst_or <= #1 `ILLEGAL;
		dec_imm_data_or <= #1 32'h0;
		inst_name <= #1 "ILLEGAL";
	end
end

wire [7:0] dec_inst_o = (com_inst_val_ow) ? com_inst_ow : dec_inst_or;
wire [4:0] dec_reg_dr_o = (com_inst_val_ow) ? com_reg_dr_ow : dec_reg_dr_or;
wire [4:0] dec_reg_sr1_o = (com_inst_val_ow) ? com_reg_sr1_ow : dec_reg_sr1_or;
wire [4:0] dec_reg_sr2_o = (com_inst_val_ow) ? com_reg_sr2_ow : dec_reg_sr2_or;
wire [31:0] dec_imm_data_o = (com_inst_val_ow) ? com_imm_data_ow : dec_imm_data_or;

wire dec_com_inst_o = com_inst_val_ow;

wire dec_ready_o = valid_inst | com_inst_val_ow;
	
endmodule
