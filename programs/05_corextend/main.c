#include "mfp_memory_mapped_registers.h"

int main ()
{
    long long int n = 0;

    for (;;)
    {
        /*
        MFP_RED_LEDS      = n;
        MFP_GREEN_LEDS    = n;
        MFP_7_SEGMENT_HEX = n;
        */

        MFP_RED_LEDS   = n >> 16;
        MFP_GREEN_LEDS = n >> 16;
        MFP_7_SEGMENT_HEX = ((n >> 8) & 0xffffff00) | (n & 0xff);

        n ++;

        // asm ("mfc0 $8, $15, 0");
        // MFP_7_SEGMENT_HEX = 1;
    }

    return 0;
}
