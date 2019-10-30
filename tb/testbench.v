`timescale 1ns / 10ps

module testbench;

parameter cyc = 10.0;

initial begin
        //$shm_open("WAVE");
        //$shm_probe("AS");
        $vcdplusfile("vcdplus.vpd");
        $vcdpluson(0, testbench);
end

//---------------------------------------------------------------------------
reg CLK, RESET;
initial begin
        CLK = 0;
        #(cyc);
        while (1) begin
                CLK = 1;
                #(cyc/2.0);
                CLK = 0;
                #(cyc/2.0);
        end
end

reg RESET_CPU;
initial begin
        RESET = 1;
        RESET_CPU = 0;

        #(cyc*20.4);
        RESET = 0;
        RESET_CPU = 1;

        #(cyc*20.4);
        RESET = 0;
        RESET_CPU = 0;
end

//---------------------------------------------------------------------------
// Initiate DUT
//---------------------------------------------------------------------------

core u_core
(
	// Input
	 .rst_i (RESET)
	,.clk_i (CLK)
);

always @(posedge CLK) begin
	if ({testbench.u_core.u_decode.dec_inst_i[31:0]} == 32'hc0001073) begin
		$display ("Pass----------------\n");
	end
end
initial begin
	#(cyc*10000);
	$display ("Fail----------------\n");
	$finish;
end

endmodule

