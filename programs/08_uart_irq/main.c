
#include "mfp_memory_mapped_registers.h"
#include <stdint.h>
#include <mips/cpu.h>
#include "uart16550.h"

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

    MFP_UART_IER = MFP_UART_IER_RDA;      //enable Received Data available interrupt
    MFP_UART_FCR = MFP_UART_FCR_ITL4;     //set 4 byte Receiver FIFO Interrupt trigger level
}

void uartTransmit(uint8_t data)
{
    while (!(MFP_UART_LSR & MFP_UART_LSR_TFE)); // waiting for transmitter fifo empty
    MFP_UART_TXR = data;                        // data transmit
}

void receivedDataOutput(uint8_t data)
{
    MFP_RED_LEDS        = data;
    MFP_GREEN_LEDS      = data;
    MFP_7_SEGMENT_HEX   = data;
}

void uartReceive(void)
{
    while (MFP_UART_LSR & MFP_UART_LSR_DR)      // is there something in receiver fifo?
    {
        uint8_t data = MFP_UART_RXR;            // data receive
        receivedDataOutput(data);

        #if   RUNTYPE == HARDWARE
        uartTransmit(data);
        #endif
    }
}

void mipsInterruptInit(void)
{
    //vector mode multiple handlers
    mips32_bicsr (SR_BEV);              // Status.BEV  0 - vector interrupt mode
    mips32_biscr (CR_IV);               // Cause.IV,   1 - special int vector (0x200), where 0x200 - base when Status.BEV = 0;

    uint32_t intCtl = mips32_getintctl();       // get IntCtl reg value
    mips32_setintctl(intCtl | INTCTL_VS_32);    // set interrupt table vector spacing (0x20 in our case)
                                                // see exceptions.S for details

    mips32_bissr (SR_IE | SR_HINT3); // interrupt enable, HW3 unmasked
}

// uart interrupt handler
void __attribute__ ((interrupt, keep_interrupts_masked)) __mips_isr_hw3 ()
{
    // Receiver Data available interrupt handler
    if(MFP_UART_IIR & MFP_UART_IIR_RDA)
        uartReceive();
}

void uartWrite(const char str[])
{
    while(*str)
        uartTransmit(*str++);
}

int main ()
{
    const uint16_t uartDivisor = UART_DIVISOR;

    uartInit(uartDivisor);
    mipsInterruptInit();

    // say Hello after reset
    uartWrite("Hello!");

    //received data output and loopback
    while(1);
}
