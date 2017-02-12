
#include "mfp_memory_mapped_registers.h"
#include <stdint.h>

void _delay(uint32_t val)
{
    for (uint32_t i = 0; i < val; i++)
        __asm__ volatile("nop");
}

int main ()
{

    MFP_UART_LCR = 3;   //8n1
    MFP_UART_MCR = 3;   //DTR + RTS
    
    // some read problem
    //MFP_UART_LCR |= (1 << 7);

    MFP_UART_LCR = 3 | (1 << 7);
    MFP_UART_DLL = 1;
    MFP_UART_DLH = 0;

    MFP_UART_LCR = 3;
    // some read problem
    //MFP_UART_LCR &= ~(1 << 7);

    for(;;) 
    {
         MFP_UART_TXR = 0x11;
         _delay(1000);
    }
}
