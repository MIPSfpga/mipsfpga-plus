/*
 * Copyright 2014-2015, Imagination Technologies Limited and/or its
 *                      affiliated group companies.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
*/

# Keep each function in a separate named section
#define _FUNCTION_SECTIONS_
.set nomips16

#include <mips/asm.h>
#include <mips/regdef.h>
#include <mips/cpu.h>
#include <mips/hal.h>

LEAF(__exception_entry)
	.set	push
	.set	noat
.weak   _mips_tlb_refill
__tlb_refill_loop:
	LA	k1, _mips_tlb_refill
	beqz	k1, __tlb_refill_loop
	jr	k1

	.org 0x80
.weak   _mips_xtlb_refill
__xtlb_refill_loop:
	LA	k1, _mips_xtlb_refill
	beqz	k1, __xtlb_refill_loop
	jr	k1

	.org 0x100
.weak   _mips_cache_error
__cache_error_loop:
	LA	k1, _mips_cache_error
	beqz	k1, __cache_error_loop
	jr	k1

	.org 0x180
.weak _mips_general_exception
__general_exception_loop:
	LA	k1, _mips_general_exception
	beqz    k1, __general_exception_loop
	jr	k1
	.set    pop
END(__exception_entry)
