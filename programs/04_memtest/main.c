
#include "mfp_memory_mapped_registers.h"
#include <stdint.h>

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

void cacheFlush(uint32_t *addr)
{
    __asm__ volatile(
        "cache 0x15, 0(%[ADDR])" "\n\t"
        : : [ADDR] "r" (addr)
    );
}

int main ()
{
    //testmench 
    // const uint32_t  arrSize  = 200;
    // const uint32_t  delayCnt = 10;
    // const uint8_t   checkCnt = 0x02;

    //hw recommended
    const uint32_t  arrSize  = 10*1024*1024; //4*10M
    const uint32_t  delayCnt = 1000000;
    const uint8_t   checkCnt = 0xff;
    
    uint16_t errCount = 0;
    uint32_t arr[arrSize];

    //write to mem
    stepOut(0);
    for (uint32_t i = 0; i < arrSize; i++)
        arr[i] = i;

    //check
    for (uint8_t j = 0; j < checkCnt; j++)
    {
        //flush cache
        stepOut(1);
        for (uint32_t i = 0; i < arrSize; i++)
            cacheFlush(&arr[i]);

        //delay
        stepOut(2);
        _delay(delayCnt);

        //read
        stepOut(3);
        for (uint32_t i = 0; i < arrSize; i++) {
            if(arr[i] != i){
                errCount++;
                statOut(j, errCount);
            }
        }
        statOut(j, errCount);
    }
        
    //end
    stepOut(4);
    for(;;);
    //return 0;
}
