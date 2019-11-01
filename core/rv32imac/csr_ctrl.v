`timescale 1ns / 10ps
`include "inst_def.v"
`include "csr_field_def.v"
module csr_ctrl
(
	// Input
	 input rst_i
	,input clk_i
	,input en_i
	,input [11:0] 	csr_addr_i
	,input 		csr_wr_en_i
	,input [31:0] 	csr_data_i
	,input [7:0] 	csr_inst_i
	,input  	csr_inst_addr_mis_i
	
	// Output
	,output [31:0] 	csr_data_o
	,output 	csr_exception_o
);

// Input CSR instructions
wire mret_inst_w = (csr_inst_i == `MRET);
wire uret_inst_w = (csr_inst_i == `URET);
// Exception
wire inst_addr_mis_w;
wire ill_inst_w;
wire mcall_inst_w;
wire ucall_inst_w;
// Excaption Delegation
wire mcall;
wire ucall;

reg [1:0] current_mode_r;

`include "csr_mreg_rw.v"
`include "csr_ureg_rw.v"

wire [31:0] csr_data_o = csr_mreg_o | csr_ureg_o;

//----------------------------------------------------------------------------------
// Exception
//----------------------------------------------------------------------------------
wire csr_inst_w = (csr_inst_i == `CSRRW)
		| (csr_inst_i == `CSRRS)
		| (csr_inst_i == `CSRRC)
		| (csr_inst_i == `CSRRWI)
		| (csr_inst_i == `CSRRSI)
		| (csr_inst_i == `CSRRCI)
		;
wire [1:0] csr_inst_priv_w = csr_addr_i[9:8];
wire [1:0] csr_inst_rdwr_w = csr_addr_i[11:10];

assign inst_addr_mis_w = csr_inst_addr_mis_i;
assign ill_inst_w = ((csr_inst_i == `ILLEGAL) && en_i)
			// Access higher mode
			| (csr_inst_w && (csr_inst_priv_w > 0)  && current_mode_r == `U_MODE && en_i)
			// Write to read-only
			| (csr_wr_en_i && csr_inst_rdwr_w == 2'b11)
			;
assign mcall_inst_w = (csr_inst_i == `ECALL) && (current_mode_r == `M_MODE) && en_i;
assign ucall_inst_w = (csr_inst_i == `ECALL) && (current_mode_r == `U_MODE) && en_i;

wire csr_exception_o = (inst_addr_mis_w
		| ill_inst_w
		| mcall_inst_w
		| ucall_inst_w
		);

//----------------------------------------------------------------------------------
// Exception Delegation
//----------------------------------------------------------------------------------
assign mcall = (ucall_inst_w && (medeleg_r[`ECALL_U_MODE] == 0))
		| (ill_inst_w && (medeleg_r[`ILL_INST] == 0))
		| (inst_addr_mis_w && (medeleg_r[`INST_ADDR_MIS] == 0))
		| mcall_inst_w
		;
assign ucall = ucall_inst_w && (medeleg_r[`ECALL_U_MODE] == 1)
		| (ill_inst_w && (medeleg_r[`ILL_INST] == 1))
		| (inst_addr_mis_w && (medeleg_r[`INST_ADDR_MIS] == 1))
		;

//----------------------------------------------------------------------------------
// Current Mode
//----------------------------------------------------------------------------------
always @(posedge clk_i) begin
	if (rst_i) begin
		current_mode_r 	<= #1 2'b11;		// M_MODE		
	end	
	else if (mcall) begin
		current_mode_r <= #1 `M_MODE;
	end
	else if (ucall) begin
		current_mode_r <= #1 `U_MODE;
	end
	else if (mret_inst_w) begin
		current_mode_r <= #1 mstatus_r[`MPP];
	end
end

//----------------------------------------------------------------------------------
// MSTATUS Register
//----------------------------------------------------------------------------------
always @(posedge clk_i) begin
	if (rst_i) begin
		mstatus_r 	<= #1 32'h1800;		// M_MODE		
	end	
	else if (csr_wr_en_i && mstatus_w && current_mode_r == `M_MODE) begin
		mstatus_r <= #1 csr_data_i;   	
	end	
end

//----------------------------------------------------------------------------------
// MCAUSE Register
//----------------------------------------------------------------------------------
always @(posedge clk_i) begin
	if (rst_i) mcause_r <= #1 32'd00;
	else if (inst_addr_mis_w) mcause_r <= #1 `INST_ADDR_MIS;
	else if (ill_inst_w) mcause_r <= #1 `ILL_INST;
	else if (ucall_inst_w) mcause_r <= #1 `ECALL_U_MODE;
	else if (mcall_inst_w) mcause_r <= #1 `ECALL_M_MODE;
end


//assign scall_inst_w = ecall_inst_w & ();

endmodule
