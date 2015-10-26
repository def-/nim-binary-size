/* Custom ELF header for the binary.
 * Inspired by http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html
 * via https://github.com/kmcallister/tiny-rust-demo
 * via https://github.com/def-/nim-binary-size */

.globl ehdr

ehdr:
	.byte	0x7f, 0x45, 0x4C, 0x46
	.byte	0x02, 0x01, 0x01, 0x00

	/* This padding is a perfect place to put a string constant! */
	.asciz "Hello!\n"	/* must be *exactly* 8 bytes long */

	.short	2		/* e_type = executable */
	.short	62	/* e_machine */
	.long	1		/* e_version */
	.quad	_start		/* e_entry */
	.quad	phdr-ehdr	/* e_phoff */
	.quad	0		/* e_shoff */
	.long	0		/* e_flags */
	.short	ehdrsize	/* e_ehsize */
	.short	phdrsize	/* e_phentsize */

phdr:
	.long	1		/* p_type = loadable program segment & e_phnum,e_sh* */
	.long	7		/* p_flags = rwx */
	.quad	0		/* p_offset */
	.quad	orig		/* p_vaddr */
	.quad	orig		/* p_paddr */
	.quad	filesize	/* p_filesz */
	.quad	filesize	/* p_memsz */
	.quad	0x1000		/* p_align */

.equ ehdrsize, phdr-ehdr+8 /* including phdr overlap */
.equ phdrsize, .-phdr
