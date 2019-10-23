OUTPUT_ARCH( "riscv" )
MEMORY
{
 rom (r) : ORIGIN = 0x00000, LENGTH = 1M
 ram (rwx) : ORIGIN = 0x200000, LENGTH = 1M
}
SECTIONS
{
 ENTRY( _start )
 PROVIDE (_stack_top = ORIGIN(ram) + LENGTH(ram));
 /* text: test code section */
 /*. = 0x0000;*/
 .text : { *(.text) } > rom
 /* data: Initialized data segment */
 .data : { *(.data) } > rom
 .bss : { *(.bss) } > ram
 /* End of uninitalized data segement */
 /* _end = .; */
}
