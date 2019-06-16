#include <mips/cpu.h>

#include "mfp_memory_mapped_registers.h"
#include "vdp.h"

void __attribute__ ((interrupt, keep_interrupts_masked)) general_exception_handler ()
{
    unsigned cause = mips32_getcr ();  // Coprocessor 0 Cause register

    if (cause & CR_HINT0)  // Checking whether interrupt 0 is pending
        ;  // Do something
    else if (cause & CR_HINT1)  // Checking whether interrupt 1 is pending
        ;  // Do something
}

int main ()
{
    /*

    Future code for interrupt processing

    // Clear boot interrupt vector bit in Coprocessor 0 Status register

    mips32_bicsr (SR_BEV);

    // Set master interrupt enable bit, as well as individual interrupt enable bits
    // in Coprocessor 0 Status register

    mips32_bissr (SR_IE | SR_HINT0 | SR_HINT1 | SR_HINT2 | SR_HINT3 | SR_HINT4 | SR_HINT5);

    __asm__ volatile ("di");  // Disable interrupts
    __asm__ volatile ("ei");  // Enable interrupts

    */

    VDP_SPRITE_ROW (0, 0, 0x000cc000);
    VDP_SPRITE_ROW (0, 1, 0x00cccc00);
    VDP_SPRITE_ROW (0, 2, 0x0cceecc0);
    VDP_SPRITE_ROW (0, 3, 0xcceeeecc);
    VDP_SPRITE_ROW (0, 4, 0xcceeeecc);
    VDP_SPRITE_ROW (0, 5, 0x0cceecc0);
    VDP_SPRITE_ROW (0, 6, 0x00cccc00);
    VDP_SPRITE_ROW (0, 7, 0x000cc000);

    VDP_SPRITE_XY (0, 100, 100);

    for (;;);

    return 0;
}
