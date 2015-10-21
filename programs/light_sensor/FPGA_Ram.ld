/***********************************************************************
 *
 *  link-FPGA_Ram.ld
 *
 *  Linker script for startup code for simulator and 24K  
 *
 * ######################################################################
 Unpublished work (c) MIPS Technologies, Inc.  All rights reserved.  Unpublished rights reserved 
 under the copyright laws of the United States of America and other countries.
 
 This code is confidential and proprietary to MIPS Technologies, Inc. ("MIPS Technologies") and 
 may be disclosed only as permitted in writing by MIPS Technologies or an authorized third party.  
 Any copying, reproducing, modifying, use or disclosure of this code (in whole or in part) that is 
 not expressly permitted in writing by MIPS Technologies or an authorized third party is strictly 
 prohibited. At a minimum, this code is protected under trade secret, unfair competition, and 
 copyright laws. Violations thereof may result in criminal penalties and fines.
 
 MIPS Technologies reserves the right to change this code to improve function, design or 
 otherwise. MIPS Technologies does not assume any liability arising out of the application or use 
 of this code, or of any error or omission in such code.  Any warranties, whether express, statutory, 
 implied or otherwise, including but not limited to the implied warranties of merchantability or 
 fitness for a particular purpose, are excluded.  Except as expressly provided in any written license 
 agreement from MIPS Technologies or an authorized third party, the furnishing of this code does 
 not give recipient any license to any intellectual property rights, including any patent rights, that 
 cover this code.
 
 This code shall not be exported, reexported, transferred, or released, directly or indirectly, in 
 violation of the law of any country or international law, regulation, treaty, Executive Order, 
 statute, amendments or supplements thereto.  Should a conflict arise regarding the export, 
 reexport, transfer, or release of this code, the laws of the United States of America shall be 
 the governing law.
 
 This code may only be disclosed to the United States government ("Government"), or to 
 Government users, with prior written consent from MIPS Technologies or an authorized third 
 party.  This code constitutes one or more of the following: commercial computer software, 
 commercial computer software documentation or other commercial items.  If the user of this 
 code, or any related documentation of any kind, including related technical data or manuals, is an 
 agency, department, or other entity of the Government, the use, duplication, reproduction, release, 
 modification, disclosure, or transfer of this code, or any related documentation of any kind, is 
 restricted in accordance with Federal Acquisition Regulation 12.212 for civilian agencies and 
 Defense Federal Acquisition Regulation Supplement 227.7202 for military agencies.  The use of 
 this code by the Government is further restricted in accordance with the terms of the license 
 agreement(s) and/or applicable contract terms and conditions covering this code from MIPS 
 Technologies or an authorized third party.
 ************************************************************************/

OUTPUT_ARCH(mips)

/**** memory map for Nexys4, BE2-115  ****/
/*
128KB: 0xBFC00000-0xBFC1FFFF
256KB: 0x80000000-0x8003FFFF
*/

/**** Start point ****/
hwreset = 0xbfc00000;
ENTRY(hwreset)

SECTIONS
{
  /**** Init Code (executed from reset) ****/

  .reset 0x9fc00000 :   /* Runs uncached (from 0x9fc00000) until I$ is initialized. */
  {
    _ftext_init = ABSOLUTE(.) ;	/* Start of init code. */
    *(.reset)			/* Reset entry point   */
    *(.boot)			/* Boot code */
    . = ALIGN(8);
    _etext_init = ABSOLUTE(.);	/* End of init code. */
  } = 0

  /**** "C" Code and read-only data ****/

  .text_ram 0x80001000 :
  {
    _ftext_ram = ABSOLUTE(.) ;	/* Start of code and read-only data */
    *(.text)*(.text.*)
    *(.rodata)
    *(.rodata.*)
    . = ALIGN(8);
    _etext_ram = ABSOLUTE(.);	/* End of code and read-only data   */
  } = 0

  /**** Initialised data ****/

  .data :
  {
    _fdata_ram = ABSOLUTE(.);	/* Start of initialised data */
    *(.data)
    . = ALIGN(8);
    _gp = ABSOLUTE(. + 0x8000); /* Base of small data	    */
    *(.lit8) 
    *(.lit4) 
    *(.sdata) 
    . = ALIGN(8);
    _edata_ram  = ABSOLUTE(.);	/* End of initialised data  */
  } 

  /**** Uninitialised data ****/

  _fbss = .;			/* Start of uninitialised data	*/

  .sbss : 
  { 
    *(.sbss) 
    *(.scommon)
  }
  .bss :
  {
    *(.bss)
    *(COMMON)
  }

  _end = . ;		/* End of uninitialised data	    */

  .gptab.sdata : { *(.gptab.data) *(.gptab.sdata) }
  .gptab.sbss : { *(.gptab.bss) *(.gptab.sbss) }


  /DISCARD/ :
  {
    *(.reginfo)
    *(.MIPS.abiflags)
  }
  _freemem = .;
}
