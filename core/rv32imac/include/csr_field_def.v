//-------------------------------------------------------------------
// CSR Field Define
//-------------------------------------------------------------------
`define M_MODE	2'b11
`define S_MODE	2'b01
`define U_MODE	2'b00


`define	MPP	12:11
`define	SPP	8

// Exceptions Define
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
