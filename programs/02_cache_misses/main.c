#include "mfp_memory_mapped_registers.h"

int a [8][8];

int main ()
{
    int n = 0;
    int i, j;

    // Wait for switch 2

    while ((MFP_SWITCHES & 4) == 0)
        ;


    for (i = 0; i < 8; i ++)
        for (j = 0; j < 8; j ++)
            // a [i][j] = i + j;
            a [j][i] = i + j;

    return 0;
}
