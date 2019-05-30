#include "mfp_memory_mapped_registers.h"

int main ()
{
    int n = 0;

    for (;;)
    {
        // Wait for switch 2

        while ((MFP_SWITCHES & 4) == 0)
            ;

        if (MFP_SWITCHES & 8)
        {
            for (;;)
            {
                __asm__ volatile ("addiu $9,  $8, 1");
                __asm__ volatile ("addiu $10, $9, 1");
            }
        }
        else
        {
            for (;;)
            {
                __asm__ volatile ("addiu $9,  $8, 1");
                __asm__ volatile ("addiu $10, $8, 1");
            }
        }
    }

    return 0;
}
