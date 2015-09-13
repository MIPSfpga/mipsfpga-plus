/*
 * main.S for microAptiv_UP MIPS core running on Nexys4-DDR or DE2-115
 * FPGA target boards
 *
 * Description:
 * Reads the switches on the FPGA board and writes 
 * the values to the LEDs. 
 *
 * This code uses function calls to read the switches and write the LEDs
 */

# $12 = address of switches, $13 = address offset of switches
# $10 = switch values 
.globl main

main:
   lui   $12, 0xbf80       # $12 = address of LEDs 
   addi  $13, $12, 8       # $13 = address of switches

displaySW: 	
   add   $a0, $13, $0      # put address of switches in $a0
   jal   peek              # call peek function
   nop                     # branch delay slot
   add   $a0, $v0, $0      # move the return value into $a0
   add   $a1, $12, $0      # move address of LEDs in $a1
   jal   poke              # call poke function
   nop                     # branch delay slot
   beq   $0, $0, displaySW # repeat
   nop                     # branch delay slot

peek:
   lw    $v0, 0($a0)       # read I/O register value into $v0 
   jr    $ra               # return to point of call
   nop                     # branch delay slot

poke:
   sw    $a0, 0($a1)       # write values to I/O register 
   jr    $ra               # return to point of call
   nop                     # branch delay slot
  

