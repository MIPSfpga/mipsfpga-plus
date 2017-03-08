#include <mips/cpu.h>

#include "mfp_memory_mapped_registers.h"

#define MIPS_TIMER_PERIOD   0x200

void mipsTimerInit(void)
{
    mips32_setcompare(MIPS_TIMER_PERIOD);
    mips32_setcount(0);

    mips32_bicsr (SR_BEV);
    mips32_bissr (SR_IE | SR_HINT5);
}

volatile long long int n;

void __attribute__ ((interrupt, keep_interrupts_masked)) general_exception_handler ()
{
    n ++;

    mips32_setcount(0);                     //counter reset
    mips32_setcompare(MIPS_TIMER_PERIOD);   //interupt flag clear (see m14k_cpz.v:1984 for details)
}

void outputValue(long long int val)
{
    MFP_RED_LEDS   = val >> 16;
    MFP_GREEN_LEDS = val >> 16;
    MFP_7_SEGMENT_HEX = ((val >> 8) & 0xffffff00) | (val & 0xff);
}

int main ()
{
    n = 0;

    mipsTimerInit();

    for (;;)
    {
        outputValue(n);
    }

    return 0;
}
