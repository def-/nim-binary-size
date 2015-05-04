; Adapted from http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html

    bits 32
    org 0x00400000

ehdr:
    db  0x7F, "ELF"  ; magic
    db 1, 1, 1, 0    ; 32-bits, little endian, version 1

    ; This padding is a perfect place to put a string constant!
    db "Hello!", 0x0A, 0

    dw  2            ; e_type
    dw  3            ; e_machine = x86
    dd  1            ; e_version
    dd  entry        ; e_entry
    dd  phdr - $$    ; e_phoff
    dd  0            ; e_shoff
    dd  0            ; e_flags
    dw  ehdrsize     ; e_ehsize
    dw  phdrsize     ; e_phentsize
    dw  1            ; e_phnum
    dw  0, 0, 0      ; e_sh*

ehdrsize  equ  $ - ehdr

phdr:
    dd  1            ; p_type
    dd  0            ; p_offset
    dd  $$, $$       ; p_vaddr, p_paddr
    dd  filesize     ; p_filesz
    dd  filesize     ; p_memsz
    dd  5            ; p_flags
    dd  0x1000       ; p_align

phdrsize  equ  $ - phdr

incbin "payload.bin"

filesize  equ  $ - ehdr

; vim: ft=tasm
