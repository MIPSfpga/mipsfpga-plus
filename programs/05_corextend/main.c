#include <stdint.h>
#include <mips/mips32.h>

#include "corextend.h"
#include "mfp_memory_mapped_registers.h"

//----------------------------------------------------------------------------

#define ms(n0, w0, n1, w1, n2, w2, n3, w3)  \
    (((n0) * (w0) + (n1) * (w1) + (n2) * (w2) + (n3) * (w3)) & 0xff)

uint32_t __attribute__ ((noinline)) software_only_implementation
(
    uint32_t n0,
    uint32_t n1,
    uint32_t n2,
    uint32_t n3
)
{
    return ms
           (
               ms (n0,  0, n1,  4,  n2,  8, n3, 12),
               7,
               ms (n1,  1, n2,  5,  n3,  9, n0, 13),
               5,
               ms (n2,  2, n3,  6,  n0, 10, n1, 14),
               3,
               ms (n3,  3, n0,  7,  n1, 11, n2, 15),
               1
           );
}

//----------------------------------------------------------------------------

#define mh(n0, w0, n1, w1, n2, w2, n3, w3)                         \
        __extension__                                              \
        ({                                                         \
            uint32_t w;                                            \
                                                                   \
            w = _mips32r2_ins (n0, n1,  8, 8);                     \
            w = _mips32r2_ins ( w, n2, 16, 8);                     \
            w = _mips32r2_ins ( w, n3, 24, 8);                     \
                                                                   \
            w = mips_udi_rs_imm16 (0, w,                           \
                (w0) | ((w1) << 4) | ((w2) << 8) | ((w3) << 12));  \
                                                                   \
            w;                                                     \
        })

//----------------------------------------------------------------------------
                                                                    
uint32_t __attribute__ ((noinline)) hardware_accelerated_implementation
(
    uint32_t n0,
    uint32_t n1,
    uint32_t n2,
    uint32_t n3
)
{
    return mh
           (
               mh (n0,  0, n1,  4,  n2,  8, n3, 12),
               7,
               mh (n1,  1, n2,  5,  n3,  9, n0, 13),
               5,
               mh (n2,  2, n3,  6,  n0, 10, n1, 14),
               3,
               mh (n3,  3, n0,  7,  n1, 11, n2, 15),
               1
           );
}

//----------------------------------------------------------------------------

int main ()
{
    uint32_t i, os, oh;

    for (;;)
    {
        i = MFP_SWITCHES ^ 0x123;

        MFP_GREEN_LEDS = 0x11;

        os = software_only_implementation
             (
                  i       & 0xff,
                 (i >> 1) & 0xff,
                 (i >> 2) & 0xff,
                 (i >> 3) & 0xff
             );

        MFP_GREEN_LEDS = 0x22;

        oh = hardware_accelerated_implementation
             (
                  i       & 0xff,
                 (i >> 1) & 0xff,
                 (i >> 2) & 0xff,
                 (i >> 3) & 0xff
             );

        MFP_GREEN_LEDS = 0x33;

        MFP_7_SEGMENT_HEX = (oh << 8) | os;
    }

    return 0;
}
