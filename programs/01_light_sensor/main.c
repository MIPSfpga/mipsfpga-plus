#include "mfp_memory_mapped_registers.h"

#define DELAY_VALUE (10*1024*1024)

void inline delay()
{
    for (long i=0; i < DELAY_VALUE ; i++);
}

int main ()
{
    int n = 0;

    for (;;)
    {
        MFP_RED_LEDS      = MFP_LIGHT_SENSOR >> 4;
        MFP_7_SEGMENT_HEX = MFP_LIGHT_SENSOR;
        MFP_GREEN_LEDS    = n ++;

        delay();
    }

    return 0;
}
