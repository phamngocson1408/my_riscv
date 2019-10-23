default:
	riscv32-unknown-elf-gcc -g -ffreestanding -O0 -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,link.ld crt0.s main.s
	riscv32-unknown-elf-objdump -d a.out > a.dump
	elf2hex 1 32768 a.out > a.hex
