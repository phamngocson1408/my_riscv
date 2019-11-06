
// Supervisor Trap Setup
wire stvec_w 	= csr_addr_i == 12'h105;

// Supervisor Protection and Translation
wire satp_w 	= csr_addr_i == 12'h180;

// Machine Information Registers
wire mvendorid_w 	= csr_addr_i == 12'hf11;
wire marchid_w		= csr_addr_i == 12'hf12;
wire mimpid_w 		= csr_addr_i == 12'hf13;
wire mhartid_w 		= csr_addr_i == 12'hf14;	

// Machine Trap Setup
wire mstatus_w 		= csr_addr_i == 12'h300;
wire misa_w 		= csr_addr_i == 12'h301;
wire medeleg_w 		= csr_addr_i == 12'h302;
wire mideleg_w 		= csr_addr_i == 12'h303;
wire mie_w 		= csr_addr_i == 12'h304;
wire mtvec_w 		= (csr_addr_i == 12'h305) | mtrap_w;
wire mcounteren_w 	= csr_addr_i == 12'h306;

// Machine Trap Handling
wire mscratch_w 	= csr_addr_i == 12'h340;
wire mepc_w 		= (csr_addr_i == 12'h341) | mret_inst_w;
wire mcause_w 		= csr_addr_i == 12'h342;
wire mtval_w 		= csr_addr_i == 12'h343;
wire mip_w 		= csr_addr_i == 12'h344;

// Machine Memory Protection
wire pmpcfg0_w 		= csr_addr_i == 12'h3a0;
wire pmpcfg1_w 		= csr_addr_i == 12'h3a1;
wire pmpcfg2_w 		= csr_addr_i == 12'h3a2;
wire pmpcfg3_w 		= csr_addr_i == 12'h3a3;
wire pmpaddr0_w 	= csr_addr_i == 12'h3b0;
wire pmpaddr1_w 	= csr_addr_i == 12'h3b1;
wire pmpaddr2_w 	= csr_addr_i == 12'h3b2;
wire pmpaddr3_w 	= csr_addr_i == 12'h3b3;
wire pmpaddr4_w 	= csr_addr_i == 12'h3b4;
wire pmpaddr5_w 	= csr_addr_i == 12'h3b5;
wire pmpaddr6_w 	= csr_addr_i == 12'h3b6;
wire pmpaddr7_w 	= csr_addr_i == 12'h3b7;
wire pmpaddr8_w 	= csr_addr_i == 12'h3b8;
wire pmpaddr9_w 	= csr_addr_i == 12'h3b9;
wire pmpaddr10_w 	= csr_addr_i == 12'h3ba;
wire pmpaddr11_w 	= csr_addr_i == 12'h3bb;
wire pmpaddr12_w 	= csr_addr_i == 12'h3bc;
wire pmpaddr13_w 	= csr_addr_i == 12'h3bd;
wire pmpaddr14_w 	= csr_addr_i == 12'h3be;
wire pmpaddr15_w 	= csr_addr_i == 12'h3bf;

// Machine Counter/Timers
wire mcycle_w 		= csr_addr_i == 12'hb00;
wire minstret_w 	= csr_addr_i == 12'hb02;
wire mhpmcounter3_w 	= csr_addr_i == 12'hb03;
wire mhpmcounter4_w 	= csr_addr_i == 12'hb04;
wire mhpmcounter5_w 	= csr_addr_i == 12'hb05;
wire mhpmcounter6_w 	= csr_addr_i == 12'hb06;
wire mhpmcounter7_w 	= csr_addr_i == 12'hb07;
wire mhpmcounter8_w 	= csr_addr_i == 12'hb08;
wire mhpmcounter9_w 	= csr_addr_i == 12'hb09;
wire mhpmcounter10_w 	= csr_addr_i == 12'hb0a;
wire mhpmcounter11_w 	= csr_addr_i == 12'hb0b;
wire mhpmcounter12_w 	= csr_addr_i == 12'hb0c;
wire mhpmcounter13_w 	= csr_addr_i == 12'hb0d;
wire mhpmcounter14_w 	= csr_addr_i == 12'hb0e;
wire mhpmcounter15_w 	= csr_addr_i == 12'hb0f;
wire mhpmcounter16_w 	= csr_addr_i == 12'hb10;
wire mhpmcounter17_w 	= csr_addr_i == 12'hb11;
wire mhpmcounter18_w 	= csr_addr_i == 12'hb12;
wire mhpmcounter19_w 	= csr_addr_i == 12'hb13;
wire mhpmcounter20_w 	= csr_addr_i == 12'hb14;
wire mhpmcounter21_w 	= csr_addr_i == 12'hb15;
wire mhpmcounter22_w 	= csr_addr_i == 12'hb16;
wire mhpmcounter23_w 	= csr_addr_i == 12'hb17;
wire mhpmcounter24_w 	= csr_addr_i == 12'hb18;
wire mhpmcounter25_w 	= csr_addr_i == 12'hb19;
wire mhpmcounter26_w 	= csr_addr_i == 12'hb1a;
wire mhpmcounter27_w 	= csr_addr_i == 12'hb1b;
wire mhpmcounter28_w 	= csr_addr_i == 12'hb1c;
wire mhpmcounter29_w 	= csr_addr_i == 12'hb1d;
wire mhpmcounter30_w 	= csr_addr_i == 12'hb1e;
wire mhpmcounter31_w 	= csr_addr_i == 12'hb1f;
wire mcycleh_w	 	= csr_addr_i == 12'hb80;
wire minstreth_w 	= csr_addr_i == 12'hb82;
wire mhpmcounter3h_w 	= csr_addr_i == 12'hb83;
wire mhpmcounter4h_w 	= csr_addr_i == 12'hb84;
wire mhpmcounter5h_w 	= csr_addr_i == 12'hb85;
wire mhpmcounter6h_w 	= csr_addr_i == 12'hb86;
wire mhpmcounter7h_w 	= csr_addr_i == 12'hb87;
wire mhpmcounter8h_w 	= csr_addr_i == 12'hb88;
wire mhpmcounter9h_w 	= csr_addr_i == 12'hb89;
wire mhpmcounter10h_w 	= csr_addr_i == 12'hb8a;
wire mhpmcounter11h_w 	= csr_addr_i == 12'hb8b;
wire mhpmcounter12h_w 	= csr_addr_i == 12'hb8c;
wire mhpmcounter13h_w 	= csr_addr_i == 12'hb8d;
wire mhpmcounter14h_w 	= csr_addr_i == 12'hb8e;
wire mhpmcounter15h_w 	= csr_addr_i == 12'hb8f;
wire mhpmcounter16h_w 	= csr_addr_i == 12'hb90;
wire mhpmcounter17h_w 	= csr_addr_i == 12'hb91;
wire mhpmcounter18h_w 	= csr_addr_i == 12'hb92;
wire mhpmcounter19h_w 	= csr_addr_i == 12'hb93;
wire mhpmcounter20h_w 	= csr_addr_i == 12'hb94;
wire mhpmcounter21h_w 	= csr_addr_i == 12'hb95;
wire mhpmcounter22h_w 	= csr_addr_i == 12'hb96;
wire mhpmcounter23h_w 	= csr_addr_i == 12'hb97;
wire mhpmcounter24h_w 	= csr_addr_i == 12'hb98;
wire mhpmcounter25h_w 	= csr_addr_i == 12'hb99;
wire mhpmcounter26h_w 	= csr_addr_i == 12'hb9a;
wire mhpmcounter27h_w 	= csr_addr_i == 12'hb9b;
wire mhpmcounter28h_w 	= csr_addr_i == 12'hb9c;
wire mhpmcounter29h_w 	= csr_addr_i == 12'hb9d;
wire mhpmcounter30h_w 	= csr_addr_i == 12'hb9e;
wire mhpmcounter31h_w 	= csr_addr_i == 12'hb9f;

// Machine Counter Setup
wire mcountinhibit_w 	= csr_addr_i == 12'h320;
wire mhpmevent3_w 	= csr_addr_i == 12'h323;
wire mhpmevent4_w 	= csr_addr_i == 12'h324;
wire mhpmevent5_w 	= csr_addr_i == 12'h325;
wire mhpmevent6_w 	= csr_addr_i == 12'h326;
wire mhpmevent7_w 	= csr_addr_i == 12'h327;
wire mhpmevent8_w 	= csr_addr_i == 12'h328;
wire mhpmevent9_w 	= csr_addr_i == 12'h329;
wire mhpmevent10_w 	= csr_addr_i == 12'h32a;
wire mhpmevent11_w 	= csr_addr_i == 12'h32b;
wire mhpmevent12_w 	= csr_addr_i == 12'h32c;
wire mhpmevent13_w 	= csr_addr_i == 12'h32d;
wire mhpmevent14_w 	= csr_addr_i == 12'h32e;
wire mhpmevent15_w 	= csr_addr_i == 12'h32f;
wire mhpmevent16_w 	= csr_addr_i == 12'h330;
wire mhpmevent17_w 	= csr_addr_i == 12'h331;
wire mhpmevent18_w 	= csr_addr_i == 12'h332;
wire mhpmevent19_w 	= csr_addr_i == 12'h333;
wire mhpmevent20_w 	= csr_addr_i == 12'h334;
wire mhpmevent21_w 	= csr_addr_i == 12'h335;
wire mhpmevent22_w 	= csr_addr_i == 12'h336;
wire mhpmevent23_w 	= csr_addr_i == 12'h337;
wire mhpmevent24_w 	= csr_addr_i == 12'h338;
wire mhpmevent25_w 	= csr_addr_i == 12'h339;
wire mhpmevent26_w 	= csr_addr_i == 12'h33a;
wire mhpmevent27_w 	= csr_addr_i == 12'h33b;
wire mhpmevent28_w 	= csr_addr_i == 12'h33c;
wire mhpmevent29_w 	= csr_addr_i == 12'h33d;
wire mhpmevent30_w 	= csr_addr_i == 12'h33e;
wire mhpmevent31_w 	= csr_addr_i == 12'h33f;

// Debug/Trace Registers
wire tselect_w	 	= csr_addr_i == 12'h7a0;
wire tdata1_w	 	= csr_addr_i == 12'h7a1;
wire tdata2_w	 	= csr_addr_i == 12'h7a2;
wire tdata3_w	 	= csr_addr_i == 12'h7a3;

// Debug Mode Registers
wire dcsr_w	 	= csr_addr_i == 12'h7b0;
wire dpc_w	 	= csr_addr_i == 12'h7b1;
wire dscratch0_w 	= csr_addr_i == 12'h7b2;
wire dscratch1_w 	= csr_addr_i == 12'h7b3;


reg [31:0] stvec_r ;

reg [31:0] satp_r ;

reg [31:0] mvendorid_r ;
reg [31:0] marchid_r   ;
reg [31:0] mimpid_r    ;
reg [31:0] mhartid_r   ;	

//reg [31:0] mstatus_r ;
reg [31:0] misa_r    ;
reg [31:0] medeleg_r ;
reg [31:0] mideleg_r ;
reg [31:0] mie_r     ;
reg [31:0] mtvec_r   ;
reg [31:0] mcounteren_r ;

reg [31:0] mscratch_r ;
reg [31:0] mepc_r     ;
reg [31:0] mcause_r   ;
reg [31:0] mtval_r    ;
reg [31:0] mip_r      ;

reg [31:0] pmpcfg0_r 	;
reg [31:0] pmpcfg1_r 	;
reg [31:0] pmpcfg2_r 	;
reg [31:0] pmpcfg3_r 	;
reg [31:0] pmpaddr0_r 	;
reg [31:0] pmpaddr1_r 	;
reg [31:0] pmpaddr2_r 	;
reg [31:0] pmpaddr3_r 	;
reg [31:0] pmpaddr4_r 	;
reg [31:0] pmpaddr5_r 	;
reg [31:0] pmpaddr6_r	;
reg [31:0] pmpaddr7_r 	;
reg [31:0] pmpaddr8_r 	;
reg [31:0] pmpaddr9_r 	;
reg [31:0] pmpaddr10_r 	;
reg [31:0] pmpaddr11_r 	;
reg [31:0] pmpaddr12_r	;
reg [31:0] pmpaddr13_r 	;
reg [31:0] pmpaddr14_r 	;
reg [31:0] pmpaddr15_r 	;

//reg [31:0] mcycle_r 		;
//reg [31:0] minstret_r 	;
reg [31:0] mhpmcounter3_r 	;
reg [31:0] mhpmcounter4_r 	;
reg [31:0] mhpmcounter5_r 	;
reg [31:0] mhpmcounter6_r 	;
reg [31:0] mhpmcounter7_r 	;
reg [31:0] mhpmcounter8_r 	;
reg [31:0] mhpmcounter9_r 	;
reg [31:0] mhpmcounter10_r 	;
reg [31:0] mhpmcounter11_r 	;
reg [31:0] mhpmcounter12_r 	;
reg [31:0] mhpmcounter13_r 	;
reg [31:0] mhpmcounter14_r 	;
reg [31:0] mhpmcounter15_r 	;
reg [31:0] mhpmcounter16_r 	;
reg [31:0] mhpmcounter17_r 	;
reg [31:0] mhpmcounter18_r 	;
reg [31:0] mhpmcounter19_r 	;
reg [31:0] mhpmcounter20_r 	;
reg [31:0] mhpmcounter21_r 	;
reg [31:0] mhpmcounter22_r 	;
reg [31:0] mhpmcounter23_r 	;
reg [31:0] mhpmcounter24_r 	;
reg [31:0] mhpmcounter25_r 	;
reg [31:0] mhpmcounter26_r 	;
reg [31:0] mhpmcounter27_r 	;
reg [31:0] mhpmcounter28_r 	;
reg [31:0] mhpmcounter29_r 	;
reg [31:0] mhpmcounter30_r 	;
reg [31:0] mhpmcounter31_r 	;
//reg [31:0] mcycleh_r	 	;
//reg [31:0] minstreth_r 	;
reg [31:0] mhpmcounter3h_r 	;
reg [31:0] mhpmcounter4h_r 	;
reg [31:0] mhpmcounter5h_r 	;
reg [31:0] mhpmcounter6h_r 	;
reg [31:0] mhpmcounter7h_r 	;
reg [31:0] mhpmcounter8h_r 	;
reg [31:0] mhpmcounter9h_r 	;
reg [31:0] mhpmcounter10h_r 	;
reg [31:0] mhpmcounter11h_r 	;
reg [31:0] mhpmcounter12h_r 	;
reg [31:0] mhpmcounter13h_r 	;
reg [31:0] mhpmcounter14h_r 	;
reg [31:0] mhpmcounter15h_r 	;
reg [31:0] mhpmcounter16h_r 	;
reg [31:0] mhpmcounter17h_r 	;
reg [31:0] mhpmcounter18h_r 	;
reg [31:0] mhpmcounter19h_r 	;
reg [31:0] mhpmcounter20h_r 	;
reg [31:0] mhpmcounter21h_r 	;
reg [31:0] mhpmcounter22h_r 	;
reg [31:0] mhpmcounter23h_r 	;
reg [31:0] mhpmcounter24h_r 	;
reg [31:0] mhpmcounter25h_r 	;
reg [31:0] mhpmcounter26h_r 	;
reg [31:0] mhpmcounter27h_r 	;
reg [31:0] mhpmcounter28h_r 	;
reg [31:0] mhpmcounter29h_r 	;
reg [31:0] mhpmcounter30h_r 	;
reg [31:0] mhpmcounter31h_r 	;

reg [31:0] mcountinhibit_r 	;
reg [31:0] mhpmevent3_r 	;
reg [31:0] mhpmevent4_r 	;
reg [31:0] mhpmevent5_r 	;
reg [31:0] mhpmevent6_r 	;
reg [31:0] mhpmevent7_r 	;
reg [31:0] mhpmevent8_r 	;
reg [31:0] mhpmevent9_r 	;
reg [31:0] mhpmevent10_r 	;
reg [31:0] mhpmevent11_r 	;
reg [31:0] mhpmevent12_r 	;
reg [31:0] mhpmevent13_r 	;
reg [31:0] mhpmevent14_r 	;
reg [31:0] mhpmevent15_r 	;
reg [31:0] mhpmevent16_r 	;
reg [31:0] mhpmevent17_r 	;
reg [31:0] mhpmevent18_r 	;
reg [31:0] mhpmevent19_r 	;
reg [31:0] mhpmevent20_r 	;
reg [31:0] mhpmevent21_r 	;
reg [31:0] mhpmevent22_r 	;
reg [31:0] mhpmevent23_r 	;
reg [31:0] mhpmevent24_r 	;
reg [31:0] mhpmevent25_r 	;
reg [31:0] mhpmevent26_r 	;
reg [31:0] mhpmevent27_r 	;
reg [31:0] mhpmevent28_r 	;
reg [31:0] mhpmevent29_r 	;
reg [31:0] mhpmevent30_r 	;
reg [31:0] mhpmevent31_r 	;

reg [31:0] tselect_r	 	;
reg [31:0] tdata1_r	 	;
reg [31:0] tdata2_r	 	;
reg [31:0] tdata3_r	 	;

reg [31:0] dcsr_r	 	;
reg [31:0] dpc_r	 	;
reg [31:0] dscratch0_r 		;
reg [31:0] dscratch1_r 		;

reg		wr_invalid_r;

always @(posedge clk_i) begin
	if (rst_i) begin
		stvec_r		<= #1 32'h00;

		satp_r		<= #1 32'h00;

		mvendorid_r 	<= #1 32'h00;
		marchid_r   	<= #1 32'h00;
		mimpid_r    	<= #1 32'h00;
		mhartid_r   	<= #1 32'h00;	
		
		misa_r    	<= #1 MISA_VALUE;
		medeleg_r 	<= #1 32'h00;
		mideleg_r 	<= #1 32'h00;
		mie_r     	<= #1 32'h00;
		mtvec_r   	<= #1 32'h00;
		mcounteren_r 	<= #1 32'h00;
		
		mscratch_r 	<= #1 32'h00;
//		mepc_r     	<= #1 32'h00; 
		mtval_r    	<= #1 32'h00;
		mip_r      	<= #1 32'h00;
		
		pmpcfg0_r 	<= #1 32'h00;
		pmpcfg1_r 	<= #1 32'h00;
		pmpcfg2_r 	<= #1 32'h00;
		pmpcfg3_r 	<= #1 32'h00;
		pmpaddr0_r 	<= #1 32'h00;
		pmpaddr1_r 	<= #1 32'h00;
		pmpaddr2_r 	<= #1 32'h00;
		pmpaddr3_r 	<= #1 32'h00;
		pmpaddr4_r 	<= #1 32'h00;
		pmpaddr5_r 	<= #1 32'h00;
		pmpaddr6_r	<= #1 32'h00;
		pmpaddr7_r 	<= #1 32'h00;
		pmpaddr8_r 	<= #1 32'h00;
		pmpaddr9_r 	<= #1 32'h00;
		pmpaddr10_r 	<= #1 32'h00;
		pmpaddr11_r 	<= #1 32'h00;
		pmpaddr12_r	<= #1 32'h00;
		pmpaddr13_r 	<= #1 32'h00;
		pmpaddr14_r 	<= #1 32'h00;
		pmpaddr15_r 	<= #1 32'h00;
		
//		mcycle_r 		<= #1 32'h00;
//		minstret_r 		<= #1 32'h00;
		mhpmcounter3_r 		<= #1 32'h00;
		mhpmcounter4_r 		<= #1 32'h00;
		mhpmcounter5_r 		<= #1 32'h00;
		mhpmcounter6_r 		<= #1 32'h00;
		mhpmcounter7_r 		<= #1 32'h00;
		mhpmcounter8_r 		<= #1 32'h00;
		mhpmcounter9_r 		<= #1 32'h00;
		mhpmcounter10_r 	<= #1 32'h00;
		mhpmcounter11_r 	<= #1 32'h00;
		mhpmcounter12_r 	<= #1 32'h00;
		mhpmcounter13_r 	<= #1 32'h00;
		mhpmcounter14_r 	<= #1 32'h00;
		mhpmcounter15_r 	<= #1 32'h00;
		mhpmcounter16_r 	<= #1 32'h00;
		mhpmcounter17_r 	<= #1 32'h00;
		mhpmcounter18_r 	<= #1 32'h00;
		mhpmcounter19_r 	<= #1 32'h00;
		mhpmcounter20_r 	<= #1 32'h00;
		mhpmcounter21_r 	<= #1 32'h00;
		mhpmcounter22_r 	<= #1 32'h00;
		mhpmcounter23_r 	<= #1 32'h00;
		mhpmcounter24_r 	<= #1 32'h00;
		mhpmcounter25_r 	<= #1 32'h00;
		mhpmcounter26_r 	<= #1 32'h00;
		mhpmcounter27_r 	<= #1 32'h00;
		mhpmcounter28_r 	<= #1 32'h00;
		mhpmcounter29_r 	<= #1 32'h00;
		mhpmcounter30_r 	<= #1 32'h00;
		mhpmcounter31_r 	<= #1 32'h00;
//		mcycleh_r	 	<= #1 32'h00;
//		minstreth_r 		<= #1 32'h00;
		mhpmcounter3h_r 	<= #1 32'h00;
		mhpmcounter4h_r 	<= #1 32'h00;
		mhpmcounter5h_r 	<= #1 32'h00;
		mhpmcounter6h_r 	<= #1 32'h00;
		mhpmcounter7h_r 	<= #1 32'h00;
		mhpmcounter8h_r 	<= #1 32'h00;
		mhpmcounter9h_r 	<= #1 32'h00;
		mhpmcounter10h_r 	<= #1 32'h00;
		mhpmcounter11h_r 	<= #1 32'h00;
		mhpmcounter12h_r 	<= #1 32'h00;
		mhpmcounter13h_r 	<= #1 32'h00;
		mhpmcounter14h_r 	<= #1 32'h00;
		mhpmcounter15h_r 	<= #1 32'h00;
		mhpmcounter16h_r 	<= #1 32'h00;
		mhpmcounter17h_r 	<= #1 32'h00;
		mhpmcounter18h_r 	<= #1 32'h00;
		mhpmcounter19h_r 	<= #1 32'h00;
		mhpmcounter20h_r 	<= #1 32'h00;
		mhpmcounter21h_r 	<= #1 32'h00;
		mhpmcounter22h_r 	<= #1 32'h00;
		mhpmcounter23h_r 	<= #1 32'h00;
		mhpmcounter24h_r 	<= #1 32'h00;
		mhpmcounter25h_r 	<= #1 32'h00;
		mhpmcounter26h_r 	<= #1 32'h00;
		mhpmcounter27h_r 	<= #1 32'h00;
		mhpmcounter28h_r 	<= #1 32'h00;
		mhpmcounter29h_r 	<= #1 32'h00;
		mhpmcounter30h_r 	<= #1 32'h00;
		mhpmcounter31h_r 	<= #1 32'h00;
		
		mcountinhibit_r 	<= #1 32'h00;
		mhpmevent3_r 		<= #1 32'h00;
		mhpmevent4_r 		<= #1 32'h00;
		mhpmevent5_r 		<= #1 32'h00;
		mhpmevent6_r 		<= #1 32'h00;
		mhpmevent7_r 		<= #1 32'h00;
		mhpmevent8_r 		<= #1 32'h00;
		mhpmevent9_r 		<= #1 32'h00;
		mhpmevent10_r 		<= #1 32'h00;
		mhpmevent11_r 		<= #1 32'h00;
		mhpmevent12_r 		<= #1 32'h00;
		mhpmevent13_r 		<= #1 32'h00;
		mhpmevent14_r 		<= #1 32'h00;
		mhpmevent15_r 		<= #1 32'h00;
		mhpmevent16_r 		<= #1 32'h00;
		mhpmevent17_r 		<= #1 32'h00;
		mhpmevent18_r 		<= #1 32'h00;
		mhpmevent19_r 		<= #1 32'h00;
		mhpmevent20_r 		<= #1 32'h00;
		mhpmevent21_r 		<= #1 32'h00;
		mhpmevent22_r 		<= #1 32'h00;
		mhpmevent23_r 		<= #1 32'h00;
		mhpmevent24_r 		<= #1 32'h00;
		mhpmevent25_r 		<= #1 32'h00;
		mhpmevent26_r 		<= #1 32'h00;
		mhpmevent27_r 		<= #1 32'h00;
		mhpmevent28_r 		<= #1 32'h00;
		mhpmevent29_r 		<= #1 32'h00;
		mhpmevent30_r 		<= #1 32'h00;
		mhpmevent31_r 		<= #1 32'h00;
		
		tselect_r		<= #1 32'h00;
		tdata1_r		<= #1 32'h00;	
		tdata2_r		<= #1 32'h00;	
		tdata3_r		<= #1 32'h00;	
		
		dcsr_r	 		<= #1 32'h00;
		dpc_r	 		<= #1 32'h00;
		dscratch0_r 		<= #1 32'h00;
		dscratch1_r 		<= #1 32'h00;

		wr_invalid_r <= #1 0;
	end
	else if (csr_wr_en_i) begin
		if (satp_w			) satp_r	<= #1 csr_data_i;
		else if (stvec_w		) stvec_r	<= #1 csr_data_i;
//		else if (mvendorid_w		) mvendorid_r	<= #1 csr_data_i;
//		else if (marchid_w		) marchid_r  	<= #1 csr_data_i;
//		else if (mimpid_w 		) mimpid_r   	<= #1 csr_data_i;
//		else if (mhartid_w 		) mhartid_r  	<= #1 csr_data_i;      
		else if (misa_w 		) misa_r     	<= #1 csr_data_i;   	
		else if (medeleg_w 		) medeleg_r  	<= #1 csr_data_i;   	
		else if (mideleg_w 		) mideleg_r  	<= #1 csr_data_i;   	
		else if (mie_w 			) mie_r	     	<= #1 csr_data_i;
		else if (mtvec_w 		) mtvec_r    	<= #1 csr_data_i;   	
//		else if (mcounteren_w 		) mcounteren_r	<= #1 csr_data_i;   
		else if (mscratch_w 		) mscratch_r 	<= #1 csr_data_i;
//		else if (mepc_w 		) mepc_r     	<= #1 csr_data_i;
//		else if (mcause_w 		) mcause_r   	<= #1 csr_data_i;
//		else if (mtval_w 		) mtval_r    	<= #1 csr_data_i;
//		else if (mip_w 			) mip_r	     	<= #1 csr_data_i;
		else if (pmpcfg0_w 		) pmpcfg0_r 	<= #1 csr_data_i;
		else if (pmpcfg1_w 		) pmpcfg1_r  	<= #1 csr_data_i;
		else if (pmpcfg2_w 		) pmpcfg2_r  	<= #1 csr_data_i;
		else if (pmpcfg3_w 		) pmpcfg3_r  	<= #1 csr_data_i;
		else if (pmpaddr0_w 		) pmpaddr0_r 	<= #1 csr_data_i;
		else if (pmpaddr1_w 		) pmpaddr1_r 	<= #1 csr_data_i;
		else if (pmpaddr2_w 		) pmpaddr2_r 	<= #1 csr_data_i;
		else if (pmpaddr3_w 		) pmpaddr3_r 	<= #1 csr_data_i;
		else if (pmpaddr4_w 		) pmpaddr4_r 	<= #1 csr_data_i;
		else if (pmpaddr5_w 		) pmpaddr5_r 	<= #1 csr_data_i;
		else if (pmpaddr6_w 		) pmpaddr6_r 	<= #1 csr_data_i;
		else if (pmpaddr7_w 		) pmpaddr7_r 	<= #1 csr_data_i;
		else if (pmpaddr8_w 		) pmpaddr8_r 	<= #1 csr_data_i;
		else if (pmpaddr9_w 		) pmpaddr9_r 	<= #1 csr_data_i;
		else if (pmpaddr10_w 		) pmpaddr10_r	<= #1 csr_data_i;
		else if (pmpaddr11_w 		) pmpaddr11_r	<= #1 csr_data_i;
		else if (pmpaddr12_w 		) pmpaddr12_r	<= #1 csr_data_i;
		else if (pmpaddr13_w 		) pmpaddr13_r	<= #1 csr_data_i;
		else if (pmpaddr14_w 		) pmpaddr14_r	<= #1 csr_data_i;
		else if (pmpaddr15_w 		) pmpaddr15_r	<= #1 csr_data_i;
//		else if (mcycle_w 		) mcycle_r	 	<= #1 csr_data_i;
//		else if (minstret_w 		) minstret_r	  	<= #1 csr_data_i;
//		else if (mhpmcounter3_w 	) mhpmcounter3_r  	<= #1 csr_data_i;
//		else if (mhpmcounter4_w 	) mhpmcounter4_r  	<= #1 csr_data_i;
//		else if (mhpmcounter5_w 	) mhpmcounter5_r  	<= #1 csr_data_i;
//		else if (mhpmcounter6_w 	) mhpmcounter6_r  	<= #1 csr_data_i;
//		else if (mhpmcounter7_w 	) mhpmcounter7_r  	<= #1 csr_data_i;
//		else if (mhpmcounter8_w 	) mhpmcounter8_r  	<= #1 csr_data_i;
//		else if (mhpmcounter9_w 	) mhpmcounter9_r  	<= #1 csr_data_i;
//		else if (mhpmcounter10_w 	) mhpmcounter10_r 	<= #1 csr_data_i;
//		else if (mhpmcounter11_w 	) mhpmcounter11_r 	<= #1 csr_data_i;
//		else if (mhpmcounter12_w 	) mhpmcounter12_r 	<= #1 csr_data_i;
//		else if (mhpmcounter13_w 	) mhpmcounter13_r 	<= #1 csr_data_i;
//		else if (mhpmcounter14_w 	) mhpmcounter14_r 	<= #1 csr_data_i;
//		else if (mhpmcounter15_w 	) mhpmcounter15_r 	<= #1 csr_data_i;
//		else if (mhpmcounter16_w 	) mhpmcounter16_r 	<= #1 csr_data_i;
//		else if (mhpmcounter17_w 	) mhpmcounter17_r 	<= #1 csr_data_i;
//		else if (mhpmcounter18_w 	) mhpmcounter18_r 	<= #1 csr_data_i;
//		else if (mhpmcounter19_w 	) mhpmcounter19_r 	<= #1 csr_data_i;
//		else if (mhpmcounter20_w 	) mhpmcounter20_r 	<= #1 csr_data_i;
//		else if (mhpmcounter21_w 	) mhpmcounter21_r 	<= #1 csr_data_i;
//		else if (mhpmcounter22_w 	) mhpmcounter22_r 	<= #1 csr_data_i;
//		else if (mhpmcounter23_w 	) mhpmcounter23_r 	<= #1 csr_data_i;
//		else if (mhpmcounter24_w 	) mhpmcounter24_r 	<= #1 csr_data_i;
//		else if (mhpmcounter25_w 	) mhpmcounter25_r 	<= #1 csr_data_i;
//		else if (mhpmcounter26_w 	) mhpmcounter26_r 	<= #1 csr_data_i;
//		else if (mhpmcounter27_w 	) mhpmcounter27_r 	<= #1 csr_data_i;
//		else if (mhpmcounter28_w 	) mhpmcounter28_r 	<= #1 csr_data_i;
//		else if (mhpmcounter29_w 	) mhpmcounter29_r 	<= #1 csr_data_i;
//		else if (mhpmcounter30_w 	) mhpmcounter30_r 	<= #1 csr_data_i;
//		else if (mhpmcounter31_w 	) mhpmcounter31_r 	<= #1 csr_data_i;
//		else if (mcycleh_w	 	) mcycleh_r	  	<= #1 csr_data_i;
//		else if (minstreth_w 		) minstreth_r	  	<= #1 csr_data_i;
//		else if (mhpmcounter3h_w 	) mhpmcounter3h_r 	<= #1 csr_data_i;
//		else if (mhpmcounter4h_w 	) mhpmcounter4h_r 	<= #1 csr_data_i;
//		else if (mhpmcounter5h_w 	) mhpmcounter5h_r 	<= #1 csr_data_i;
//		else if (mhpmcounter6h_w 	) mhpmcounter6h_r 	<= #1 csr_data_i;
//		else if (mhpmcounter7h_w 	) mhpmcounter7h_r 	<= #1 csr_data_i;
//		else if (mhpmcounter8h_w 	) mhpmcounter8h_r 	<= #1 csr_data_i;
//		else if (mhpmcounter9h_w 	) mhpmcounter9h_r 	<= #1 csr_data_i;
//		else if (mhpmcounter10h_w 	) mhpmcounter10h_r	<= #1 csr_data_i;
//		else if (mhpmcounter11h_w 	) mhpmcounter11h_r	<= #1 csr_data_i;
//		else if (mhpmcounter12h_w 	) mhpmcounter12h_r	<= #1 csr_data_i;
//		else if (mhpmcounter13h_w 	) mhpmcounter13h_r	<= #1 csr_data_i;
//		else if (mhpmcounter14h_w 	) mhpmcounter14h_r	<= #1 csr_data_i;
//		else if (mhpmcounter15h_w 	) mhpmcounter15h_r	<= #1 csr_data_i;
//		else if (mhpmcounter16h_w 	) mhpmcounter16h_r	<= #1 csr_data_i;
//		else if (mhpmcounter17h_w 	) mhpmcounter17h_r	<= #1 csr_data_i;
//		else if (mhpmcounter18h_w 	) mhpmcounter18h_r	<= #1 csr_data_i;
//		else if (mhpmcounter19h_w 	) mhpmcounter19h_r	<= #1 csr_data_i;
//		else if (mhpmcounter20h_w 	) mhpmcounter20h_r	<= #1 csr_data_i;
//		else if (mhpmcounter21h_w 	) mhpmcounter21h_r	<= #1 csr_data_i;
//		else if (mhpmcounter22h_w 	) mhpmcounter22h_r	<= #1 csr_data_i;
//		else if (mhpmcounter23h_w 	) mhpmcounter23h_r	<= #1 csr_data_i;
//		else if (mhpmcounter24h_w 	) mhpmcounter24h_r	<= #1 csr_data_i;
//		else if (mhpmcounter25h_w 	) mhpmcounter25h_r	<= #1 csr_data_i;
//		else if (mhpmcounter26h_w 	) mhpmcounter26h_r	<= #1 csr_data_i;
//		else if (mhpmcounter27h_w 	) mhpmcounter27h_r	<= #1 csr_data_i;
//		else if (mhpmcounter28h_w 	) mhpmcounter28h_r	<= #1 csr_data_i;
//		else if (mhpmcounter29h_w 	) mhpmcounter29h_r	<= #1 csr_data_i;
//		else if (mhpmcounter30h_w 	) mhpmcounter30h_r	<= #1 csr_data_i;
//		else if (mhpmcounter31h_w 	) mhpmcounter31h_r	<= #1 csr_data_i;
//		else if (mcountinhibit_w 	) mcountinhibit_r	<= #1 csr_data_i;
//		else if (mhpmevent3_w 		) mhpmevent3_r		<= #1 csr_data_i;
//		else if (mhpmevent4_w 		) mhpmevent4_r		<= #1 csr_data_i;
//		else if (mhpmevent5_w 		) mhpmevent5_r		<= #1 csr_data_i;
//		else if (mhpmevent6_w 		) mhpmevent6_r		<= #1 csr_data_i;
//		else if (mhpmevent7_w 		) mhpmevent7_r		<= #1 csr_data_i;
//		else if (mhpmevent8_w 		) mhpmevent8_r		<= #1 csr_data_i;
//		else if (mhpmevent9_w 		) mhpmevent9_r		<= #1 csr_data_i;
//		else if (mhpmevent10_w 		) mhpmevent10_r		<= #1 csr_data_i;
//		else if (mhpmevent11_w 		) mhpmevent11_r		<= #1 csr_data_i;
//		else if (mhpmevent12_w 		) mhpmevent12_r		<= #1 csr_data_i;
//		else if (mhpmevent13_w 		) mhpmevent13_r		<= #1 csr_data_i;
//		else if (mhpmevent14_w 		) mhpmevent14_r		<= #1 csr_data_i;
//		else if (mhpmevent15_w 		) mhpmevent15_r		<= #1 csr_data_i;
//		else if (mhpmevent16_w 		) mhpmevent16_r		<= #1 csr_data_i;
//		else if (mhpmevent17_w 		) mhpmevent17_r		<= #1 csr_data_i;
//		else if (mhpmevent18_w 		) mhpmevent18_r		<= #1 csr_data_i;
//		else if (mhpmevent19_w 		) mhpmevent19_r		<= #1 csr_data_i;
//		else if (mhpmevent20_w 		) mhpmevent20_r		<= #1 csr_data_i;
//		else if (mhpmevent21_w 		) mhpmevent21_r		<= #1 csr_data_i;
//		else if (mhpmevent22_w 		) mhpmevent22_r		<= #1 csr_data_i;
//		else if (mhpmevent23_w 		) mhpmevent23_r		<= #1 csr_data_i;
//		else if (mhpmevent24_w 		) mhpmevent24_r		<= #1 csr_data_i;
//		else if (mhpmevent25_w 		) mhpmevent25_r		<= #1 csr_data_i;
//		else if (mhpmevent26_w 		) mhpmevent26_r		<= #1 csr_data_i;
//		else if (mhpmevent27_w 		) mhpmevent27_r		<= #1 csr_data_i;
//		else if (mhpmevent28_w 		) mhpmevent28_r		<= #1 csr_data_i;
//		else if (mhpmevent29_w 		) mhpmevent29_r		<= #1 csr_data_i;
//		else if (mhpmevent30_w 		) mhpmevent30_r		<= #1 csr_data_i;
//		else if (mhpmevent31_w 		) mhpmevent31_r		<= #1 csr_data_i;
//		else if (tselect_w	 	) tselect_r		<= #1 csr_data_i;
//		else if (tdata1_w	 	) tdata1_r		<= #1 csr_data_i;
//		else if (tdata2_w	 	) tdata2_r		<= #1 csr_data_i;
//		else if (tdata3_w	 	) tdata3_r		<= #1 csr_data_i;
//		else if (dcsr_w	 		) dcsr_r		<= #1 csr_data_i;
//		else if (dpc_w	 		) dpc_r			<= #1 csr_data_i;
//		else if (dscratch0_w 		) dscratch0_r		<= #1 csr_data_i;
//		else if (dscratch1_w 		) dscratch1_r		<= #1 csr_data_i;

		else if (mhartid_w) wr_invalid_r <= #1 1;
	end
	else begin
		wr_invalid_r <= #1 0;
	end
end

wire [31:0] csr_mreg_o =  (stvec_w	) ? stvec_r

			: (satp_w	) ? satp_r

			: (mvendorid_w	) ? mvendorid_r
			: (marchid_w	) ? marchid_r
			: (mimpid_w 	) ? mimpid_r
			: (mhartid_w 	) ? mhartid_r	
			                    	          
			: (mstatus_w 	) ? mstatus_r & MSTATUS_RD_MASK	     	
			: (misa_w 	) ? misa_r	     	
			: (medeleg_w 	) ? medeleg_r	     	
			: (mideleg_w 	) ? mideleg_r	     	
			: (mie_w 	) ? mie_r	     	
			: (mtvec_w 	) ? mtvec_r	     	
			: (mcounteren_w ) ? mcounteren_r	     
			
			: (mscratch_w 	) ? mscratch_r
			: (mepc_w 	) ? mepc_r
			: (mcause_w 	) ? mcause_r
			: (mtval_w 	) ? mtval_r
			: (mip_w 	) ? mip_r
				
			: (pmpcfg0_w 	) ? pmpcfg0_r
			: (pmpcfg1_w 	) ? pmpcfg1_r
			: (pmpcfg2_w 	) ? pmpcfg2_r
			: (pmpcfg3_w 	) ? pmpcfg3_r
			: (pmpaddr0_w 	) ? pmpaddr0_r
			: (pmpaddr1_w 	) ? pmpaddr1_r
			: (pmpaddr2_w 	) ? pmpaddr2_r
			: (pmpaddr3_w 	) ? pmpaddr3_r
			: (pmpaddr4_w 	) ? pmpaddr4_r
			: (pmpaddr5_w 	) ? pmpaddr5_r
			: (pmpaddr6_w 	) ? pmpaddr6_r
			: (pmpaddr7_w 	) ? pmpaddr7_r
			: (pmpaddr8_w 	) ? pmpaddr8_r
			: (pmpaddr9_w 	) ? pmpaddr9_r
			: (pmpaddr10_w 	) ? pmpaddr10_r
			: (pmpaddr11_w 	) ? pmpaddr11_r
			: (pmpaddr12_w 	) ? pmpaddr12_r
			: (pmpaddr13_w 	) ? pmpaddr13_r
			: (pmpaddr14_w 	) ? pmpaddr14_r
			: (pmpaddr15_w 	) ? pmpaddr15_r
			
			: (mcycle_w 		) ? cycle_r
			: (minstret_w 		) ? instret_r
			: (mhpmcounter3_w 	) ? mhpmcounter3_r
			: (mhpmcounter4_w 	) ? mhpmcounter4_r
			: (mhpmcounter5_w 	) ? mhpmcounter5_r
			: (mhpmcounter6_w 	) ? mhpmcounter6_r
			: (mhpmcounter7_w 	) ? mhpmcounter7_r
			: (mhpmcounter8_w 	) ? mhpmcounter8_r
			: (mhpmcounter9_w 	) ? mhpmcounter9_r
			: (mhpmcounter10_w 	) ? mhpmcounter10_r
			: (mhpmcounter11_w 	) ? mhpmcounter11_r
			: (mhpmcounter12_w 	) ? mhpmcounter12_r
			: (mhpmcounter13_w 	) ? mhpmcounter13_r
			: (mhpmcounter14_w 	) ? mhpmcounter14_r
			: (mhpmcounter15_w 	) ? mhpmcounter15_r
			: (mhpmcounter16_w 	) ? mhpmcounter16_r
			: (mhpmcounter17_w 	) ? mhpmcounter17_r
			: (mhpmcounter18_w 	) ? mhpmcounter18_r
			: (mhpmcounter19_w 	) ? mhpmcounter19_r
			: (mhpmcounter20_w 	) ? mhpmcounter20_r
			: (mhpmcounter21_w 	) ? mhpmcounter21_r
			: (mhpmcounter22_w 	) ? mhpmcounter22_r
			: (mhpmcounter23_w 	) ? mhpmcounter23_r
			: (mhpmcounter24_w 	) ? mhpmcounter24_r
			: (mhpmcounter25_w 	) ? mhpmcounter25_r
			: (mhpmcounter26_w 	) ? mhpmcounter26_r
			: (mhpmcounter27_w 	) ? mhpmcounter27_r
			: (mhpmcounter28_w 	) ? mhpmcounter28_r
			: (mhpmcounter29_w 	) ? mhpmcounter29_r
			: (mhpmcounter30_w 	) ? mhpmcounter30_r
			: (mhpmcounter31_w 	) ? mhpmcounter31_r
			: (mcycleh_w	 	) ? cycleh_r
			: (minstreth_w 		) ? instreth_r
			: (mhpmcounter3h_w 	) ? mhpmcounter3h_r
			: (mhpmcounter4h_w 	) ? mhpmcounter4h_r
			: (mhpmcounter5h_w 	) ? mhpmcounter5h_r
			: (mhpmcounter6h_w 	) ? mhpmcounter6h_r
			: (mhpmcounter7h_w 	) ? mhpmcounter7h_r
			: (mhpmcounter8h_w 	) ? mhpmcounter8h_r
			: (mhpmcounter9h_w 	) ? mhpmcounter9h_r
			: (mhpmcounter10h_w 	) ? mhpmcounter10h_r
			: (mhpmcounter11h_w 	) ? mhpmcounter11h_r
			: (mhpmcounter12h_w 	) ? mhpmcounter12h_r
			: (mhpmcounter13h_w 	) ? mhpmcounter13h_r
			: (mhpmcounter14h_w 	) ? mhpmcounter14h_r
			: (mhpmcounter15h_w 	) ? mhpmcounter15h_r
			: (mhpmcounter16h_w 	) ? mhpmcounter16h_r
			: (mhpmcounter17h_w 	) ? mhpmcounter17h_r
			: (mhpmcounter18h_w 	) ? mhpmcounter18h_r
			: (mhpmcounter19h_w 	) ? mhpmcounter19h_r
			: (mhpmcounter20h_w 	) ? mhpmcounter20h_r
			: (mhpmcounter21h_w 	) ? mhpmcounter21h_r
			: (mhpmcounter22h_w 	) ? mhpmcounter22h_r
			: (mhpmcounter23h_w 	) ? mhpmcounter23h_r
			: (mhpmcounter24h_w 	) ? mhpmcounter24h_r
			: (mhpmcounter25h_w 	) ? mhpmcounter25h_r
			: (mhpmcounter26h_w 	) ? mhpmcounter26h_r
			: (mhpmcounter27h_w 	) ? mhpmcounter27h_r
			: (mhpmcounter28h_w 	) ? mhpmcounter28h_r
			: (mhpmcounter29h_w 	) ? mhpmcounter29h_r
			: (mhpmcounter30h_w 	) ? mhpmcounter30h_r
			: (mhpmcounter31h_w 	) ? mhpmcounter31h_r
			
			: (mcountinhibit_w 	) ? mcountinhibit_r
			: (mhpmevent3_w 	) ? mhpmevent3_r	
			: (mhpmevent4_w 	) ? mhpmevent4_r	
			: (mhpmevent5_w 	) ? mhpmevent5_r	
			: (mhpmevent6_w 	) ? mhpmevent6_r	
			: (mhpmevent7_w 	) ? mhpmevent7_r	
			: (mhpmevent8_w 	) ? mhpmevent8_r	
			: (mhpmevent9_w 	) ? mhpmevent9_r	
			: (mhpmevent10_w 	) ? mhpmevent10_r
			: (mhpmevent11_w 	) ? mhpmevent11_r
			: (mhpmevent12_w 	) ? mhpmevent12_r	
			: (mhpmevent13_w 	) ? mhpmevent13_r	
			: (mhpmevent14_w 	) ? mhpmevent14_r	
			: (mhpmevent15_w 	) ? mhpmevent15_r	
			: (mhpmevent16_w 	) ? mhpmevent16_r	
			: (mhpmevent17_w 	) ? mhpmevent17_r	
			: (mhpmevent18_w 	) ? mhpmevent18_r	
			: (mhpmevent19_w 	) ? mhpmevent19_r	
			: (mhpmevent20_w 	) ? mhpmevent20_r	
			: (mhpmevent21_w 	) ? mhpmevent21_r	
			: (mhpmevent22_w 	) ? mhpmevent22_r	
			: (mhpmevent23_w 	) ? mhpmevent23_r	
			: (mhpmevent24_w 	) ? mhpmevent24_r	
			: (mhpmevent25_w 	) ? mhpmevent25_r	
			: (mhpmevent26_w 	) ? mhpmevent26_r	
			: (mhpmevent27_w 	) ? mhpmevent27_r	
			: (mhpmevent28_w 	) ? mhpmevent28_r	
			: (mhpmevent29_w 	) ? mhpmevent29_r	
			: (mhpmevent30_w 	) ? mhpmevent30_r	
			: (mhpmevent31_w 	) ? mhpmevent31_r	
		
			: (tselect_w	 	) ? tselect_r	
			: (tdata1_w	 	) ? tdata1_r	
			: (tdata2_w	 	) ? tdata2_r	
			: (tdata3_w	 	) ? tdata3_r	
			
			: (dcsr_w	 	) ? dcsr_r	
			: (dpc_w	 	) ? dpc_r	
			: (dscratch0_w 		) ? dscratch0_r	
			: (dscratch1_w 		) ? dscratch1_r	

			: 32'h00;

