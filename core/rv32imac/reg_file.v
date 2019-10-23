`timescale 1ns / 10ps
module reg_file
(
	// Input
	 input		rst_i
	,input  	clk_i
	,input  	reg_wr_en_i
	,input  [4:0] 	reg_dr_i
	,input  [4:0] 	reg1_sr_i
	,input  [4:0] 	reg2_sr_i
	,input  [31:0] 	reg_data_i

	// Output
	,output [31:0] 	reg1_data_o
	,output [31:0] 	reg2_data_o
);

reg [31:0] REG[0:31];

wire [31:0] reg1_data_o = REG[reg1_sr_i];
wire [31:0] reg2_data_o = REG[reg2_sr_i];
integer i;

initial begin
	for (i = 0; i < 32 ; i = i+1) begin
		REG[i] = 0;
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
	end
	else if (reg_wr_en_i && (reg_dr_i != 5'h00)) begin
		REG[reg_dr_i] <= #1 reg_data_i[31:0];
	end
end

endmodule
