#include "mfp_memory_mapped_registers.h"

int main ()
{
    long long int n = 0;

    for (;;)
    {
        long long int val = ((n >> 8) & 0xffffff00) | (n & 0xff);

        MFP_RED_LEDS      = val;
        MFP_GREEN_LEDS    = MFP_RED_LEDS;
        MFP_7_SEGMENT_HEX = val;

        n ++;
    }

    return 0;
}
