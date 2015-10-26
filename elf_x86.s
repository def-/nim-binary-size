/* Custom ELF header for the binary */
/* Inspired by http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html */
/* via https://github.com/kmcallister/tiny-rust-demo */
/* via https://github.com/def-/nim-binary-size */

.globl ehdr

ehdr:
	.byte	0x7f, 0x45, 0x4C, 0x46
	.byte	0x01, 0x01, 0x01, 0x00

	/* This padding is a perfect place to put a string constant! */
	.asciz "Hello!\n"	/* must be *exactly* 8 bytes long */

	.short	2		/* e_type = executable */
	.short	3		/* e_machine */
	.long	1		/* e_version */
	.long	_start		/* e_entry */
	.long	phdr-ehdr	/* e_phoff */
	.long	0		/* e_shoff */
	.long	0		/* e_flags */
	.short	ehdrsize	/* e_ehsize */
	.short	phdrsize	/* e_phentsize */

phdr:
	.long	1		/* p_type = loadable program segment & e_phnum,e_sh* */
	.long	0		/* p_offset */
	.long	orig		/* p_vaddr */
	.long	orig		/* p_paddr */
	.long	filesize	/* p_filesz */
	.long	filesize	/* p_memsz */
	.long	7		/* p_flags */
	.long	0x1000		/* p_align */

.equ ehdrsize, phdr-ehdr+8 /* including phdr overlap */
.equ phdrsize, .-phdr
