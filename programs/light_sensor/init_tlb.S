/*
 * init_tlb.S
 *
 *  Created on: Jan 12, 2011
 *  Author: MIPS TECHNOLOGIES, INC
 *  Common TLB initialization for MIPS cores
*/
/*
Copyright (c) 2014, Imagination Technologies LLC and Imagination Technologies
Limited.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions in binary form must be built to execute on machines
   implementing the MIPS32(R), MIPS64 and/or microMIPS instruction set
   architectures.

2. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

4. Neither the name of Imagination Technologies LLC, Imagination Technologies Limited
   nor the names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL IMAGINATION TECHNOLOGIES LLC OR IMAGINATION
TECHNOLOGIES LIMITED BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.
*/

#define _BOOTCODE 1

#include "boot.h"
#include <mips/regdef.h>
#include <mips/asm.h>
#include <mips/m32c0.h>

	.set	noreorder           // Don't allow the assembler to reorder instructions.
	.set	noat                // Don't allow the assembler to use r1(at) for synthetic instr.
/**************************************************************************************
**************************************************************************************/
LEAF(init_tlb)

check_for_tlb:
	// Determine if we have a TLB
	mfc0    v1, C0_CONFIG			// read C0_Config
	ext	    v1, v1, 7, 3			// extract MT field
	li	    a3, 0x1					// load a 1 to check against
	bne	    v1, a3, done_init_tlb
	mfc0    v0, C0_CONFIG1			// C0_Config1
	nop

start_init_tlb:
	// Config1MMUSize == Number of TLB entries - 1
	ext     v1, v0, CFG1_MMUSSHIFT, 6 // extract MMU Size
	mtc0    zero, C0_ENTRYLO0		// write C0_EntryLo0
	mtc0    zero, C0_ENTRYLO1		// write C0_EntryLo1
	mtc0    zero, C0_PAGEMASK		// write C0_PageMask
	mtc0    zero, C0_WIRED			// write C0_Wired
	li	    a0, 0x80000000

next_tlb_entry_pair:
	mtc0    v1, C0_INDEX			// write C0_Index
	mtc0	a0, C0_ENTRYHI			// write C0_EntryHi
	ehb
	tlbwi
	add	    a0, (2<<13)				// Add 8K to the address to avoid TLB conflict with previous entry

	bne		v1, zero, next_tlb_entry_pair
	add	    v1, -1

done_init_tlb:
    jr      ra
    nop
END(init_tlb)
