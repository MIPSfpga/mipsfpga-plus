



	.set	noreorder				# Don't allow the assembler to reorder instructions.
	.set	noat

	.section .exceptions			# place all the following code into a section named ".exceptions"

	.org	0x180					# set symbol offset from section beginning
	.weak   __mips_interrupt		# if the symbol does not already exist, it will be created
__isr_vec:
	la		$k1, __mips_interrupt	# load interrupt handler (__mips_interrupt) addr
	jr		$k1						# jump to __mips_interrupt
									# we can use 'j __mips_interrupt' but it works only with 1st 28 bits of addr
	nop

	# all the following symbol offsets were calculated for (IntCtl.VS = 00001)

 	.org	0x200					# set symbol offset from section beginning
	.weak   __mips_isr_sw0			# if the symbol does not already exist, it will be created
__isr_vec_sw0:
	la		$k1, __mips_isr_sw0		# load interrupt handler (__mips_isr_sw0) addr
	beqz	$k1, __mips_interrupt	# if it is not present then go to generic handler (__mips_interrupt)
	nop
 	jr		$k1						# jump to irq_sw0
 	nop

	.org	0x220
	.weak   __mips_isr_sw1
__isr_vec_sw1:
	la		$k1, __mips_isr_sw1
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x240
	.weak   __mips_isr_hw0
__isr_vec_hw0:
	la		$k1, __mips_isr_hw0
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x260
	.weak   __mips_isr_hw1
__isr_vec_hw1:
	la		$k1, __mips_isr_hw1
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x280
	.weak   __mips_isr_hw2
__isr_vec_hw2:
	la		$k1, __mips_isr_hw2
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x2A0
	.weak   __mips_isr_hw3
__isr_vec_hw3:
	la		$k1, __mips_isr_hw3
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x2C0
	.weak   __mips_isr_hw4
__isr_vec_hw4:
	la		$k1, __mips_isr_hw4
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x2E0
	.weak   __mips_isr_hw5
__isr_vec_hw5:
	la		$k1, __mips_isr_hw5
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x300
	.weak   __mips_isr_hw6
__isr_vec_hw6:
	la		$k1, __mips_isr_hw6
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop

	.org	0x320
	.weak   __mips_isr_hw7
__isr_vec_hw7:
	la		$k1, __mips_isr_hw7
	beqz	$k1, __mips_interrupt
	nop
 	jr		$k1
 	nop
