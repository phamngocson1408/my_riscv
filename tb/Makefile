########################################################################
## Tool paths
########################################################################
TAR_DIR = test_vector

# Tool
CC = riscv32-unknown-elf-gcc

# Options
OPTS = -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles
OPTS += -T $(TAR_DIR)/link.ld

########################################################################
## Makefile
########################################################################
all: $(TAR_DIR)/*.s
	mkdir -p $(TAR_DIR)
	${CC} ${OPTS}  $< -o $(TAR_DIR)/test_vector
	elf2hex 4 32768 test_vector/test_vector > test_vector/test_vector.hex
	riscv32-unknown-elf-objdump --disassemble-all --disassemble-zeroes test_vector/test_vector > test_vector/test_vector.dump
	vcs -full64 -debug_all +warn=noRWSI -file RUN.cmd
	./simv
