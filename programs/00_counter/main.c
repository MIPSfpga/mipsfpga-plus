#include "mfp_memory_mapped_registers.h"

int main ()
{
    int n = 0;

    for (;;)
    {
        MFP_RED_LEDS   = n;
        MFP_GREEN_LEDS = n;
        n ++;
    }

    return 0;
}
