#include <stdint.h>
#include <mips/cpu.h>

#include "eic.h"
#include "mfp_memory_mapped_registers.h"

// run types
#define SHARED_IRQ_HANDLER      0
#define MULTIPLE_IRQ_HANDLERS   1
#define EIC                     2

// config start

#define RUNTYPE             EIC
#define MIPS_TIMER_PERIOD   0x200

// config end


void mipsTimerInit(void)
{
    mips32_setcompare(MIPS_TIMER_PERIOD);   //set compare (TOP) value to turn timer on
    mips32_setcount(0);                     //reset counter
}

void mipsTimerReset(void)
{
    mips32_setcount(0);                     //reset counter as it reached the TOP value
    mips32_setcompare(MIPS_TIMER_PERIOD);   //don`t ask me why
                                            //but this is the way to clear timer interrupt flag (SI_TimerInt)
                                            //see m14k_cpz.v:1984 for details
}

void mipsInterruptInit(void)
{
    //eic mode
    MFP_EIC_EIMSK_0     = 0b111000;
    MFP_EIC_EISMSK_0    = 0b111111000000;
    MFP_EIC_EIACM_0     = 0b111000;

    mips32_bicsr (SR_BEV);              // Status.BEV  0 - vector interrupt mode
    mips32_biscr (CR_IV);               // Cause.IV,   1 - special int vector (0x200), where 0x200 - base when Status.BEV = 0;

    uint32_t intCtl = mips32_getintctl();       // get IntCtl reg value
    mips32_setintctl(intCtl | INTCTL_VS_32);    // set interrupt table vector spacing (0x20 in our case)
                                                // see exceptions.S for details

    MFP_EIC_EICR        = 0b1;
    mips32_bissr (SR_IE);
}

volatile long long int n;

void __attribute__ ((interrupt, keep_interrupts_masked)) __mips_interrupt ()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x1;

    n++;
    mipsTimerReset();

    //MFP_EIC_EIFRC_0 = 0b100000;

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x1;
}

void __attribute__ ((interrupt, keep_interrupts_masked)) __mips_isr_hw3()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x2;

    n++;
    mipsTimerReset();

    //MFP_EIC_EIFRC_0 = 0b100000;

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x2;
}

void __attribute__ ((interrupt, keep_interrupts_masked)) __mips_isr_hw4()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x4;

    n++;
    mipsTimerReset();

    //MFP_EIC_EIFRC_0 = 0b100000;

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x4;
}

int main ()
{
    n = 0;
    mipsTimerInit();
    mipsInterruptInit();

    for (;;)
    {
        //counter output
        MFP_7_SEGMENT_HEX = ((n >> 8) & 0xffffff00) | (n & 0xff);
    }

    return 0;
}
