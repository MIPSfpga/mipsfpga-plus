#include <stdint.h>
#include <mips/cpu.h>

#include "eic.h"
#include "mfp_memory_mapped_registers.h"

// config start

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
    //eic mode
    //unmask interrupt
    MFP_EIC_EIMSK_0     = (1 << IRQSW0) | (1 << IRQSW1) | (1 << IRQTIMER);
    MFP_EIC_EIMSK_1     = (1 << IRQ63);
    //enable auto clear  
    MFP_EIC_EIACM_0     = (1 << IRQSW0) | (1 << IRQSW1) | (1 << IRQTIMER);
    //set interrupt on rising edge of the signal
    MFP_EIC_EISMSK_0    = (SMSK_RIZE << SMSKSW0) | (SMSK_RIZE << SMSKSW1) | (SMSK_RIZE << SMSKTIMER);

    mips32_bicsr (SR_BEV);                      // Status.BEV  0 - vector interrupt mode
    mips32_biscr (CR_IV);                       // Cause.IV,   1 - special int vector (0x200), where 0x200 - base when Status.BEV = 0;

    uint32_t intCtl = mips32_getintctl();       // get IntCtl reg value
    mips32_setintctl(intCtl | INTCTL_VS_32);    // set interrupt table vector spacing (0x20 in our case)
                                                // see exceptions.S for details
    
    MFP_EIC_EICR = 0x1;                         // enable external interrupt controller
    mips32_bissr (SR_IE);                       // enable interrupts
}

volatile long long int n;

EH_GENERAL()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x2;

    uint32_t cause = mips32_getcr();

    //check that this is interrupt exception
    if((cause & CR_XMASK) == 0)
    {
        //check for software interrupt 1
        if (cause & CR_SINT1)
            mips32_biccr(CR_SINT1);     //clear software interrupt 1 flag
    }

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x2;
}

ISR(IH_SW0)
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x1;

    mips32_biccr(CR_SINT0);         //clear software interrupt 0 flag

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x1;
}

ISR(IH_TIMER)
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x4;

    n++;
    mipsTimerReset();

    mips32_biscr(CR_SINT0);         //request for software interrupt 0
    mips32_biscr(CR_SINT1);         //request for software interrupt 1
    MFP_EIC_EIFRS_1 = (1 << IRQ63); //request for external interrupt 63

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x4;
}

ISR(IH_IRQ63)
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x8;

    MFP_EIC_EIFRC_1 = (1 << IRQ63); //clear software external interrupt 63 
                                    //as auto clear was not turned on for this interrupt during init

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x8;
}

int main ()
{
    n = 0;
    mipsTimerInit();
    mipsInterruptInit();

    for (;;)
        MFP_7_SEGMENT_HEX = n;   //counter output

    return 0;
}
