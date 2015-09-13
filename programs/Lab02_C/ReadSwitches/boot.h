/*
 * boot.h
 *
 *  Created on: Jan 12, 2011
 *      Author: MIPS TECHNOLOGIES, INC
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

/**************************************************************************************
 Register use while executing in this file: ("GLOBAL" denotes a common value.)
**************************************************************************************/

#define r1_all_ones     $1   /* at Will hold 0xffffffff to simplify bit insertion of 1's. GLOBAL! */

// $2 - $7 (v0, v1 a0 - a3) reserved for program use

#define r8_core_num    $8  /* t0 Core number. Only core 0 is active after reset. */
#define r9_vpe_num     $9  /* t1 MT ASE VPE number that this TC is bound to (0 if non-MT.) */
#define r10_has_mt_ase  $10   /* t2 Core implements the MT ASE. */
#define r11_is_cps      $11   /* t3 Core is part of a Coherent Processing System. */

// $12 - $15 (t4 - t7) are free to use
// $16, $17 (s0 and s1) reserved for program use

#define r18_tc_num      $18  /* s2 MT ASE TC number (0 if non-MT.) */
#define r19_more_cores  $19  /* s3 Number of cores in CPS in addition to core 0. GLOBAL! */
#define r20_more_vpes   $20  /* s4 Number of vpes in this core in addition to vpe 0. */
#define r21_more_tcs    $21  /* s5 Number of tcs in vpe in addition to the first. */
#define r22_gcr_addr    $22  /* s6 Uncached (kseg1) base address of the Global Config Registers. */
#define r23_cpu_num     $23  /* s7 Unique per vpe "cpu" identifier (CP0 EBase[CPUNUM]). */
#define r24_malta_word  $24  /* t8 Uncached (kseg1) base address of Malta ascii display. GLOBAL! */
#define r25_coreid      $25  /* t9 Copy of cp0 PRiD GLOBAL! */
#define r26_int_addr    $26  /* k0 Interrupt handler scratch address. */
#define r27_int_data    $27  /* k1 Interrupt handler scratch data. */
// $28 gp and $29 sp
#define r30_cpc_addr    $30  /* s8 Address of CPC register block after cpc_init. 0 indicates no CPC. */
// $31 ra


