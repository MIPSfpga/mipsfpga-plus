#ifndef MFP_UART_16550_H
#define MFP_UART_16550_H

#define MFP_UART_BASE           0xB0401000

#define MFP_UART_TXR_ADDR       (MFP_UART_BASE + 0x00)      /*  Transmit register (WRITE) */
#define MFP_UART_RXR_ADDR       (MFP_UART_BASE + 0x00)      /*  Receive register  (READ)  */
#define MFP_UART_IER_ADDR       (MFP_UART_BASE + 0x04)      /*  Interrupt Enable          */
#define MFP_UART_IIR_ADDR       (MFP_UART_BASE + 0x08)      /*  Interrupt ID              */
#define MFP_UART_FCR_ADDR       (MFP_UART_BASE + 0x08)      /*  FIFO control              */
#define MFP_UART_LCR_ADDR       (MFP_UART_BASE + 0x0C)      /*  Line control              */
#define MFP_UART_MCR_ADDR       (MFP_UART_BASE + 0x10)      /*  Modem control             */
#define MFP_UART_LSR_ADDR       (MFP_UART_BASE + 0x14)      /*  Line Status               */
#define MFP_UART_MSR_ADDR       (MFP_UART_BASE + 0x1C)      /*  Modem Status              */
#define MFP_UART_DLL_ADDR       (MFP_UART_BASE + 0x00)      /*  Divisor Latch Low         */
#define MFP_UART_DLH_ADDR       (MFP_UART_BASE + 0x04)      /*  Divisor latch High        */

#define MFP_UART_LCR_LATCH      (1 << 7)        /* LCR Divisor Latch Access bit */
#define MFP_UART_LCR_8N1        3               /* 8N1 UART mode */
#define MFP_UART_MCR_DTR        (1 << 0)        /* Data Terminal Ready (DTR) signal control */
#define MFP_UART_MCR_RTS        (1 << 1)        /* Request To Send (RTS) signal control */
#define MFP_UART_LSR_DR         (1 << 0)        /* Data Ready (DR) indicator */
#define MFP_UART_LSR_TFE        (1 << 5)        /* Transmitter FIFO empty */
#define MFP_UART_IER_RDA        (1 << 0)        /* Received Data available interrupt enable */
#define MFP_UART_IIR_RDA        (1 << 2)        /* Receiver Data available interrupt */
#define MFP_UART_FCR_CLR        (1 << 1)        /* Clear Receiver FIFO */
#define MFP_UART_FCR_CLT        (1 << 2)        /* Clear Transmitter FIFO */
#define MFP_UART_FCR_ITL1       (0 << 6)        /* Receiver FIFO Interrupt trigger level - 1 byte */
#define MFP_UART_FCR_ITL4       (1 << 6)        /* Receiver FIFO Interrupt trigger level - 4 byte */
#define MFP_UART_FCR_ITL8       (2 << 6)        /* Receiver FIFO Interrupt trigger level - 8 byte */
#define MFP_UART_FCR_ITL14      (3 << 6)        /* Receiver FIFO Interrupt trigger level - 14 byte */

#define MFP_UART_TXR            (* (volatile unsigned *) MFP_UART_TXR_ADDR      )
#define MFP_UART_RXR            (* (volatile unsigned *) MFP_UART_RXR_ADDR      )
#define MFP_UART_IER            (* (volatile unsigned *) MFP_UART_IER_ADDR      )
#define MFP_UART_IIR            (* (volatile unsigned *) MFP_UART_IIR_ADDR      )
#define MFP_UART_LCR            (* (volatile unsigned *) MFP_UART_LCR_ADDR      )
#define MFP_UART_MCR            (* (volatile unsigned *) MFP_UART_MCR_ADDR      )
#define MFP_UART_LSR            (* (volatile unsigned *) MFP_UART_LSR_ADDR      )
#define MFP_UART_MSR            (* (volatile unsigned *) MFP_UART_MSR_ADDR      )
#define MFP_UART_DLL            (* (volatile unsigned *) MFP_UART_DLL_ADDR      )
#define MFP_UART_DLH            (* (volatile unsigned *) MFP_UART_DLH_ADDR      )
#define MFP_UART_FCR            (* (volatile unsigned *) MFP_UART_FCR_ADDR      )

#endif