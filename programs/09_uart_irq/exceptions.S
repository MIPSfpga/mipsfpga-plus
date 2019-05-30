



    .set    noreorder               # Don't allow the assembler to reorder instructions.
    .set    noat

    .section .exceptions            # place all the following code into a section named ".exceptions"

    # exception handlers

    .org    0x0                     # set symbol offset from section beginning
    .weak   _mips_tlb_refill        # if the symbol does not already exist, it will be created
__tlb_refill:
    la      $k1, _mips_tlb_refill   # load exception handler (_mips_tlb_refill) addr
    beqz    $k1, __tlb_refill       # if _mips_tlb_refill doen not exist then just loop at this point
    nop
    jr      $k1                     # jump to _mips_tlb_refill.
                                    # we can use 'j _mips_tlb_refill' but it works only with 1st 28 bits of addr
    nop

    .org    0x80                    # there is no information about this vector in 
    .weak   _mips_xtlb_refill       # 'MIPS32® microAptiv™ UP Processor Core Family Software User’s Manual, Revision 01.02'
__xtlb_refill:                      # but it present in 'Codescape GNU Tools for MIPS Programmer's Guide'
    la      $k1, _mips_xtlb_refill  # and in mips code examples
    beqz    $k1, __xtlb_refill
    nop
    jr      $k1
    nop

    .org    0x100
    .weak   _mips_cache_error
__cache_error:
    la      $k1, _mips_cache_error
    beqz    $k1, __cache_error
    nop
    jr      $k1
    nop

    .org    0x180
    .weak   _mips_general_exception
__general_exception:
    la      $k1, _mips_general_exception
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    #
    # interrupt handlers
    #
    # all the following symbol offsets were calculated for (IntCtl.VS = 00001)

    .org    0x200                       # set symbol offset from section beginning
    .weak   __mips_isr_sw0              # if the symbol does not already exist, it will be created
__isr_vec_sw0:
    la      $k1, __mips_isr_sw0         # load interrupt handler (__mips_isr_sw0) addr
    beqz    $k1, __general_exception    # if it is not present then go to generic handler (_mips_general_exception)
    nop
    jr      $k1                         # jump to irq_sw0
    nop

    .org    0x220
    .weak   __mips_isr_sw1
__isr_vec_sw1:
    la      $k1, __mips_isr_sw1
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x240
    .weak   __mips_isr_hw0
__isr_vec_hw0:
    la      $k1, __mips_isr_hw0
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x260
    .weak   __mips_isr_hw1
__isr_vec_hw1:
    la      $k1, __mips_isr_hw1
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x280
    .weak   __mips_isr_hw2
__isr_vec_hw2:
    la      $k1, __mips_isr_hw2
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x2A0
    .weak   __mips_isr_hw3
__isr_vec_hw3:
    la      $k1, __mips_isr_hw3
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x2C0
    .weak   __mips_isr_hw4
__isr_vec_hw4:
    la      $k1, __mips_isr_hw4
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x2E0
    .weak   __mips_isr_hw5
__isr_vec_hw5:
    la      $k1, __mips_isr_hw5
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x300
    .weak   __mips_isr_hw6
__isr_vec_hw6:
    la      $k1, __mips_isr_hw6
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop

    .org    0x320
    .weak   __mips_isr_hw7
__isr_vec_hw7:
    la      $k1, __mips_isr_hw7
    beqz    $k1, __general_exception
    nop
    jr      $k1
    nop
