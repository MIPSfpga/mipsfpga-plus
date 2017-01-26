

#include "mfp_memory_mapped_registers.h"
#include <stdint.h>
#include <mips/cpu.h>
#include <m32cache.h>

// int mips_dcache_size;
// int m32_size_cache;
// int mips_dcache_linesize;

void _delay(uint32_t val)
{
    for (uint32_t i = 0; i < val; i++);
}

void statOut(uint8_t iterationNum, uint16_t errCount)
{
    uint32_t out = (((uint32_t)iterationNum) << 16) + errCount;
    MFP_7_SEGMENT_HEX = out;
}

void stepOut(uint8_t stepNum)
{
    uint16_t out = (1 << stepNum);
    MFP_RED_LEDS   = out;
    MFP_GREEN_LEDS = out;
}

int main ()
{
    const uint32_t arrSize = 100;//1000000;
    const uint32_t delayCnt = 10;//100000000;
    
    uint16_t errCount = 0;
    volatile uint32_t arr[arrSize];

    //write
    stepOut(0);
    for (uint32_t i = 0; i < arrSize; i++)
        arr[i] = i;
    //mips_flush_dcache();

    //delay
    stepOut(1);
    _delay(delayCnt);

    //check
    stepOut(2);
    for (uint32_t i = 0; i < arrSize; i++) {
        if(arr[i] != i){
            errCount++;
            statOut(0, errCount);
        }
    }
        
    //end
    stepOut(4);
    for (;;);
    //return 0;
}
