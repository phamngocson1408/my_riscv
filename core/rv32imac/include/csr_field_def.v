//-------------------------------------------------------------------
// CSR parameters
//-------------------------------------------------------------------
// Current modes
`define M_MODE	2'b11
`define S_MODE	2'b01
`define U_MODE	2'b00

// Traps Define
`define INST_ADDR_MIS	0
`define INST_ACC_FAULT	1
`define ILL_INST	2
`define BREACKPOINT	3
`define LD_ADDR_MIS	4
`define LD_ACC_FAULT	5
`define ECALL_U_MODE	8
`define ECALL_S_MODE	9
`define ECALL_H_MODE	10
`define ECALL_M_MODE	11
`define MTIMER_INT	32'h8000_0007

// STATUS register fiels
`define	MSTATUS_SD	31
`define	MSTATUS_TSR	22
`define	MSTATUS_TW	21
`define	MSTATUS_TVM	20
`define	MSTATUS_MXR	19
`define	MSTATUS_SUM	18
`define	MSTATUS_MPRV	17
`define	MSTATUS_XS	16:15
`define	MSTATUS_FS	14:13
`define	MSTATUS_MPP	12:11
`define	MSTATUS_SPP	8
`define	MSTATUS_MPIE	7
`define	MSTATUS_SPIE	5
`define	MSTATUS_UPIE	4
`define	MSTATUS_MIE	3
`define	MSTATUS_SIE	1
`define	MSTATUS_UIE	0

// STATUS register masks
parameter MSTATUS_RD_MASK = {
			  1'b1		// SD
			, 8'h00
			, 1'b1		// TSR
			, 1'b1		// TW
			, 1'b1		// TVM
			, 1'b1		// MXR
			, 1'b1		// SUM
			, 1'b1		// MPRV
			, 2'b11		// XS
			, 2'b11		// FS
			, 2'b11		// MPP
			, 2'b00
			, 1'b0		// SPP
			, 1'b1		// MPIE
			, 1'b0
			, 1'b0		// SPIE
			, 1'b0		// UPIE
			, 1'b1		// MIE
			, 1'b0
			, 1'b0		// SIE
			, 1'b0		// UIE
			};

parameter MSTATUS_WR_MASK = {
			  1'b1		// SD
			, 8'h00
			, 1'b1		// TSR
			, 1'b1		// TW
			, 1'b1		// TVM
			, 1'b1		// MXR
			, 1'b1		// SUM
			, 1'b1		// MPRV
			, 2'b11		// XS
			, 2'b11		// FS
			, 2'b11		// MPP
			, 2'b00
			, 1'b0		// SPP
			, 1'b1		// MPIE
			, 1'b0
			, 1'b0		// SPIE
			, 1'b0		// UPIE
			, 1'b1		// MIE
			, 1'b0
			, 1'b0		// SIE
			, 1'b0		// UIE
			};

parameter USTATUS_RD_MASK = {
			  1'b1		// SD
			, 8'h00
			, 1'b1		// TSR
			, 1'b1		// TW
			, 1'b1		// TVM
			, 1'b1		// MXR
			, 1'b1		// SUM
			, 1'b1		// MPRV
			, 2'b11		// XS
			, 2'b11		// FS
			, 2'b00		// MPP
			, 2'b00
			, 1'b0		// SPP
			, 1'b0		// MPIE
			, 1'b0
			, 1'b0		// SPIE
			, 1'b0		// UPIE
			, 1'b0		// MIE
			, 1'b0
			, 1'b0		// SIE
			, 1'b0		// UIE
			};

parameter USTATUS_WR_MASK = {
			  1'b1		// SD
			, 8'h00
			, 1'b1		// TSR
			, 1'b1		// TW
			, 1'b1		// TVM
			, 1'b1		// MXR
			, 1'b1		// SUM
			, 1'b1		// MPRV
			, 2'b11		// XS
			, 2'b11		// FS
			, 2'b00		// MPP
			, 2'b00
			, 1'b0		// SPP
			, 1'b0		// MPIE
			, 1'b0
			, 1'b0		// SPIE
			, 1'b0		// UPIE
			, 1'b0		// MIE
			, 1'b0
			, 1'b0		// SIE
			, 1'b0		// UIE
			};

//`define USTATUS_RD_MASK	32'b00000000_00000011_11000000_00010001
//`define USTATUS_WR_MASK	32'b00000000_00000000_00000000_00010001

// MISA value
parameter MISA_VALUE = {
			  2'b01		// 32 bit
			, 17'h00
			, 1'b1		// M
			, 3'h0
			, 1'b1		// I
			, 5'h00
			, 1'b1		// C
			, 1'b0
			, 1'b1		// A
			};
