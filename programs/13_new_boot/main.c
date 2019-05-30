#include "mfp_memory_mapped_registers.h"

int main ()
{
    int n = 0;

    for (;;)
    {
        MFP_RED_LEDS      = MFP_LIGHT_SENSOR >> 4;
        MFP_7_SEGMENT_HEX = MFP_LIGHT_SENSOR;
        MFP_GREEN_LEDS    = n ++;
    }

    return 0;
}
