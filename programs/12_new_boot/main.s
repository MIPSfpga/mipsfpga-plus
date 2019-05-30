	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	softfloat
	.module	oddspreg
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.align	2
	.globl	main
.LFB0 = .
	.file 1 "main.c"
	.loc 1 4 0
	.cfi_startproc
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
.LVL0 = .
	.loc 1 4 0
	move	$4,$0
	.loc 1 9 0
	li	$2,-1082130432			# 0xffffffffbf800000
.LVL1 = .
.L2:
	.loc 1 9 0 is_stmt 0 discriminator 1
	lw	$3,20($2)
	srl	$3,$3,4
	sw	$3,0($2)
	.loc 1 10 0 is_stmt 1 discriminator 1
	lw	$3,20($2)
	sw	$3,16($2)
.LVL2 = .
	.loc 1 11 0 discriminator 1
	sw	$4,4($2)
.LVL3 = .
	b	.L2
	addiu	$4,$4,1

	.set	macro
	.set	reorder
	.end	main
	.cfi_endproc
.LFE0:
	.size	main, .-main
.Letext0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x50
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF0
	.byte	0x1
	.4byte	.LASF1
	.4byte	.LASF2
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.4byte	.LASF3
	.byte	0x1
	.byte	0x3
	.4byte	0x4c
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4c
	.uleb128 0x3
	.ascii	"n\000"
	.byte	0x1
	.byte	0x5
	.4byte	0x4c
	.4byte	.LLST0
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST0:
	.4byte	.LVL0-.Ltext0
	.4byte	.LVL1-.Ltext0
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL1-.Ltext0
	.4byte	.LVL2-.Ltext0
	.2byte	0x1
	.byte	0x54
	.4byte	.LVL2-.Ltext0
	.4byte	.LVL3-.Ltext0
	.2byte	0x3
	.byte	0x74
	.sleb128 1
	.byte	0x9f
	.4byte	.LVL3-.Ltext0
	.4byte	.LFE0-.Ltext0
	.2byte	0x1
	.byte	0x54
	.4byte	0
	.4byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF0:
	.ascii	"GNU C 4.9.2 -mel -march=m14kc -msoft-float -mplt -mips32"
	.ascii	"r2 -msynci -mabi=32 -g -O1\000"
.LASF2:
	.ascii	"/home/training/github/mipsfpga_2_0_sandbox/programs/07_n"
	.ascii	"ew_boot\000"
.LASF1:
	.ascii	"main.c\000"
.LASF3:
	.ascii	"main\000"
	.ident	"GCC: (Codescape GNU Tools 2016.05-03 for MIPS MTI Bare Metal) 4.9.2"
