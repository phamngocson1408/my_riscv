
// Supervisor Trap Setup
wire sstatus_w 		= csr_addr_i == 12'h100;
wire sedeleg_w 		= csr_addr_i == 12'h102;
wire sideleg_w 		= csr_addr_i == 12'h103;
wire sie_w 		= csr_addr_i == 12'h104;
wire stvec_w 		= csr_addr_i == 12'h105;
wire scounteren_w	= csr_addr_i == 12'h106;

// User Trap Handling
wire sscratch_w 	= csr_addr_i == 12'h140;
wire sepc_w 		= csr_addr_i == 12'h141;
wire scause_w 		= csr_addr_i == 12'h142;
wire stval_w 		= csr_addr_i == 12'h143;
wire sip_w 		= csr_addr_i == 12'h144;

// Supervisor protection and translation
wire satp_w		= csr_addr_i == 12'h180;

// Supervisor Trap Setup
//reg [31:0] sstatus_r 	;
reg [31:0] sedeleg_r 	;
reg [31:0] sideleg_r 	;
reg [31:0] sie_r 	;
reg [31:0] stvec_r 	;
reg [31:0] scounteren_r	;

// User Trap Handling
reg [31:0] sscratch_r 	;
reg [31:0] sepc_r 	;
reg [31:0] scause_r 	;
reg [31:0] stval_r 	;
reg [31:0] sip_r 	;

// Supervisor protection and translation
reg [31:0] satp_r;

always @(posedge clk_i) begin
	if (rst_i) begin
		sedeleg_r     	<= #1 32'h00;
		sideleg_r     	<= #1 32'h00;
		sie_r     	<= #1 32'h00;
		stvec_r   	<= #1 32'h00;
		scounteren_r   	<= #1 32'h00;
		
		sscratch_r 	<= #1 32'h00;
		sepc_r     	<= #1 32'h00; 
		scause_r     	<= #1 32'h00; 
		stval_r    	<= #1 32'h00;
		sip_r      	<= #1 32'h00;

		satp_r      	<= #1 32'h00;
	end
	else if (csr_wr_en_i) begin
		if (sedeleg_w		) sedeleg_r		<= #1 csr_data_i;
		else if (sideleg_w	) sideleg_r		<= #1 csr_data_i;
		else if (sie_w 		) sie_r	     		<= #1 csr_data_i;
		else if (stvec_w 	) stvec_r    		<= #1 csr_data_i;   	
		else if (scounteren_w 	) scounteren_r 		<= #1 csr_data_i;   	

		else if (sscratch_w 	) sscratch_r 		<= #1 csr_data_i;
		else if (sepc_w 	) sepc_r     		<= #1 csr_data_i;
//		else if (scause_w 	) scause_r   		<= #1 csr_data_i;
//		else if (stval_w 	) stval_r    		<= #1 csr_data_i;
//		else if (sip_w 		) sip_r	     		<= #1 csr_data_i;

//		else if (satp_w 	) satp_r     		<= #1 csr_data_i;
	end
end

wire [31:0] csr_sreg_o =  (sstatus_w	) ? mstatus_r & SSTATUS_RD_MASK
			: (sedeleg_w 	) ? sedeleg_r	     	
			: (sideleg_w 	) ? sideleg_r	     	
			: (sie_w 	) ? sie_r	     	
			: (stvec_w 	) ? stvec_r	     	
			: (scounteren_w	) ? scounteren_r	     	
			
			: (sscratch_w 	) ? sscratch_r
			: (sepc_w 	) ? sepc_r
			: (scause_w 	) ? scause_r
			: (stval_w 	) ? stval_r
			: (sip_w 	) ? sip_r
				
			: (satp_w	) ? satp_r

			: 32'h00;

