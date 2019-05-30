#include <mips/asm.h>
#include <mips/regdef.h>
#include <mips/cpu.h>

/* This is a minimal C runtime initialisation sequence.
   
   The code is designed to execute when the core has been booted (i.e.
   with caches set up) and must prepare a suitable environment for the
   first C code to execute in main.

   Note that in particular no ctors or dtors are run which precludes
   the use of C++.  */

LEAF(_start)
	/* Preserve return address */
	move s0, ra
	/* Set up global pointer for small data access */
	la gp, _gp
	/* Set up stack pointer */
	la sp, __stack
	/* Zero the BSS */
        la v0, _fbss
	la v1, _end
	beq v0,v1,2f
1:
	addiu v0,v0,4
	sw zero,-4(v0)
	bne v0,v1,1b
2:
	/* Set arguments to be null for main */
	li a0, 0
	/* Reserve the o32 ABI required 16 byte argument area */
	addiu sp, sp, -16

        // Clear boot interrupt vector bit in Coprocessor 0 Status register
        // macro: mips32_bicsr (SR_BEV);
        mfc0	v0,C0_STATUS
        ins	v0,zero,0x16,0x1 
        mtc0	v0,C0_STATUS
        ehb

	/* Jump to C code */
	la t0, main
	jalr t0

	/* Return to boot */
	move ra, s0
	jr ra
END(_start)
