`timescale 1ns / 10ps
`include "inst_def.v"
module muldiv
(
	// Input
	 input rst_i
	,input clk_i
	,input [7:0]	inst_i
	,input [31:0]	reg1_data_i
	,input [31:0]	reg2_data_i

	// Output
	,output	[31:0]	data_o
	,output		ready_o
	,output		exception_o
);

wire	inst_mul_w = inst_i == `MUL;
wire	inst_mulh_w = inst_i == `MULH;
wire	inst_mulhsu_w = inst_i == `MULHSU;
wire	inst_mulhu_w = inst_i == `MULHU;
wire	inst_div_w = inst_i == `DIV;
wire	inst_divu_w = inst_i == `DIVU;
wire	inst_rem_w = inst_i == `REM;
wire	inst_remu_w = inst_i == `REMU;

wire	mul_inst_w = inst_mul_w | inst_mulh_w | inst_mulhsu_w | inst_mulhu_w;
wire	div_inst_w = inst_div_w | inst_divu_w | inst_rem_w | inst_remu_w;

wire [31:0] multiplicand_w = (mul_inst_w) ? reg1_data_i : 32'h00;
wire [31:0] multiplier_w = (mul_inst_w) ? reg2_data_i : 32'h00;
wire [31:0] dividend_w = (div_inst_w) ? reg1_data_i : 32'h00;
wire [31:0] divider_w = (div_inst_w) ? reg2_data_i : 32'h00;
/*
//---------------------------------------------------------------
// simple_mult
//---------------------------------------------------------------
reg [31:0]    product;

reg [31:0]    multiplier_r;
reg [31:0]    multiplicand_r;

reg [6:0]     mul_bit;
wire          mul_ready = mul_bit == 6'h00;
wire          mul_start = mul_bit == 6'd33;

always @( posedge clk_i ) begin
	if (rst_i) begin
		multiplier_r <= #1 32'h00;
		multiplicand_r <= #1 32'h00;
		product <= #1 32'h00;
		mul_bit <= #1 6'd33;
	end
  	else if ( mul_start && inst_mul_w ) begin
		mul_bit <= #1 6'd32;
		product <= #1 32'h00;
		//multiplicand_r <= #1 { 16'd0, multiplicand_w[15:0] };
		multiplicand_r <= #1 multiplicand_w;
     		multiplier_r <= #1 multiplier_w;
  	end
	else if ( !mul_ready && inst_mul_w ) begin
     		if ( multiplier_r[0] == 1'b1 ) product <= #1 product + multiplicand_r;
     		multiplier_r <= #1 multiplier_r >> 1;
     		multiplicand_r <= #1 multiplicand_r << 1;
     		mul_bit <= #1 mul_bit - 1;
  	end
	else
		mul_bit <= #1 6'd33;
end
*/
//---------------------------------------------------------------
// streamlined_signed_mult
//---------------------------------------------------------------
reg [64:0]    product;

reg [31:0]    multiplicand_r;

reg [6:0]     mul_bit;
wire          mul_ready = mul_bit == 6'h00;
wire          mul_start = mul_bit == 6'd33;
wire	sign_multiplier_w =  (inst_mul_w | inst_mulh_w) ? multiplier_w[31] : 0;
wire	sign_multiplicand_w =  (inst_mul_w | inst_mulh_w | inst_mulhsu_w) ? multiplicand_w[31] : 0;

always @(posedge clk_i ) begin
	if (rst_i) begin
		multiplicand_r <= #1 32'h00;
		product <= #1 32'h00;
		mul_bit <= #1 33;
	end
  	else if (mul_start && mul_inst_w) begin
		mul_bit <= #1 6'd32;
     		product <= #1 { 32'd0, sign_multiplier_w ? -multiplier_w : multiplier_w };
     		multiplicand_r <= #1 sign_multiplicand_w ? -multiplicand_w : multiplicand_w;
  	end
       	else if (!mul_ready && mul_inst_w) begin
     		if ( product[0] == 1'b1 ) product[64:32] = #1 product[63:32] + multiplicand_r;
     		product = #1 product >> 1;
     		mul_bit = #1 mul_bit - 1;
	end
	else
		mul_bit <= #1 6'd33;
end

wire [63:0] product_w = (sign_multiplier_w ^ sign_multiplicand_w) ? -product : product;

//---------------------------------------------------------------
// streamlined_divider
//---------------------------------------------------------------

reg [63:0] qr;

reg [6:0] div_bit;
wire div_start = div_bit == 33;
wire div_ready = div_bit == 0;

wire sign_dividend_w = (inst_div_w | inst_rem_w) ? dividend_w[31] : 0;
wire sign_divider_w = (inst_div_w | inst_rem_w) ? divider_w[31] : 0;
wire [31:0] u_divider_w = (sign_divider_w) ? -divider_w : divider_w;
wire [31:0] u_dividend_w = (sign_dividend_w) ? -dividend_w : dividend_w;
wire [32:0] diff = qr[63:31] - {1'b0, u_divider_w};

always @(posedge clk_i) begin
	if (rst_i) begin
		qr <= #1 64'h00;
		div_bit <= #1 33;
	end
	else if (div_start && div_inst_w) begin
		div_bit <= #1 32;
		qr <= #1 {32'h00, u_dividend_w};
	end
	else if (!div_ready && div_inst_w) begin
		if (diff[32]) qr <= #1 {qr[62:0], 1'd0};
		else qr <= #1 {diff[31:0], qr[30:0], 1'd1};
		div_bit <= #1 div_bit - 1;
	end
	else
		div_bit <= #1 33;
end

wire [31:0] quotient_w = (inst_div_w && (divider_w == 32'h00)) ? -1
	: (inst_divu_w && (divider_w == 32'h00)) ? 32'hffff_ffff
	: (sign_dividend_w ^ sign_divider_w) ? -qr[31:0] : qr[31:0];

wire [31:0] remainder_w = (inst_rem_w && (divider_w == 32'h00)) ? dividend_w
	: (inst_remu_w && (divider_w == 32'h00)) ? dividend_w
	: (sign_dividend_w) ? -qr[63:32] : qr[63:32];

//--------------------------------------------------------------
// Output
//--------------------------------------------------------------

wire [31:0] data_o = (inst_mul_w) ? product_w[31:0] 
			: (mul_inst_w) ? product_w[63:32] 
			: (inst_div_w | inst_divu_w) ? quotient_w[31:0]
			: (inst_rem_w | inst_remu_w) ? remainder_w[31:0]
			: 32'h00;
wire ready_o = (mul_inst_w) ? mul_ready 
		: (div_inst_w) ? div_ready 
		: 0;

endmodule
