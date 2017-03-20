



    .set    noreorder               # Don't allow the assembler to reorder instructions.
    .set    noat

    .section .exceptions            # place all the following code into a section named ".exceptions"

    .org    0x180                   # set symbol offset from section beginning
    .weak   __mips_interrupt        # if the symbol does not already exist, it will be created
__isr_vec:
    la      $k1, __mips_interrupt   # load interrupt handler (__mips_interrupt) addr
    jr      $k1	                    # jump to __mips_interrupt
                                    # we can use 'j __mips_interrupt' but it works only with 1st 28 bits of addr
    nop

    # all the following symbol offsets were calculated for (IntCtl.VS = 00001)

     .org   0x200                   # set symbol offset from section beginning
    .weak   __mips_isr_eic0         # if the symbol does not already exist, it will be created
__isr_vec_eic0:
    la      $k1, __mips_isr_eic0    # load interrupt handler (__mips_isr_eic0) addr
    beqz    $k1, __mips_interrupt   # if it is not present then go to generic handler (__mips_interrupt)
    nop
    jr      $k1                     # jump to __mips_isr_eic0
    nop

    .org    0x220
    .weak   __mips_isr_eic1
__isr_vec_eic1:
    la      $k1, __mips_isr_eic1
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x240
    .weak   __mips_isr_eic2
__isr_vec_eic2:
    la      $k1, __mips_isr_eic2
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x260
    .weak   __mips_isr_eic3
__isr_vec_eic3:
    la      $k1, __mips_isr_eic3
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x280
    .weak   __mips_isr_eic4
__isr_vec_eic4:
    la      $k1, __mips_isr_eic4
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x2A0
    .weak   __mips_isr_eic5
__isr_vec_eic5:
    la      $k1, __mips_isr_eic5
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x2C0
    .weak   __mips_isr_eic6
__isr_vec_eic6:
    la      $k1, __mips_isr_eic6
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x2E0
    .weak   __mips_isr_eic7
__isr_vec_eic7:
    la      $k1, __mips_isr_eic7
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x300
    .weak   __mips_isr_eic8
__isr_vec_eic8:
    la      $k1, __mips_isr_eic8
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x320
    .weak   __mips_isr_eic9
__isr_vec_eic9:
    la      $k1, __mips_isr_eic9
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x340
    .weak   __mips_isr_eic10
__isr_vec_eic10:
    la      $k1, __mips_isr_eic10
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x360
    .weak   __mips_isr_eic11
__isr_vec_eic11:
    la      $k1, __mips_isr_eic11
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x380
    .weak   __mips_isr_eic12
__isr_vec_eic12:
    la      $k1, __mips_isr_eic12
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x3A0
    .weak   __mips_isr_eic13
__isr_vec_eic13:
    la      $k1, __mips_isr_eic13
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x3C0
    .weak   __mips_isr_eic14
__isr_vec_eic14:
    la      $k1, __mips_isr_eic14
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x3E0
    .weak   __mips_isr_eic15
__isr_vec_eic15:
    la      $k1, __mips_isr_eic15
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x400
    .weak   __mips_isr_eic16
__isr_vec_eic16:
    la      $k1, __mips_isr_eic16
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x420
    .weak   __mips_isr_eic17
__isr_vec_eic17:
    la      $k1, __mips_isr_eic17
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x440
    .weak   __mips_isr_eic18
__isr_vec_eic18:
    la      $k1, __mips_isr_eic18
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x460
    .weak   __mips_isr_eic19
__isr_vec_eic19:
    la      $k1, __mips_isr_eic19
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x480
    .weak   __mips_isr_eic20
__isr_vec_eic20:
    la      $k1, __mips_isr_eic20
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x4A0
    .weak   __mips_isr_eic21
__isr_vec_eic21:
    la      $k1, __mips_isr_eic21
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x4C0
    .weak   __mips_isr_eic22
__isr_vec_eic22:
    la      $k1, __mips_isr_eic22
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x4E0
    .weak   __mips_isr_eic23
__isr_vec_eic23:
    la      $k1, __mips_isr_eic23
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x500
    .weak   __mips_isr_eic24
__isr_vec_eic24:
    la      $k1, __mips_isr_eic24
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x520
    .weak   __mips_isr_eic25
__isr_vec_eic25:
    la      $k1, __mips_isr_eic25
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x540
    .weak   __mips_isr_eic26
__isr_vec_eic26:
    la      $k1, __mips_isr_eic26
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x560
    .weak   __mips_isr_eic27
__isr_vec_eic27:
    la      $k1, __mips_isr_eic27
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x580
    .weak   __mips_isr_eic28
