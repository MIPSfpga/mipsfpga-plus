
#include "mfp_memory_mapped_registers.h"
#include "uart16550.h"
#include <stdint.h>

#define SIMULATION  0
#define HARDWARE    1

// config start

#define RUNTYPE     SIMULATION

// config end

// The devisor value set should be equal to 
// (system clock speed) / (16 x desired baud rate).
#define DIVISOR_50M     (50*1000*1000 / (16*115200))
#define DIVISOR_SIM     1

#if     RUNTYPE == SIMULATION
    #define UART_DIVISOR    DIVISOR_SIM
#elif   RUNTYPE == HARDWARE
    #define UART_DIVISOR    DIVISOR_50M
#endif

void uartInit(uint16_t divisor)
{
    MFP_UART_LCR = MFP_UART_LCR_8N1;      // 8n1
    MFP_UART_LCR |= MFP_UART_LCR_LATCH;   // Divisor Latches access enable
    MFP_UART_DLL = divisor & 0xFF;        // Divisor LSB
    MFP_UART_DLH = (divisor >> 8) & 0xff; // Divisor MSB
    MFP_UART_LCR &= ~MFP_UART_LCR_LATCH;  // Divisor Latches access disable
}

void uartTransmit(uint8_t data)
{
    // waiting for transmitter fifo empty
    while (!(MFP_UART_LSR & MFP_UART_LSR_TFE));

    // transmitted data
    MFP_UART_TXR = data;
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

void uartWrite(const char str[])
{
    while(*str)
        uartTransmit(*str++);
}

int main ()
{
    // init
    const uint16_t uartDivisor = UART_DIVISOR;
    uartInit(uartDivisor);

    // say Hello after reset
    uartWrite("Hello!");

    // received data output and loopback
    for(;;)
    {
        uint8_t data = uartReceive();
        receivedDataOutput(data);

        #if   RUNTYPE == HARDWARE
        uartTransmit(data);
        #endif
    }
}
