#include <stdint.h>
#include <mips/cpu.h>

#include "mfp_memory_mapped_registers.h"
#include "adc_m10.h"

// config start

#define MIPS_TIMER_PERIOD   0x200

// config end

void adcInit(void)
{
    MFP_ADCM10_ADMSK = ( ADMSK1 );
    MFP_ADCM10_ADCS  = ( ADCS_EN | ADCS_IE );
}

void adcMeasure(void)
{
    MFP_ADCM10_ADCS |= ( ADCS_SC );
}

uint16_t adcValue(void)
{
    return MFP_ADCM10_ADC1;
}

void adcReset(void)
{
    MFP_ADCM10_ADCS |= ( ADCS_IF );
}

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
    //vector mode, multiple handlers
    mips32_bicsr (SR_BEV);              // Status.BEV  0 - place handlers in kseg0 (0x80000000)
    mips32_biscr (CR_IV);               // Cause.IV,   1 - special int vector (offset 0x200), 
                                        //                 where 0x200 - base for other vectors

    uint32_t intCtl = mips32_getintctl();       // get IntCtl reg value
    mips32_setintctl(intCtl | INTCTL_VS_32);    // set interrupt table vector spacing (0x20 in our case)
                                                // see exceptions.S for details

    mips32_bissr (SR_IE | SR_HINT4 | SR_HINT5 ); // interrupt enable, HW4 - unmasked
}

EH_GENERAL()
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x1;

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x1;
}

ISR(IH_ADC)
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x2;
    MFP_7_SEGMENT_HEX = adcValue();
    adcReset();
    MFP_RED_LEDS = MFP_RED_LEDS & ~0x2;
}

ISR(IH_TIMER)
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x4;
    adcMeasure();
    mipsTimerReset();
    MFP_RED_LEDS = MFP_RED_LEDS & ~0x4;
}


int main ()
{
    adcInit();
    mipsTimerInit();
    mipsInterruptInit();

    for (;;);

    return 0;
}
