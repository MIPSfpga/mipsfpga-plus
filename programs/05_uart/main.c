
#include "mfp_memory_mapped_registers.h"
#include <stdint.h>

void _delay(uint32_t val)
{
    for (uint32_t i = 0; i < val; i++)
        __asm__ volatile("nop");
}

void uartInit(uint16_t divisor)
{
    MFP_UART_LCR = MFP_UART_LCR_8N1;                    // 8n1
    MFP_UART_MCR = MFP_UART_MCR_DTR | MFP_UART_MCR_RTS; // DTR + RTS

    MFP_UART_LCR |= MFP_UART_LCR_LATCH;   // Divisor Latches access enable
    MFP_UART_DLL = divisor & 0xFF;        // Divisor LSB
    MFP_UART_DLH = (divisor >> 8) & 0xff; // Divisor MSB
    MFP_UART_LCR &= ~MFP_UART_LCR_LATCH;  // Divisor Latches access disable
}

void uartTransmit(uint8_t data)
{
    MFP_UART_TXR = data;        // transmitted data
}

uint8_t uartReceive(void)
{
    //waiting for RX data
    while (!(MFP_UART_LSR & MFP_UART_LSR_DR));
    //returning received data
    return MFP_UART_RXR;
}

int main ()
{
    const uint16_t uartDivisor = 1;

    //uart init
    uartInit(uartDivisor);

    //uart transmit
    uartTransmit(0x11);

    //received data output
    MFP_RED_LEDS = uartReceive();

    for(;;);
}
