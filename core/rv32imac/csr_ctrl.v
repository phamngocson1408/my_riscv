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
	,input  	exc_inst_addr_mis_i
	,input  	int_timer_i
	,input [31:0] 	fet_pc_i
	
	// Output
	,output [31:0] 	csr_data_o
	,output 	csr_trap_o
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
wire mtrap_w;
wire utrap_w;

reg [1:0] current_mode_r;

reg [31:0] cycle_r;
reg [31:0] cycleh_r;
reg [31:0] time_r;
reg [31:0] timeh_r;
reg [31:0] instret_r;
reg [31:0] instreth_r;
reg [31:0] mstatus_r;

`include "csr_ureg_rw.v"
`include "csr_mreg_rw.v"

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

assign inst_addr_mis_w = exc_inst_addr_mis_i;
assign ill_inst_w = ((csr_inst_i == `ILLEGAL) && en_i)
			// Access higher mode
			| (csr_inst_w && (csr_inst_priv_w > 0)  && current_mode_r == `U_MODE && en_i)
			// Write to read-only
			| (csr_wr_en_i && csr_inst_rdwr_w == 2'b11)
			;
assign mcall_inst_w = (csr_inst_i == `ECALL) && (current_mode_r == `M_MODE) && en_i;
assign ucall_inst_w = (csr_inst_i == `ECALL) && (current_mode_r == `U_MODE) && en_i;

wire csr_exception_w = (inst_addr_mis_w
		| ill_inst_w
		| mcall_inst_w
		| ucall_inst_w
		);
	
wire csr_interrupt_w = (int_timer_i && (mstatus_r[`MSTATUS_MIE])
			);

wire csr_trap_o = csr_exception_w | csr_interrupt_w;

//----------------------------------------------------------------------------------
// Exception Delegation
//----------------------------------------------------------------------------------
assign mtrap_w = (ucall_inst_w && (medeleg_r[`ECALL_U_MODE] == 0))
		| (ill_inst_w && (medeleg_r[`ILL_INST] == 0))
		| (inst_addr_mis_w && (medeleg_r[`INST_ADDR_MIS] == 0))
		| mcall_inst_w
		| (int_timer_i && mstatus_r[`MSTATUS_MIE])
		;
assign utrap_w = ucall_inst_w && (medeleg_r[`ECALL_U_MODE] == 1)
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
	else if (mtrap_w) begin
		current_mode_r <= #1 `M_MODE;
	end
	else if (utrap_w) begin
		current_mode_r <= #1 `U_MODE;
	end
	else if (mret_inst_w) begin
		current_mode_r <= #1 mstatus_r[`MSTATUS_MPP];
	end
end

//----------------------------------------------------------------------------------
// MSTATUS Register
//----------------------------------------------------------------------------------
always @(posedge clk_i) begin
	if (rst_i) begin
		mstatus_r 	<= #1 32'h1800 & MSTATUS_WR_MASK;	// M_MODE		
	end	
	else if (csr_wr_en_i && mstatus_w && current_mode_r == `M_MODE) begin
		mstatus_r <= #1 csr_data_i & MSTATUS_WR_MASK;   	
	end	
	else if (csr_wr_en_i && mstatus_w && current_mode_r == `U_MODE) begin
		mstatus_r <= #1 csr_data_i & USTATUS_WR_MASK;   	
	end	
	else if (csr_trap_o) begin
		if (mtrap_w) begin
			mstatus_r[`MSTATUS_MPIE] <= #1 mstatus_r[`MSTATUS_MIE];
			mstatus_r[`MSTATUS_MIE] <= #1 0;
			mstatus_r[`MSTATUS_MPP] <= #1 current_mode_r;
		end
		else if (utrap_w) begin
//			mstatus_r[`MSTATUS_UPIE] <= #1 mstatus_r[`MSTATUS_UIE];
//			mstatus_r[`MSTATUS_UIE] <= #1 0;
		end
	end
	else if (mret_inst_w) begin
		mstatus_r[`MSTATUS_MIE] <= #1 mstatus_r[`MSTATUS_MPIE];
		mstatus_r[`MSTATUS_MPIE] <= #1 1;
		mstatus_r[`MSTATUS_MPP] <= #1 `U_MODE;
	end
	else	
		mstatus_r[`MSTATUS_SD] <= #1 (mstatus_r[`MSTATUS_FS] == 2'b11 | mstatus_r[`MSTATUS_XS] == 2'b11);
end

//----------------------------------------------------------------------------------
// MCAUSE register
//----------------------------------------------------------------------------------
always @(posedge clk_i) begin
	if (rst_i) mcause_r <= #1 32'd00;
	else if (inst_addr_mis_w) mcause_r <= #1 `INST_ADDR_MIS;
	else if (ill_inst_w) mcause_r <= #1 `ILL_INST;
	else if (ucall_inst_w) mcause_r <= #1 `ECALL_U_MODE;
	else if (mcall_inst_w) mcause_r <= #1 `ECALL_M_MODE;
	else if (int_timer_i) mcause_r <= #1 `MTIMER_INT;
end

//----------------------------------------------------------------------------------
// CYCLE, TIME, INSTRET register
//----------------------------------------------------------------------------------
always @(posedge clk_i) begin
	if (rst_i) begin
		cycle_r <= #1 0; 
		cycleh_r <= #1 0; 
		time_r <= #1 0; 
		timeh_r <= #1 0; 
		instret_r <= #1 0; 
		instreth_r <= #1 0; 
	end
	else begin
		if (mcycle_w && csr_wr_en_i) cycle_r <= #1 csr_data_i;
		else	cycle_r <= #1 cycle_r + 1;

		if (mcycleh_w && csr_wr_en_i) cycleh_r <= #1 csr_data_i;
		else if (cycle_r == 32'hffff_ffff) cycleh_r <= #1 cycleh_r + 1;

		if (minstret_w && csr_wr_en_i) instret_r <= #1 csr_data_i;
		else if (en_i && csr_inst_i != `ILLEGAL) instret_r <= #1 instret_r + 1;

		if (minstreth_w && csr_wr_en_i) instreth_r <= #1 csr_data_i;
		else if (en_i && instret_r == 32'hffff_ffff) instreth_r <= #1 instreth_r + 1;

		time_r <= #1 time_r + 1;
		if (time_r == 32'hffff_ffff) timeh_r <= #1 timeh_r + 1;
	end
end

//----------------------------------------------------------------------------------
// MEPC register
//----------------------------------------------------------------------------------
always @(posedge clk_i) begin
	if (rst_i) begin
		mepc_r <= #1 32'h00;
	end	
	else if (csr_wr_en_i && mepc_w) begin
		mepc_r <= #1 csr_data_i;
	end
	else if (mtrap_w) mepc_r <= #1 fet_pc_i;
end


endmodule
