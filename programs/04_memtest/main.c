
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
        :
        : [ADDR] "r" (addr)
    );
}

int main ()
{
    const uint32_t arrSize = 10;    //1000000;
    const uint32_t delayCnt = 10;  //100000000;
    const uint8_t checkCnt = 0x2;
    
    uint16_t errCount = 0;
    uint32_t arr[arrSize];

    //write to mem
    stepOut(0);
    for (uint32_t i = 0; i < arrSize; i++)
        arr[i] = i;

    //flush cache
     stepOut(1);
    for (uint32_t i = 0; i < arrSize; i++)
        cacheFlush(&arr[i]);

    
    //check
    for (uint8_t j = 0; j < checkCnt; j++)
    {
        //delay
        stepOut(2);
        _delay(delayCnt);

        //read
        stepOut(3);
        for (uint32_t i = 0; i < arrSize; i++) {
            if(arr[i] != i){
                errCount++;
                statOut(0, errCount);
            }
        }
    }
        
    //end
    stepOut(4);
    return 0;
}
