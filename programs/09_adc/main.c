#include <stdint.h>
#include <mips/cpu.h>

#include "mfp_memory_mapped_registers.h"
#include "adc_m10.h"

#define SIMULATION  0
#define HARDWARE    1

// config start

#define RUNTYPE     SIMULATION

// config end

#define PERIOD_200  200
#define PERIOD_4M   (4*1000*1000)

#if     RUNTYPE == SIMULATION
    #define MIPS_TIMER_PERIOD    PERIOD_200
#elif   RUNTYPE == HARDWARE
    #define MIPS_TIMER_PERIOD    PERIOD_4M
#endif

// interrupt functions
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

    // interrupt enable, HW4, HW5 - unmasked
    mips32_bissr (SR_IE | SR_HINT4 | SR_HINT5 ); 
}

// ADC functions
void adcInit(void)
{
    // unmask ADC channels 1-4
    MFP_ADCM10_ADMSK = ( ADMSK1 | ADMSK2 | ADMSK3 | ADMSK4 );
    // enable ADC module and ADC interrupt
    MFP_ADCM10_ADCS  = ( ADCS_EN | ADCS_IE );
}

void adcStart(void)
{
    //start ADC conversion
    MFP_ADCM10_ADCS |= ( ADCS_SC );
}

void adcOutput(void)
{
    uint16_t val;

    //get switch value (channel selector)
    switch(MFP_SWITCHES)
    {
        //get ADC value
        default: val = MFP_ADCM10_ADC1; break;
        case  1: val = MFP_ADCM10_ADC2; break;
        case  2: val = MFP_ADCM10_ADC3; break;
        case  3: val = MFP_ADCM10_ADC4; break;
    }

    //value output
    MFP_7_SEGMENT_HEX = val >> 4;

    //reset the ADC interrupt flag
    MFP_ADCM10_ADCS |= ( ADCS_IF );
}

//interrupt handlers
ISR(IH_TIMER)
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x1;

    adcStart();
    mipsTimerReset();

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x1;
}

ISR(IH_ADC)
{
    MFP_RED_LEDS = MFP_RED_LEDS | 0x2;

    adcOutput();

    MFP_RED_LEDS = MFP_RED_LEDS & ~0x2;
}

int main ()
{
    adcInit();
    mipsTimerInit();
    mipsInterruptInit();

    for (;;);

    return 0;
}
