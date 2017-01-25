	.file	1 "main.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	softfloat
	.module	oddspreg
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	move	$3,$0
	move	$5,$0
	li	$6,-1082130432			# 0xffffffffbf800000
	li	$11,-256			# 0xffffffffffffff00
	sll	$4,$5,24
.L4:
	srl	$2,$3,8
	or	$2,$4,$2
	sll	$8,$5,16
	srl	$4,$3,16
	andi	$10,$3,0xff
	addiu	$7,$3,1
	and	$2,$2,$11
	or	$4,$8,$4
	sltu	$9,$7,$3
	or	$2,$2,$10
	sw	$4,0($6)
	move	$3,$7
	sw	$4,4($6)
	addu	$5,$9,$5
	sw	$2,16($6)
	b	.L4
	sll	$4,$5,24

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Codescape GNU Tools 2015.06-05 for MIPS MTI Bare Metal) 4.9.2"
