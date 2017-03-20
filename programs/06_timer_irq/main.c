#include <stdint.h>
#include <mips/cpu.h>

#include "mfp_memory_mapped_registers.h"

// run types
#define SHARED_IRQ_HANDLER      0
#define MULTIPLE_IRQ_HANDLERS   1

// config start

#define RUNTYPE             MULTIPLE_IRQ_HANDLERS
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
    #if     RUNTYPE == SHARED_IRQ_HANDLER
        //vector mode, one common handler
        mips32_bicsr (SR_BEV);              // Status.BEV  0 - vector interrupt mode
        mips32_biccr (CR_IV);               // Cause.IV,   0 - general exception handler (offset 0x180)
        mips32_bissr (SR_IE | SR_HINT5);    // interrupt enable, HW5 - unmasked

    #elif   RUNTYPE == MULTIPLE_IRQ_HANDLERS
        //vector mode multiple handlers
        mips32_bicsr (SR_BEV);              // Status.BEV  0 - vector interrupt mode
        mips32_biscr (CR_IV);               // Cause.IV,   1 - special int vector (0x200), where 0x200 - base when Status.BEV = 0;

        uint32_t intCtl = mips32_getintctl();       // get IntCtl reg value
        mips32_setintctl(intCtl | INTCTL_VS_32);    // set interrupt table vector spacing (0x20 in our case)
                                                    // see exceptions.S for details

        mips32_bissr (SR_IE | SR_HINT5 | SR_SINT0 | SR_SINT1); // interrupt enable, HW5 and SW0,SW1 - unmasked
    #endif
}

volatile long long int n;

void __attribute__ ((interrupt, keep_interrupts_masked)) __mips_interrupt ()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x1;

    uint32_t cause = mips32_getcr();

    //check for timer interrupt
    if(cause & CR_HINT5)
    {
        n++;
        mipsTimerReset();
    }
    //check for software interrupt 1
    else if (cause & CR_SINT1)
    {
        mips32_biccr(CR_SINT1);     //clear software interrupt 1 flag
    }

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x1;
}

void __attribute__ ((interrupt, keep_interrupts_masked)) __mips_isr_sw0 ()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x2;

    mips32_biccr(CR_SINT0);     //clear software interrupt 0 flag

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x2;
}

void __attribute__ ((interrupt, keep_interrupts_masked)) __mips_isr_hw5 ()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x4;

    n++;
    mipsTimerReset();

    mips32_biscr(CR_SINT0);     //request for software interrupt 0
    mips32_biscr(CR_SINT1);     //request for software interrupt 1

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
