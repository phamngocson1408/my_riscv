
// User Trap Setup
wire ustatus_w 		= csr_addr_i == 12'h000;
wire uie_w 		= csr_addr_i == 12'h004;
wire utvec_w 		=(csr_addr_i == 12'h005);

// User Trap Handling
wire uscratch_w 	= csr_addr_i == 12'h040;
wire uepc_w 		=(csr_addr_i == 12'h041);
wire ucause_w 		= csr_addr_i == 12'h042;
wire utval_w 		= csr_addr_i == 12'h043;
wire uip_w 		= csr_addr_i == 12'h044;

// User Counter/Timers
wire cycle_w 		= csr_addr_i == 12'hc00;
wire time_w 		= csr_addr_i == 12'hc01;
wire instret_w 		= csr_addr_i == 12'hc02;
wire hpmcounter3_w 	= csr_addr_i == 12'hc03;
wire hpmcounter4_w 	= csr_addr_i == 12'hc04;
wire hpmcounter5_w 	= csr_addr_i == 12'hc05;
wire hpmcounter6_w 	= csr_addr_i == 12'hc06;
wire hpmcounter7_w 	= csr_addr_i == 12'hc07;
wire hpmcounter8_w 	= csr_addr_i == 12'hc08;
wire hpmcounter9_w 	= csr_addr_i == 12'hc09;
wire hpmcounter10_w 	= csr_addr_i == 12'hc0a;
wire hpmcounter11_w 	= csr_addr_i == 12'hc0b;
wire hpmcounter12_w 	= csr_addr_i == 12'hc0c;
wire hpmcounter13_w 	= csr_addr_i == 12'hc0d;
wire hpmcounter14_w 	= csr_addr_i == 12'hc0e;
wire hpmcounter15_w 	= csr_addr_i == 12'hc0f;
wire hpmcounter16_w 	= csr_addr_i == 12'hc10;
wire hpmcounter17_w 	= csr_addr_i == 12'hc11;
wire hpmcounter18_w 	= csr_addr_i == 12'hc12;
wire hpmcounter19_w 	= csr_addr_i == 12'hc13;
wire hpmcounter20_w 	= csr_addr_i == 12'hc14;
wire hpmcounter21_w 	= csr_addr_i == 12'hc15;
wire hpmcounter22_w 	= csr_addr_i == 12'hc16;
wire hpmcounter23_w 	= csr_addr_i == 12'hc17;
wire hpmcounter24_w 	= csr_addr_i == 12'hc18;
wire hpmcounter25_w 	= csr_addr_i == 12'hc19;
wire hpmcounter26_w 	= csr_addr_i == 12'hc1a;
wire hpmcounter27_w 	= csr_addr_i == 12'hc1b;
wire hpmcounter28_w 	= csr_addr_i == 12'hc1c;
wire hpmcounter29_w 	= csr_addr_i == 12'hc1d;
wire hpmcounter30_w 	= csr_addr_i == 12'hc1e;
wire hpmcounter31_w 	= csr_addr_i == 12'hc1f;
wire cycleh_w	 	= csr_addr_i == 12'hc80;
wire timeh_w	 	= csr_addr_i == 12'hc81;
wire instreth_w 	= csr_addr_i == 12'hc82;
wire hpmcounter3h_w 	= csr_addr_i == 12'hc83;
wire hpmcounter4h_w 	= csr_addr_i == 12'hc84;
wire hpmcounter5h_w 	= csr_addr_i == 12'hc85;
wire hpmcounter6h_w 	= csr_addr_i == 12'hc86;
wire hpmcounter7h_w 	= csr_addr_i == 12'hc87;
wire hpmcounter8h_w 	= csr_addr_i == 12'hc88;
wire hpmcounter9h_w 	= csr_addr_i == 12'hc89;
wire hpmcounter10h_w 	= csr_addr_i == 12'hc8a;
wire hpmcounter11h_w 	= csr_addr_i == 12'hc8b;
wire hpmcounter12h_w 	= csr_addr_i == 12'hc8c;
wire hpmcounter13h_w 	= csr_addr_i == 12'hc8d;
wire hpmcounter14h_w 	= csr_addr_i == 12'hc8e;
wire hpmcounter15h_w 	= csr_addr_i == 12'hc8f;
wire hpmcounter16h_w 	= csr_addr_i == 12'hc90;
wire hpmcounter17h_w 	= csr_addr_i == 12'hc91;
wire hpmcounter18h_w 	= csr_addr_i == 12'hc92;
wire hpmcounter19h_w 	= csr_addr_i == 12'hc93;
wire hpmcounter20h_w 	= csr_addr_i == 12'hc94;
wire hpmcounter21h_w 	= csr_addr_i == 12'hc95;
wire hpmcounter22h_w 	= csr_addr_i == 12'hc96;
wire hpmcounter23h_w 	= csr_addr_i == 12'hc97;
wire hpmcounter24h_w 	= csr_addr_i == 12'hc98;
wire hpmcounter25h_w 	= csr_addr_i == 12'hc99;
wire hpmcounter26h_w 	= csr_addr_i == 12'hc9a;
wire hpmcounter27h_w 	= csr_addr_i == 12'hc9b;
wire hpmcounter28h_w 	= csr_addr_i == 12'hc9c;
wire hpmcounter29h_w 	= csr_addr_i == 12'hc9d;
wire hpmcounter30h_w 	= csr_addr_i == 12'hc9e;
wire hpmcounter31h_w 	= csr_addr_i == 12'hc9f;

//reg [31:0] ustatus_r ;
reg [31:0] uie_r     ;
reg [31:0] utvec_r   ;

reg [31:0] uscratch_r ;
reg [31:0] uepc_r     ;
reg [31:0] ucause_r   ;
reg [31:0] utval_r    ;
reg [31:0] uip_r      ;

//reg [31:0] cycle_r 		;
//reg [31:0] time_r 		;
//reg [31:0] instret_r 		;
reg [31:0] hpmcounter3_r 	;
reg [31:0] hpmcounter4_r 	;
reg [31:0] hpmcounter5_r 	;
reg [31:0] hpmcounter6_r 	;
reg [31:0] hpmcounter7_r 	;
reg [31:0] hpmcounter8_r 	;
reg [31:0] hpmcounter9_r 	;
reg [31:0] hpmcounter10_r 	;
reg [31:0] hpmcounter11_r 	;
reg [31:0] hpmcounter12_r 	;
reg [31:0] hpmcounter13_r 	;
reg [31:0] hpmcounter14_r 	;
reg [31:0] hpmcounter15_r 	;
reg [31:0] hpmcounter16_r 	;
reg [31:0] hpmcounter17_r 	;
reg [31:0] hpmcounter18_r 	;
reg [31:0] hpmcounter19_r 	;
reg [31:0] hpmcounter20_r 	;
reg [31:0] hpmcounter21_r 	;
reg [31:0] hpmcounter22_r 	;
reg [31:0] hpmcounter23_r 	;
reg [31:0] hpmcounter24_r 	;
reg [31:0] hpmcounter25_r 	;
reg [31:0] hpmcounter26_r 	;
reg [31:0] hpmcounter27_r 	;
reg [31:0] hpmcounter28_r 	;
reg [31:0] hpmcounter29_r 	;
reg [31:0] hpmcounter30_r 	;
reg [31:0] hpmcounter31_r 	;
//reg [31:0] cycleh_r	 	;
//reg [31:0] timeh_r	 	;
//reg [31:0] instreth_r 	;
reg [31:0] hpmcounter3h_r 	;
reg [31:0] hpmcounter4h_r 	;
reg [31:0] hpmcounter5h_r 	;
reg [31:0] hpmcounter6h_r 	;
reg [31:0] hpmcounter7h_r 	;
reg [31:0] hpmcounter8h_r 	;
reg [31:0] hpmcounter9h_r 	;
reg [31:0] hpmcounter10h_r 	;
reg [31:0] hpmcounter11h_r 	;
reg [31:0] hpmcounter12h_r 	;
reg [31:0] hpmcounter13h_r 	;
reg [31:0] hpmcounter14h_r 	;
reg [31:0] hpmcounter15h_r 	;
reg [31:0] hpmcounter16h_r 	;
reg [31:0] hpmcounter17h_r 	;
reg [31:0] hpmcounter18h_r 	;
reg [31:0] hpmcounter19h_r 	;
reg [31:0] hpmcounter20h_r 	;
reg [31:0] hpmcounter21h_r 	;
reg [31:0] hpmcounter22h_r 	;
reg [31:0] hpmcounter23h_r 	;
reg [31:0] hpmcounter24h_r 	;
reg [31:0] hpmcounter25h_r 	;
reg [31:0] hpmcounter26h_r 	;
reg [31:0] hpmcounter27h_r 	;
reg [31:0] hpmcounter28h_r 	;
reg [31:0] hpmcounter29h_r 	;
reg [31:0] hpmcounter30h_r 	;
reg [31:0] hpmcounter31h_r 	;

always @(posedge clk_i) begin
	if (rst_i) begin
		uie_r     	<= #1 32'h00;
		utvec_r   	<= #1 32'h00;
		
		uscratch_r 	<= #1 32'h00;
		uepc_r     	<= #1 32'h00; 
		ucause_r     	<= #1 32'h00; 
		utval_r    	<= #1 32'h00;
		uip_r      	<= #1 32'h00;
		
		hpmcounter3_r 	<= #1 32'h00;
		hpmcounter4_r 	<= #1 32'h00;
		hpmcounter5_r 	<= #1 32'h00;
		hpmcounter6_r 	<= #1 32'h00;
		hpmcounter7_r 	<= #1 32'h00;
		hpmcounter8_r 	<= #1 32'h00;
		hpmcounter9_r 	<= #1 32'h00;
		hpmcounter10_r 	<= #1 32'h00;
		hpmcounter11_r 	<= #1 32'h00;
		hpmcounter12_r 	<= #1 32'h00;
		hpmcounter13_r 	<= #1 32'h00;
		hpmcounter14_r 	<= #1 32'h00;
		hpmcounter15_r 	<= #1 32'h00;
		hpmcounter16_r 	<= #1 32'h00;
		hpmcounter17_r 	<= #1 32'h00;
		hpmcounter18_r 	<= #1 32'h00;
		hpmcounter19_r 	<= #1 32'h00;
		hpmcounter20_r 	<= #1 32'h00;
		hpmcounter21_r 	<= #1 32'h00;
		hpmcounter22_r 	<= #1 32'h00;
		hpmcounter23_r 	<= #1 32'h00;
		hpmcounter24_r 	<= #1 32'h00;
		hpmcounter25_r 	<= #1 32'h00;
		hpmcounter26_r 	<= #1 32'h00;
		hpmcounter27_r 	<= #1 32'h00;
		hpmcounter28_r 	<= #1 32'h00;
		hpmcounter29_r 	<= #1 32'h00;
		hpmcounter30_r 	<= #1 32'h00;
		hpmcounter31_r 	<= #1 32'h00;
		hpmcounter3h_r 	<= #1 32'h00;
		hpmcounter4h_r 	<= #1 32'h00;
		hpmcounter5h_r 	<= #1 32'h00;
		hpmcounter6h_r 	<= #1 32'h00;
		hpmcounter7h_r 	<= #1 32'h00;
		hpmcounter8h_r 	<= #1 32'h00;
		hpmcounter9h_r 	<= #1 32'h00;
		hpmcounter10h_r <= #1 32'h00;
		hpmcounter11h_r <= #1 32'h00;
		hpmcounter12h_r <= #1 32'h00;
		hpmcounter13h_r <= #1 32'h00;
		hpmcounter14h_r <= #1 32'h00;
		hpmcounter15h_r <= #1 32'h00;
		hpmcounter16h_r <= #1 32'h00;
		hpmcounter17h_r <= #1 32'h00;
		hpmcounter18h_r <= #1 32'h00;
		hpmcounter19h_r <= #1 32'h00;
		hpmcounter20h_r <= #1 32'h00;
		hpmcounter21h_r <= #1 32'h00;
		hpmcounter22h_r <= #1 32'h00;
		hpmcounter23h_r <= #1 32'h00;
		hpmcounter24h_r <= #1 32'h00;
		hpmcounter25h_r <= #1 32'h00;
		hpmcounter26h_r <= #1 32'h00;
		hpmcounter27h_r <= #1 32'h00;
		hpmcounter28h_r <= #1 32'h00;
		hpmcounter29h_r <= #1 32'h00;
		hpmcounter30h_r <= #1 32'h00;
		hpmcounter31h_r <= #1 32'h00;
	end
	else if (csr_wr_en_i) begin
		if (uie_w 		) uie_r	     		<= #1 csr_data_i;
		else if (utvec_w 	) utvec_r    		<= #1 csr_data_i;   	

		else if (uscratch_w 	) uscratch_r 		<= #1 csr_data_i;
		else if (uepc_w 	) uepc_r     		<= #1 csr_data_i;
//		else if (ucause_w 	) ucause_r   		<= #1 csr_data_i;
//		else if (utval_w 	) utval_r    		<= #1 csr_data_i;
//		else if (uip_w 		) uip_r	     		<= #1 csr_data_i;

//		else if (cycle_w 	) mcycle_r	 	<= #1 csr_data_i;
//		else if (time_w 	) mtime_r	 	<= #1 csr_data_i;
//		else if (instret_w 	) minstret_r	  	<= #1 csr_data_i;
//		else if (hpmcounter3_w 	) mhpmcounter3_r  	<= #1 csr_data_i;
//		else if (hpmcounter4_w 	) mhpmcounter4_r  	<= #1 csr_data_i;
//		else if (hpmcounter5_w 	) mhpmcounter5_r  	<= #1 csr_data_i;
//		else if (hpmcounter6_w 	) mhpmcounter6_r  	<= #1 csr_data_i;
//		else if (hpmcounter7_w 	) mhpmcounter7_r  	<= #1 csr_data_i;
//		else if (hpmcounter8_w 	) mhpmcounter8_r  	<= #1 csr_data_i;
//		else if (hpmcounter9_w 	) mhpmcounter9_r  	<= #1 csr_data_i;
//		else if (hpmcounter10_w ) mhpmcounter10_r 	<= #1 csr_data_i;
//		else if (hpmcounter11_w ) mhpmcounter11_r 	<= #1 csr_data_i;
//		else if (hpmcounter12_w ) mhpmcounter12_r 	<= #1 csr_data_i;
//		else if (hpmcounter13_w ) mhpmcounter13_r 	<= #1 csr_data_i;
//		else if (hpmcounter14_w ) mhpmcounter14_r 	<= #1 csr_data_i;
//		else if (hpmcounter15_w ) mhpmcounter15_r 	<= #1 csr_data_i;
//		else if (hpmcounter16_w ) mhpmcounter16_r 	<= #1 csr_data_i;
//		else if (hpmcounter17_w ) mhpmcounter17_r 	<= #1 csr_data_i;
//		else if (hpmcounter18_w ) mhpmcounter18_r 	<= #1 csr_data_i;
//		else if (hpmcounter19_w ) mhpmcounter19_r 	<= #1 csr_data_i;
//		else if (hpmcounter20_w ) mhpmcounter20_r 	<= #1 csr_data_i;
//		else if (hpmcounter21_w ) mhpmcounter21_r 	<= #1 csr_data_i;
//		else if (hpmcounter22_w ) mhpmcounter22_r 	<= #1 csr_data_i;
//		else if (hpmcounter23_w ) mhpmcounter23_r 	<= #1 csr_data_i;
//		else if (hpmcounter24_w ) mhpmcounter24_r 	<= #1 csr_data_i;
//		else if (hpmcounter25_w ) mhpmcounter25_r 	<= #1 csr_data_i;
//		else if (hpmcounter26_w ) mhpmcounter26_r 	<= #1 csr_data_i;
//		else if (hpmcounter27_w ) mhpmcounter27_r 	<= #1 csr_data_i;
//		else if (hpmcounter28_w ) mhpmcounter28_r 	<= #1 csr_data_i;
//		else if (hpmcounter29_w ) mhpmcounter29_r 	<= #1 csr_data_i;
//		else if (hpmcounter30_w ) mhpmcounter30_r 	<= #1 csr_data_i;
//		else if (hpmcounter31_w ) mhpmcounter31_r 	<= #1 csr_data_i;
//		else if (cycleh_w	) mcycleh_r	  	<= #1 csr_data_i;
//		else if (instreth_w 	) minstreth_r	  	<= #1 csr_data_i;
//		else if (hpmcounter3h_w ) mhpmcounter3h_r 	<= #1 csr_data_i;
//		else if (hpmcounter4h_w ) mhpmcounter4h_r 	<= #1 csr_data_i;
//		else if (hpmcounter5h_w ) mhpmcounter5h_r 	<= #1 csr_data_i;
//		else if (hpmcounter6h_w ) mhpmcounter6h_r 	<= #1 csr_data_i;
//		else if (hpmcounter7h_w ) mhpmcounter7h_r 	<= #1 csr_data_i;
//		else if (hpmcounter8h_w ) mhpmcounter8h_r 	<= #1 csr_data_i;
//		else if (hpmcounter9h_w ) mhpmcounter9h_r 	<= #1 csr_data_i;
//		else if (hpmcounter10h_w) mhpmcounter10h_r	<= #1 csr_data_i;
//		else if (hpmcounter11h_w) mhpmcounter11h_r	<= #1 csr_data_i;
//		else if (hpmcounter12h_w) mhpmcounter12h_r	<= #1 csr_data_i;
//		else if (hpmcounter13h_w) mhpmcounter13h_r	<= #1 csr_data_i;
//		else if (hpmcounter14h_w) mhpmcounter14h_r	<= #1 csr_data_i;
//		else if (hpmcounter15h_w) mhpmcounter15h_r	<= #1 csr_data_i;
//		else if (hpmcounter16h_w) mhpmcounter16h_r	<= #1 csr_data_i;
//		else if (hpmcounter17h_w) mhpmcounter17h_r	<= #1 csr_data_i;
//		else if (hpmcounter18h_w) mhpmcounter18h_r	<= #1 csr_data_i;
//		else if (hpmcounter19h_w) mhpmcounter19h_r	<= #1 csr_data_i;
//		else if (hpmcounter20h_w) mhpmcounter20h_r	<= #1 csr_data_i;
//		else if (hpmcounter21h_w) mhpmcounter21h_r	<= #1 csr_data_i;
//		else if (hpmcounter22h_w) mhpmcounter22h_r	<= #1 csr_data_i;
//		else if (hpmcounter23h_w) mhpmcounter23h_r	<= #1 csr_data_i;
//		else if (hpmcounter24h_w) mhpmcounter24h_r	<= #1 csr_data_i;
//		else if (hpmcounter25h_w) mhpmcounter25h_r	<= #1 csr_data_i;
//		else if (hpmcounter26h_w) mhpmcounter26h_r	<= #1 csr_data_i;
//		else if (hpmcounter27h_w) mhpmcounter27h_r	<= #1 csr_data_i;
//		else if (hpmcounter28h_w) mhpmcounter28h_r	<= #1 csr_data_i;
//		else if (hpmcounter29h_w) mhpmcounter29h_r	<= #1 csr_data_i;
//		else if (hpmcounter30h_w) mhpmcounter30h_r	<= #1 csr_data_i;
//		else if (hpmcounter31h_w) mhpmcounter31h_r	<= #1 csr_data_i;

	end
end

wire [31:0] csr_ureg_o =  (ustatus_w	) ? mstatus_r & USTATUS_RD_MASK
			: (uie_w 	) ? uie_r	     	
			: (utvec_w 	) ? utvec_r	     	
			
			: (uscratch_w 	) ? uscratch_r
			: (uepc_w 	) ? uepc_r
			: (ucause_w 	) ? ucause_r
			: (utval_w 	) ? utval_r
			: (uip_w 	) ? uip_r
				
			: (cycle_w 		) ? cycle_r
			: (time_w 		) ? time_r
			: (instret_w 		) ? instret_r
			: (hpmcounter3_w 	) ? hpmcounter3_r
			: (hpmcounter4_w 	) ? hpmcounter4_r
			: (hpmcounter5_w 	) ? hpmcounter5_r
			: (hpmcounter6_w 	) ? hpmcounter6_r
			: (hpmcounter7_w 	) ? hpmcounter7_r
			: (hpmcounter8_w 	) ? hpmcounter8_r
			: (hpmcounter9_w 	) ? hpmcounter9_r
			: (hpmcounter10_w 	) ? hpmcounter10_r
			: (hpmcounter11_w 	) ? hpmcounter11_r
			: (hpmcounter12_w 	) ? hpmcounter12_r
			: (hpmcounter13_w 	) ? hpmcounter13_r
			: (hpmcounter14_w 	) ? hpmcounter14_r
			: (hpmcounter15_w 	) ? hpmcounter15_r
			: (hpmcounter16_w 	) ? hpmcounter16_r
			: (hpmcounter17_w 	) ? hpmcounter17_r
			: (hpmcounter18_w 	) ? hpmcounter18_r
			: (hpmcounter19_w 	) ? hpmcounter19_r
			: (hpmcounter20_w 	) ? hpmcounter20_r
			: (hpmcounter21_w 	) ? hpmcounter21_r
			: (hpmcounter22_w 	) ? hpmcounter22_r
			: (hpmcounter23_w 	) ? hpmcounter23_r
			: (hpmcounter24_w 	) ? hpmcounter24_r
			: (hpmcounter25_w 	) ? hpmcounter25_r
			: (hpmcounter26_w 	) ? hpmcounter26_r
			: (hpmcounter27_w 	) ? hpmcounter27_r
			: (hpmcounter28_w 	) ? hpmcounter28_r
			: (hpmcounter29_w 	) ? hpmcounter29_r
			: (hpmcounter30_w 	) ? hpmcounter30_r
			: (hpmcounter31_w 	) ? hpmcounter31_r
			: (cycleh_w	 	) ? cycleh_r
			: (timeh_w	 	) ? timeh_r
			: (instreth_w 		) ? instreth_r
			: (hpmcounter3h_w 	) ? hpmcounter3h_r
			: (hpmcounter4h_w 	) ? hpmcounter4h_r
			: (hpmcounter5h_w 	) ? hpmcounter5h_r
			: (hpmcounter6h_w 	) ? hpmcounter6h_r
			: (hpmcounter7h_w 	) ? hpmcounter7h_r
			: (hpmcounter8h_w 	) ? hpmcounter8h_r
			: (hpmcounter9h_w 	) ? hpmcounter9h_r
			: (hpmcounter10h_w 	) ? hpmcounter10h_r
			: (hpmcounter11h_w 	) ? hpmcounter11h_r
			: (hpmcounter12h_w 	) ? hpmcounter12h_r
			: (hpmcounter13h_w 	) ? hpmcounter13h_r
			: (hpmcounter14h_w 	) ? hpmcounter14h_r
			: (hpmcounter15h_w 	) ? hpmcounter15h_r
			: (hpmcounter16h_w 	) ? hpmcounter16h_r
			: (hpmcounter17h_w 	) ? hpmcounter17h_r
			: (hpmcounter18h_w 	) ? hpmcounter18h_r
			: (hpmcounter19h_w 	) ? hpmcounter19h_r
			: (hpmcounter20h_w 	) ? hpmcounter20h_r
			: (hpmcounter21h_w 	) ? hpmcounter21h_r
			: (hpmcounter22h_w 	) ? hpmcounter22h_r
			: (hpmcounter23h_w 	) ? hpmcounter23h_r
			: (hpmcounter24h_w 	) ? hpmcounter24h_r
			: (hpmcounter25h_w 	) ? hpmcounter25h_r
			: (hpmcounter26h_w 	) ? hpmcounter26h_r
			: (hpmcounter27h_w 	) ? hpmcounter27h_r
			: (hpmcounter28h_w 	) ? hpmcounter28h_r
			: (hpmcounter29h_w 	) ? hpmcounter29h_r
			: (hpmcounter30h_w 	) ? hpmcounter30h_r
			: (hpmcounter31h_w 	) ? hpmcounter31h_r

			: 32'h00;

