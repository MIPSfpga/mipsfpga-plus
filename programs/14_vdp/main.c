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

void delay (int n)
{
    while (n > 0)
        MFP_RED_LEDS = n --;
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
    
    unsigned x, y;

    VDP_SPRITE_ROW (0, 0, 0x000cc000);
    VDP_SPRITE_ROW (0, 1, 0x00cccc00);
    VDP_SPRITE_ROW (0, 2, 0x0cceecc0);
    VDP_SPRITE_ROW (0, 3, 0xcceeeecc);
    VDP_SPRITE_ROW (0, 4, 0xcceeeecc);
    VDP_SPRITE_ROW (0, 5, 0x0cceecc0);
    VDP_SPRITE_ROW (0, 6, 0x00cccc00);
    VDP_SPRITE_ROW (0, 7, 0x000cc000);

    VDP_SPRITE_ROW (1, 0, 0x00cccc00);
    VDP_SPRITE_ROW (1, 1, 0x0cceecc0);
    VDP_SPRITE_ROW (1, 2, 0xcceeeecc);
    VDP_SPRITE_ROW (1, 3, 0xcceeeecc);
    VDP_SPRITE_ROW (1, 4, 0xcceeeecc);
    VDP_SPRITE_ROW (1, 5, 0xcceeeecc);
    VDP_SPRITE_ROW (1, 6, 0x0cceecc0);
    VDP_SPRITE_ROW (1, 7, 0x00cccc00);

    VDP_SPRITE_ROW (2, 0, 0x000cc000);
    VDP_SPRITE_ROW (2, 1, 0x00cccc00);
    VDP_SPRITE_ROW (2, 2, 0x0ccddcc0);
    VDP_SPRITE_ROW (2, 3, 0xccddddcc);
    VDP_SPRITE_ROW (2, 4, 0xccddddcc);
    VDP_SPRITE_ROW (2, 5, 0x0ccddcc0);
    VDP_SPRITE_ROW (2, 6, 0x00cccc00);
    VDP_SPRITE_ROW (2, 7, 0x000cc000);

    VDP_SPRITE_ROW (3, 0, 0x00cccc00);
    VDP_SPRITE_ROW (3, 1, 0x0ccddcc0);
    VDP_SPRITE_ROW (3, 2, 0xccddddcc);
    VDP_SPRITE_ROW (3, 3, 0xccddddcc);
    VDP_SPRITE_ROW (3, 4, 0xccddddcc);
    VDP_SPRITE_ROW (3, 5, 0xccddddcc);
    VDP_SPRITE_ROW (3, 6, 0x0ccddcc0);
    VDP_SPRITE_ROW (3, 7, 0x00cccc00);

    VDP_SPRITE_ROW (4, 0, 0x000ff000);
    VDP_SPRITE_ROW (4, 1, 0x000ff000);
    VDP_SPRITE_ROW (4, 2, 0x000ff000);
    VDP_SPRITE_ROW (4, 3, 0xffffffff);
    VDP_SPRITE_ROW (4, 4, 0xffffffff);
    VDP_SPRITE_ROW (4, 5, 0x000ff000);
    VDP_SPRITE_ROW (4, 6, 0x000ff000);
    VDP_SPRITE_ROW (4, 7, 0x000ff000);

    VDP_SPRITE_ROW (5, 0, 0xcccccc00);
    VDP_SPRITE_ROW (5, 1, 0x0000ccc0);
    VDP_SPRITE_ROW (5, 2, 0x0000cccc);
    VDP_SPRITE_ROW (5, 3, 0xcccccccc);
    VDP_SPRITE_ROW (5, 4, 0xcccccccc);
    VDP_SPRITE_ROW (5, 5, 0x0000cccc);
    VDP_SPRITE_ROW (5, 6, 0x0000ccc0);
    VDP_SPRITE_ROW (5, 7, 0xcccccc00);

    VDP_SPRITE_ROW (6, 0, 0xbb0000bb);
    VDP_SPRITE_ROW (6, 1, 0x0bb00bb0);
    VDP_SPRITE_ROW (6, 2, 0x00bbbb00);
    VDP_SPRITE_ROW (6, 3, 0x000bb000);
    VDP_SPRITE_ROW (6, 4, 0x000bb000);
    VDP_SPRITE_ROW (6, 5, 0x00bb00bb);
    VDP_SPRITE_ROW (6, 6, 0x0bb00bb0);
    VDP_SPRITE_ROW (6, 7, 0xbb0000bb);

    VDP_SPRITE_ROW (7, 0, 0xeeeeeeee);
    VDP_SPRITE_ROW (7, 1, 0x00000ee0);
    VDP_SPRITE_ROW (7, 2, 0x0000ee00);
    VDP_SPRITE_ROW (7, 3, 0x000ee000);
    VDP_SPRITE_ROW (7, 4, 0x00ee0000);
    VDP_SPRITE_ROW (7, 5, 0x0ee00000);
    VDP_SPRITE_ROW (7, 6, 0xeeeeeeee);
    VDP_SPRITE_ROW (7, 7, 0x00000000);

    for (x = 0, y = 0;; x ++, y ++)
    {
        VDP_SPRITE_XY ( 0, x * 0 % VDP_SCREEN_WIDTH, y * 1 % VDP_SCREEN_HEIGHT );
        VDP_SPRITE_XY ( 1, x * 1 % VDP_SCREEN_WIDTH, y * 0 % VDP_SCREEN_HEIGHT );
        VDP_SPRITE_XY ( 2, x * 1 % VDP_SCREEN_WIDTH, y * 1 % VDP_SCREEN_HEIGHT );
        VDP_SPRITE_XY ( 3, x * 1 % VDP_SCREEN_WIDTH, y * 2 % VDP_SCREEN_HEIGHT );
        VDP_SPRITE_XY ( 4, x * 2 % VDP_SCREEN_WIDTH, y * 1 % VDP_SCREEN_HEIGHT );
        VDP_SPRITE_XY ( 5, x * 2 % VDP_SCREEN_WIDTH, y * 3 % VDP_SCREEN_HEIGHT );
        VDP_SPRITE_XY ( 6, x * 3 % VDP_SCREEN_WIDTH, y * 2 % VDP_SCREEN_HEIGHT );

        VDP_SPRITE_XY ( 7, x * 1 % VDP_SCREEN_WIDTH  / 2 + VDP_SCREEN_WIDTH  / 4,
                           y * 1 % VDP_SCREEN_HEIGHT / 2 + VDP_SCREEN_HEIGHT / 4 );

        delay (200000);
    }

    return 0;
}
