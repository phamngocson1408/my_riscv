 .align 6
 .section .text
 # screw boot code, we're going minimalist
 # mtohost is the CSR in machine mode
# lui sp,0x5
# auipc a0,0x1000
# jal ra,0x2000
# jalr ra,sp,0x2

# li	ra,2050
# li	sp,-1000
# beq	ra,sp,2114

# LB -----------------
# li	ra,1 		#load 1 to x1
# lb	sp,1(ra)	#x2 = *(x1 + 1)
# li	ra,2050

# LH -----------------
# li	ra,1 		#load 1 to x1
# lh	sp,2(ra)	#x2 = *(x1 + 1)
# li	ra,2050

# LW -----------------
# li	ra,1 		#load 1 to x1
# lw	sp,2(ra)	#x2 = *(x1 + 1)
# li	ra,2050

# SB -----------------
# li	ra,1 		#load 1 to x1
# li	sp,0x1234	#load 0x1234 to x2
# sb	sp,5(ra)	# mem8[x1 + 5] = x2
# lb	sp,5(ra)	# x2 = mem8[x1 + 5]

# SH -----------------
# li	ra,1 		#load 1 to x1
# li	sp,0x12345678	#load 0x12345678 to x2
# sh	sp,5(ra)	# mem16[x1 + 5] = x2
# lh	sp,5(ra)	# x2 = mem16[x1 + 5]

# SW -----------------
# li	ra,1 		#load 1 to x1
# li	sp,0x12345678	#load 0x12345678 to x2
# sw	sp,5(ra)	# mem32[x1 + 5] = x2
# lw	sp,5(ra)	# x2 = mem32[x1 + 5]

# reg + imm -----------------
# li	ra,1234		# load 1234 to x1
# addi	sp,ra,1234	# x2 = x1 + 1234	

# li	ra,1234		# load 1234 to x1
# slti	sp,ra,1235	# x2 = x1 < 1235	
# slti	sp,ra,1233	# x2 = x1 < 1235	

# li	ra,-1234	# load -1234 to x1
# slti	sp,ra,-1235	# x2 = x1 < 1235	
# slti	sp,ra,-1233	# x2 = x1 < 1233	

# li	ra,1234		# load 1234 to x1
# sltiu	sp,ra,1235	# x2 = x1 < 1235	
# sltiu	sp,ra,1233	# x2 = x1 < 1235	

# li	ra,0x1234		# load 1234 to x1
# xori	sp,ra,0x1234	# x2 = x1 xor 1235	
# ori	sp,ra,0x1235	# x2 = x1 or 1235	
# andi	sp,ra,0x1235	# x2 = x1 and 1235	

# li	ra,0x1234		# load 0x1234 to x1
# slli	sp,ra,4		# x2 = x1 << 4	
# srli	sp,ra,4		# x2 = x1 >> 4	

# li	ra,-0x1234		# load 0x1234 to x1
# srai	sp,ra,4		# x2 = x1 >> 4	

# reg + reg -----------------
.global main
main:
 li	ra,0x1		# load 0x1 to x1
 li	sp,0x3		# load 0x2 to x2
# add	gp,ra,sp	# x3 = x1 + x2
# sub	gp,ra,sp	# x3 = x1 - x2
# sll	gp,ra,4		# x2 = x1 << 4	
# srl	gp,ra,4		# x2 = x1 >> 4	
 slt	gp,ra,sp	# x3 = x1 < x2
 sltu	gp,ra,sp	# x3 = x1 < x2
 xor	gp,ra,sp	# x3 = x1 xor x2
 or	gp,ra,sp	# x3 = x1 or x2
 and	gp,ra,sp	# x3 = x1 and x2
