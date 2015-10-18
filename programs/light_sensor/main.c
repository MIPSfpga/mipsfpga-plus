#include "mfp_memory_mapped_registers.h"

void delay ()
{
    if (MFP_SWITCHES & 0x100)
    {
        // No delay
    }
    else
    {
        volatile i;

        for (i = 0; i < 1000000; i ++)
            ;
    }
}

int main ()
{
    int n = 0;

    for (;;)
    {
        MFP_RED_LEDS   = MFP_LIGHT_SENSOR;
        MFP_GREEN_LEDS = MFP_LIGHT_SENSOR;

        delay ();

        n ++;
    }

    return 0;
}
