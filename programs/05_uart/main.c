
#include "mfp_memory_mapped_registers.h"
#include <stdint.h>

void _delay(uint32_t val)
{
    for (uint32_t i = 0; i < val; i++)
        __asm__ volatile("nop");
}

int main ()
{
    //uart init
    MFP_UART_LCR = MFP_UART_LCR_8N1;                    // 8n1
    MFP_UART_MCR = MFP_UART_MCR_DTR | MFP_UART_MCR_RTS; // DTR + RTS

    MFP_UART_LCR |= MFP_UART_LCR_LATCH;   // Divisor Latches access enable
    MFP_UART_DLL = 1;                     // Divisor LSB
    MFP_UART_DLH = 0;                     // Divisor MSB
    MFP_UART_LCR &= ~MFP_UART_LCR_LATCH;  // Divisor Latches access disable

    //uart transmit
    MFP_UART_TXR = 0x11;        // transmitted data

    //waiting for RX data
    while (!(MFP_UART_LSR & MFP_UART_LSR_DR));

    //received data output
    MFP_RED_LEDS = MFP_UART_RXR;

    for(;;);
}
