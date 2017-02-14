
#include "mfp_memory_mapped_registers.h"
#include <stdint.h>


// The devisor value set should be equal to 
// (system clock speed) / (16 x desired baud rate).
#define DIVISOR_50M     (50*1000*1000 / (16*115200))
#define DIVISOR_SIM     1

// config start

#define UART_DIVISOR    DIVISOR_50M

// config end

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
    // transmitted data
    MFP_UART_TXR = data;
    // waiting for transmitter fifo empty
    while (!(MFP_UART_LSR & MFP_UART_LSR_TFE));
}

void receivedDataOutput(uint8_t data)
{
    MFP_RED_LEDS        = data;
    MFP_GREEN_LEDS      = data;
    MFP_7_SEGMENT_HEX   = data;
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
    const uint16_t uartDivisor = UART_DIVISOR;

    uartInit(uartDivisor);

    //say Hello after reset
    uartTransmit('H');
    uartTransmit('e');
    uartTransmit('l');
    uartTransmit('l');
    uartTransmit('o');
    uartTransmit('!');

    //received data output and loopback
    for(;;)
    {
        uint8_t data = uartReceive();
        receivedDataOutput(data);
        uartTransmit(data);
    }
}
