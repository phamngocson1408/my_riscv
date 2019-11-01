`timescale 1ns / 10ps
module fetch
(
	// Input
	 input rst_i
	,input clk_i
	,input  	en_i
	,input 		fet_pc_update_i
	,input [31:0] 	fet_pc_i
	,input  	com_inst_i
	,input  	csr_exception_i
	,input [31:0] 	csr_pc_i

	// Output
	,output [31:0] 	fet_pc_o
	,output  	fet_ready_o
);

reg [31:0] fet_pc_r;

reg start_r;

always @(posedge clk_i) begin
	if (rst_i) start_r <= #1 0;
	else start_r <= #1 1;
end

wire [32:0] fet_pc_4_w = (com_inst_i) ? fet_pc_r + 2
			: fet_pc_r + 4;

parameter ROM_ORI = 'h0_0000;
always @(posedge clk_i) begin
	if (rst_i) fet_pc_r <= #1 ROM_ORI;
	else if (csr_exception_i) fet_pc_r <= #1 csr_pc_i;
	else if (fet_pc_update_i & en_i) fet_pc_r <= #1 fet_pc_i;
	else if (start_r & en_i) fet_pc_r <= #1 fet_pc_4_w[31:0];
end

wire fet_ready_o = en_i;

wire [31:0] fet_pc_o = fet_pc_r;

endmodule
