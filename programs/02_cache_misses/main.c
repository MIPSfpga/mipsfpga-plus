#include "mfp_memory_mapped_registers.h"

int a [8][8];

int main ()
{
    int n = 0;

    for (;;)
    {
        // Wait for switch 2

        while ((MFP_SWITCHES & 4) == 0)
            ;

        if (MFP_SWITCHES & 8)
        {
            for (i = 0; i < 8; i ++)
                for (i = 0; i < 8; i ++)
                    a [i][j] = i + j;
        }
        else
        {
            for (i = 0; i < 8; i ++)
                for (i = 0; i < 8; i ++)
                    a [j][i] = i + j;
        }
    }

    return 0;
}
