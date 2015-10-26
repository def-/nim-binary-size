/* With a custom ELF header, this directive has no effect on the resulting
 * ELF entry point. Instead, it's the root for dependency tree ld --gc-sections
 * will use to throw away unreferenced stuff. Setting this to ehdr means
 * the header will be linked, and since it references _start that will be
 * brought in too. */
ENTRY(ehdr)

/* Same origin for all arches */
orig = 0x00400000;

SECTIONS {
	/* ELF header will be in .text but _start will likely be
           in .text._start because of -ffunction-section */
	.text orig : { *(.text*) }
	/* Final size to be used in the header */
	filesize = . - orig;
}
