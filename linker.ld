ENTRY(main)

MEMORY {
  ram (rwx) : ORIGIN = 0x00000000, LENGTH = 4K
}

SECTIONS {
  .text : {
    *(.text*)
    *(.rodata*)
  } > ram

  .data : {
    *(.data*)
  } > ram

  .bss : {
    *(.bss*)
    *(COMMON)
  } > ram
}
