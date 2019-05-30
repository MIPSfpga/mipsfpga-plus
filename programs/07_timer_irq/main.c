#include <stdint.h>
#include <mips/cpu.h>

#include "mfp_memory_mapped_registers.h"

// run types
#define COMPATIBILITY   0
#define VECTOR          1

// config start

#define RUNTYPE             VECTOR
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
    mips32_setcompare(MIPS_TIMER_PERIOD);   //clear timer interrupt flag
}

void mipsInterruptInit(void)
{
    #if     RUNTYPE == COMPATIBILITY
        //compatibility mode, one common handler
        mips32_bicsr (SR_BEV);              // Status.BEV  0 - place handlers in kseg0 (0x80000000)
        mips32_biccr (CR_IV);               // Cause.IV,   0 - general exception handler (offset 0x180)
        mips32_bissr (SR_IE | SR_HINT5 | SR_SINT1);    // interrupt enable, HW5,SW1 - unmasked

    #elif   RUNTYPE == VECTOR
        //vector mode, multiple handlers
        mips32_bicsr (SR_BEV);              // Status.BEV  0 - place handlers in kseg0 (0x80000000)
        mips32_biscr (CR_IV);               // Cause.IV,   1 - special int vector (offset 0x200), 
                                            //                 where 0x200 - base for other vectors

        uint32_t intCtl = mips32_getintctl();       // get IntCtl reg value
        mips32_setintctl(intCtl | INTCTL_VS_32);    // set interrupt table vector spacing (0x20 in our case)
                                                    // see exceptions.S for details

        mips32_bissr (SR_IE | SR_HINT5 | SR_SINT0 | SR_SINT1); // interrupt enable, HW5 and SW0,SW1 - unmasked
    #endif
}

volatile uint32_t n;

void __attribute__ ((interrupt, keep_interrupts_masked)) _mips_general_exception ()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x1;

    uint32_t cause = mips32_getcr();

    //check that this is interrupt exception
    if((cause & CR_XMASK) == 0)
    {
        //check for timer interrupt
        if(cause & CR_HINT5)
        {
            MFP_RED_LEDS = MFP_RED_LEDS | 0x10;
            n++;
            mipsTimerReset();

            mips32_biscr(CR_SINT1);     //request for software interrupt 1
            MFP_RED_LEDS = MFP_RED_LEDS & ~0x10;
        }
        //check for software interrupt 1
        else if (cause & CR_SINT1)
        {
            MFP_RED_LEDS = MFP_RED_LEDS | 0x8;
            mips32_biccr(CR_SINT1);     //clear software interrupt 1 flag
            MFP_RED_LEDS = MFP_RED_LEDS & ~0x8;
        }
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
        MFP_7_SEGMENT_HEX = n;

    return 0;
}