__isr_vec_eic28:
    la      $k1, __mips_isr_eic28
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x5A0
    .weak   __mips_isr_eic29
__isr_vec_eic29:
    la      $k1, __mips_isr_eic29
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x5C0
    .weak   __mips_isr_eic30
__isr_vec_eic30:
    la      $k1, __mips_isr_eic30
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x5E0
    .weak   __mips_isr_eic31
__isr_vec_eic31:
    la      $k1, __mips_isr_eic31
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x600
    .weak   __mips_isr_eic32
__isr_vec_eic32:
    la      $k1, __mips_isr_eic32
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x620
    .weak   __mips_isr_eic33
__isr_vec_eic33:
    la      $k1, __mips_isr_eic33
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x640
    .weak   __mips_isr_eic34
__isr_vec_eic34:
    la      $k1, __mips_isr_eic34
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x660
    .weak   __mips_isr_eic35
__isr_vec_eic35:
    la      $k1, __mips_isr_eic35
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x680
    .weak   __mips_isr_eic36
__isr_vec_eic36:
    la      $k1, __mips_isr_eic36
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x6A0
    .weak   __mips_isr_eic37
__isr_vec_eic37:
    la      $k1, __mips_isr_eic37
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x6C0
    .weak   __mips_isr_eic38
__isr_vec_eic38:
    la      $k1, __mips_isr_eic38
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x6E0
    .weak   __mips_isr_eic39
__isr_vec_eic39:
    la      $k1, __mips_isr_eic39
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x700
    .weak   __mips_isr_eic40
__isr_vec_eic40:
    la      $k1, __mips_isr_eic40
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

   .org    0x720
    .weak   __mips_isr_eic41
__isr_vec_eic41:
    la      $k1, __mips_isr_eic41
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x740
    .weak   __mips_isr_eic42
__isr_vec_eic42:
    la      $k1, __mips_isr_eic42
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x760
    .weak   __mips_isr_eic43
__isr_vec_eic43:
    la      $k1, __mips_isr_eic43
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x780
    .weak   __mips_isr_eic44
__isr_vec_eic44:
    la      $k1, __mips_isr_eic44
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x7A0
    .weak   __mips_isr_eic45
__isr_vec_eic45:
    la      $k1, __mips_isr_eic45
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x7C0
    .weak   __mips_isr_eic46
__isr_vec_eic46:
    la      $k1, __mips_isr_eic46
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x7E0
    .weak   __mips_isr_eic47
__isr_vec_eic47:
    la      $k1, __mips_isr_eic47
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x800
    .weak   __mips_isr_eic48
__isr_vec_eic48:
    la      $k1, __mips_isr_eic48
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x820
    .weak   __mips_isr_eic49
__isr_vec_eic49:
    la      $k1, __mips_isr_eic49
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x840
    .weak   __mips_isr_eic50
__isr_vec_eic50:
    la      $k1, __mips_isr_eic50
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

   .org    0x860
    .weak   __mips_isr_eic51
__isr_vec_eic51:
    la      $k1, __mips_isr_eic51
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x880
    .weak   __mips_isr_eic52
__isr_vec_eic52:
    la      $k1, __mips_isr_eic52
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x8A0
    .weak   __mips_isr_eic53
__isr_vec_eic53:
    la      $k1, __mips_isr_eic53
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x8C0
    .weak   __mips_isr_eic54
__isr_vec_eic54:
    la      $k1, __mips_isr_eic54
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x8E0
    .weak   __mips_isr_eic55
__isr_vec_eic55:
    la      $k1, __mips_isr_eic55
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x900
    .weak   __mips_isr_eic56
__isr_vec_eic56:
    la      $k1, __mips_isr_eic56
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org	0x920
    .weak   __mips_isr_eic57
__isr_vec_eic57:
    la      $k1, __mips_isr_eic57
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x940
    .weak   __mips_isr_eic58
__isr_vec_eic58:
    la      $k1, __mips_isr_eic58
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x960
    .weak   __mips_isr_eic59
__isr_vec_eic59:
    la      $k1, __mips_isr_eic59
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x980
    .weak   __mips_isr_eic60
__isr_vec_eic60:
    la      $k1, __mips_isr_eic60
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

   .org    0x9A0
    .weak   __mips_isr_eic61
__isr_vec_eic61:
    la      $k1, __mips_isr_eic61
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x9C0
    .weak   __mips_isr_eic62
__isr_vec_eic62:
    la      $k1, __mips_isr_eic62
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop

    .org    0x9E0
    .weak   __mips_isr_eic63
__isr_vec_eic63:
    la      $k1, __mips_isr_eic63
    beqz    $k1, __mips_interrupt
    nop
    jr      $k1
    nop
