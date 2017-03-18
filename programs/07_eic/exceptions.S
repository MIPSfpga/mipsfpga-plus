



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

