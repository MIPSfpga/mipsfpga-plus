
#include "mfp_memory_mapped_registers.h"
#include <stdint.h>

#define SIMULATION  0
#define SDRAM_64M   64

#define MEMTYPE SIMULATION

#if     MEMTYPE == SIMULATION
    #define TEST_ARRSIZE    200   
    #define TEST_DELAY      10
    #define TEST_COUNT      2
#elif   MEMTYPE == SDRAM_64M
    #define TEST_ARRSIZE    (10*1024*1024)   /* Size = sizeof(uint32_t)*10M = 40M */
    #define TEST_DELAY      1000000
    #define TEST_COUNT      0xff
#endif

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
    const uint32_t  arrSize  = TEST_ARRSIZE;
    const uint32_t  delayCnt = TEST_DELAY;
    const uint8_t   checkCnt = TEST_COUNT;
    
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
