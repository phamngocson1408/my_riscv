`timescale 1ns / 10ps
module timer
(
	// Inpput
	 input 		rst_i
	,input 		clk_i
	,input		timer_wr_en_i
	,input [19:0]	timer_wr_addr_i	
	,input [31:0]	timer_wr_data_i	
	,input		timer_rd_en_i
	,input [19:0]	timer_rd_addr_i	

	// Output
	,output [31:0]	timer_rd_data_o	
	,output 	int_timer_o
);

reg [31:0] mtime;
//reg [31:0] mtimeh;
reg [31:0] mtimecmp;
//reg [31:0] mtimecmph;

wire mtime_wr_w = timer_wr_en_i && (timer_wr_addr_i == 20'h00);
wire mtime_rd_w = timer_rd_en_i && (timer_rd_addr_i == 20'h00);

wire mtimecmp_wr_w = timer_wr_en_i && (timer_wr_addr_i == 20'h04);
wire mtimecmp_rd_w = timer_rd_en_i && (timer_rd_addr_i == 20'h04);

// Clock for timer
reg [5:0] clk_timer;
always @(posedge clk_i) begin
	if (rst_i) begin
		clk_timer <= #1 1;
	end
	else clk_timer <= #1 clk_timer + 1;
end

// Write to timer registers
always @(posedge clk_i) begin
	if (rst_i) begin
		mtime <= #1 0;
		mtimecmp <= #1 32'hffff_ffff;
	end
	else begin
		if (mtime_wr_w) mtime <= #1 timer_wr_data_i;
		else if (clk_timer == 6'h3f) mtime <= #1 mtime + 1;
		if (mtimecmp_wr_w) mtimecmp <= #1 timer_wr_data_i;
	end
end

// Read from timer registers
wire [31:0] timer_rd_data_o = (mtime_rd_w) ? mtime
			: (mtimecmp_rd_w) ? mtimecmp
			: 32'h00;	

// Generate interrupt
wire int_timer_o = mtime >= mtimecmp;

endmodule
