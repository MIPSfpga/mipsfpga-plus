#ifndef MFP_MEMORY_MAPPED_REGISTERS_H
#define MFP_MEMORY_MAPPED_REGISTERS_H

#define MFP_RED_LEDS_ADDR       0xBF800000
#define MFP_GREEN_LEDS_ADDR     0xBF800004
#define MFP_SWITCHES_ADDR       0xBF800008
#define MFP_BUTTONS_ADDR        0xBF80000C
#define MFP_7_SEGMENT_HEX_ADDR  0xBF800010

#define MFP_UART_TXR_ADDR       0xB0401000      /*  Transmit register (WRITE) */
#define MFP_UART_RXR_ADDR       0xB0401000      /*  Receive register  (READ)  */
#define MFP_UART_IER_ADDR       0xB0401004      /*  Interrupt Enable          */
#define MFP_UART_IIR_ADDR       0xB0401008      /*  Interrupt ID              */
#define MFP_UART_FCR_ADDR       0xB0401008      /*  FIFO control              */
#define MFP_UART_LCR_ADDR       0xB040100C      /*  Line control              */
#define MFP_UART_MCR_ADDR       0xB0401010      /*  Modem control             */
#define MFP_UART_LSR_ADDR       0xB0401014      /*  Line Status               */
#define MFP_UART_MSR_ADDR       0xB040101C      /*  Modem Status              */
#define MFP_UART_DLL_ADDR       0xB0401000      /*  Divisor Latch Low         */
#define MFP_UART_DLH_ADDR       0xB0401004      /*  Divisor latch High        */

#define MFP_UART_LCR_LATCH      (1 << 7)        /* LCR Divisor Latch Access bit */
#define MFP_UART_LCR_8N1        3               /* 8N1 UART mode */
#define MFP_UART_MCR_DTR        (1 << 0)        /* Data Terminal Ready (DTR) signal control */
#define MFP_UART_MCR_RTS        (1 << 1)        /* Request To Send (RTS) signal control */
#define MFP_UART_LSR_DR         (1 << 0)        /* Data Ready (DR) indicator */
#define MFP_UART_LSR_TFE        (1 << 5)        /* Transmitter FIFO empty */
#define MFP_UART_IER_RDA        (1 << 0)        /* Received Data available interrupt enable */
#define MFP_UART_IIR_RDA        (1 << 2)        /* Receiver Data available interrupt */

#define MFP_RED_LEDS            (* (volatile unsigned *) MFP_RED_LEDS_ADDR      )
#define MFP_GREEN_LEDS          (* (volatile unsigned *) MFP_GREEN_LEDS_ADDR    )
#define MFP_SWITCHES            (* (volatile unsigned *) MFP_SWITCHES_ADDR      )
#define MFP_BUTTONS             (* (volatile unsigned *) MFP_BUTTONS_ADDR       )
#define MFP_7_SEGMENT_HEX       (* (volatile unsigned *) MFP_7_SEGMENT_HEX_ADDR )

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

// This define is used in boot.S code

#define BOARD_16_LEDS_ADDR      MFP_RED_LEDS_ADDR

#endif
