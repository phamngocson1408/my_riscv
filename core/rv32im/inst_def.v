//-------------------------------------------------------------------
// Instruction Defines
//-------------------------------------------------------------------
`define	LUI	8'h01
`define	AUIPC	8'h02
`define	JAL	8'h03
`define	JALR	8'h04

`define	BEQ	8'h10
`define	BNE	8'h11
`define	BLT	8'h12
`define	BGE	8'h13
`define	BLTU	8'h14
`define	BGEU	8'h15

`define	LB	8'h20
`define	LH	8'h21
`define	LW	8'h22
`define	LBU	8'h23
`define	LHU	8'h24

`define	SB	8'h30
`define	SH	8'h31
`define	SW	8'h32

`define	ADDI	8'h40
`define	SLTI	8'h41
`define	SLTIU	8'h42
`define	XORI	8'h43
`define	ORI	8'h44
`define	ANDI	8'h45

`define	SLLI	8'h50
`define	SRLI	8'h51
`define	SRAI	8'h52

`define	ADD	8'h60
`define	SUB	8'h61
`define	SLL	8'h62
`define	SLT	8'h63
`define	SLTU	8'h64
`define	XOR	8'h65
`define	SRL	8'h66
`define	SRA	8'h67
`define	OR	8'h68
`define	AND	8'h69

`define	FENCE	8'h70
`define	FENCEI	8'h71
`define	ECALL	8'h72
`define	EBREAK	8'h73

`define	CSRRW	8'h80
`define	CSRRS	8'h81
`define	CSRRC	8'h82
`define	CSRRWI	8'h83
`define	CSRRSI	8'h84
`define	CSRRCI	8'h85

`define MUL	8'h90
`define MULH	8'h91
`define MULHU	8'h92
`define MULHSU	8'h93
`define DIV	8'h94
`define DIVU	8'h95
`define REM	8'h96
`define REMU	8'h97
