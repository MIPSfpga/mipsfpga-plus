	.file	1 "main.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	softfloat
	.module	oddspreg
	.text
	.align	2
	.globl	_delay
	.set	nomips16
	.set	nomicromips
	.ent	_delay
	.type	_delay, @function
_delay:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	beq	$4,$0,.L9
	move	$2,$0
	.set	macro
	.set	reorder

.L3:
 #APP
 # 34 "main.c" 1
	nop
 # 0 "" 2
 #NO_APP
	addiu	$2,$2,1
	bne	$2,$4,.L3
.L9:
	jr	$31
	.end	_delay
	.size	_delay, .-_delay
	.align	2
	.globl	statOut
	.set	nomips16
	.set	nomicromips
	.ent	statOut
	.type	statOut, @function
statOut:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	andi	$4,$4,0x00ff
	andi	$5,$5,0xffff
	sll	$4,$4,16
	addu	$4,$4,$5
	li	$2,-1082130432			# 0xffffffffbf800000
	sw	$4,16($2)
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	statOut
	.size	statOut, .-statOut
	.align	2
	.globl	stepOut
	.set	nomips16
	.set	nomicromips
	.ent	stepOut
	.type	stepOut, @function
stepOut:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	li	$2,1			# 0x1
	sll	$4,$2,$4
	andi	$4,$4,0xffff
	li	$2,-1082130432			# 0xffffffffbf800000
	sw	$4,0($2)
	sw	$4,4($2)
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	stepOut
	.size	stepOut, .-stepOut
	.align	2
	.globl	cacheFlush
	.set	nomips16
	.set	nomicromips
	.ent	cacheFlush
	.type	cacheFlush, @function
cacheFlush:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
 #APP
 # 62 "main.c" 1
	cache 0x15, 0($4)
	
 # 0 "" 2
 #NO_APP
	jr	$31
	.end	cacheFlush
	.size	cacheFlush, .-cacheFlush
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,24,$31		# vars= 0, regs= 1/0, args= 16, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-24
	li	$2,-1082130432			# 0xffffffffbf800000
	li	$4,1			# 0x1
	sw	$fp,20($sp)
	move	$fp,$sp
	addiu	$sp,$sp,-808
	sw	$4,0($2)
	move	$11,$sp
	sw	$4,4($2)
	move	$3,$sp
	move	$2,$0
	li	$4,200			# 0xc8
.L14:
	sw	$2,0($3)
	addiu	$2,$2,1
	.set	noreorder
	.set	nomacro
	bne	$2,$4,.L14
	addiu	$3,$3,4
	.set	macro
	.set	reorder

	move	$12,$0
	move	$4,$0
	addiu	$9,$11,800
	li	$7,-1082130432			# 0xffffffffbf800000
	li	$15,2			# 0x2
	li	$14,4			# 0x4
	li	$13,8			# 0x8
	li	$8,200			# 0xc8
	li	$24,1			# 0x1
.L19:
	sw	$15,0($7)
	move	$2,$11
	sw	$15,4($7)
.L15:
 #APP
 # 62 "main.c" 1
	cache 0x15, 0($2)
	
 # 0 "" 2
 #NO_APP
	addiu	$2,$2,4
	bne	$9,$2,.L15
	sw	$14,0($7)
	li	$2,10			# 0xa
	sw	$14,4($7)
.L16:
 #APP
 # 34 "main.c" 1
	nop
 # 0 "" 2
 #NO_APP
	addiu	$2,$2,-1
	bne	$2,$0,.L16
	sw	$13,0($7)
	sll	$10,$12,16
	sw	$13,4($7)
	move	$3,$11
	lw	$5,0($11)
.L29:
	addiu	$6,$4,1
	.set	noreorder
	.set	nomacro
	beq	$5,$2,.L17
	addiu	$3,$3,4
	.set	macro
	.set	reorder

	andi	$4,$6,0xffff
	addu	$5,$4,$10
	sw	$5,16($7)
.L17:
	addiu	$2,$2,1
	.set	noreorder
	.set	nomacro
	bnel	$2,$8,.L29
	lw	$5,0($3)
	.set	macro
	.set	reorder

	addu	$10,$4,$10
	sw	$10,16($7)
	.set	noreorder
	.set	nomacro
	bne	$12,$24,.L19
	li	$12,1			# 0x1
	.set	macro
	.set	reorder

	li	$2,32			# 0x20
	li	$3,16			# 0x10
	movz	$2,$3,$4
	move	$4,$2
	li	$2,-1082130432			# 0xffffffffbf800000
	sw	$4,0($2)
	sw	$4,4($2)
.L21:
	b	.L21
	.end	main
	.size	main, .-main
	.ident	"GCC: (Codescape GNU Tools 2016.05-03 for MIPS MTI Bare Metal) 4.9.2"
