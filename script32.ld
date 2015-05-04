SECTIONS {
    . = 0x400054;

    combined . : AT(0x400054) ALIGN(1) SUBALIGN(1) {
        *(.text*)
        *(.data*)
        *(.rodata*)
        *(.bss*)
    }
}
