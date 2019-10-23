 OUTPUT_ARCH( "riscv" )
 ENTRY( _start )
 SECTIONS
 {
 /* text: test code section */
 . = 0x0000;
 .text :
 {
 *(.text)
 }
 /* data: Initialized data segment */
 . = 0x0030;
 .data :
 {
 *(.data)
 }
 .rodata :
 {
 *(.rodata)
 }

 /* End of uninitalized data segement */
 _end = .;
 }
