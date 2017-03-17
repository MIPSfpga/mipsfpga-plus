#ifndef MFP_EIC_H
#define MFP_EIC_H

#define MFP_EIC_BASE_ADDR       0xB0402000

#define MFP_EIC_RN_EICR         (1  << 2)  // external interrupt control register
#define MFP_EIC_RN_EIMSK_0      (2  << 2)  // external interrupt mask register (31 - 0 )
#define MFP_EIC_RN_EIMSK_1      (3  << 2)  // external interrupt mask register (63 - 32)
#define MFP_EIC_RN_EIFR_0       (4  << 2)  // external interrupt flag register (31 - 0 )
#define MFP_EIC_RN_EIFR_1       (5  << 2)  // external interrupt flag register (63 - 32)
#define MFP_EIC_RN_EIFRS_0      (6  << 2)  // external interrupt flag register, bit set (31 - 0 )
#define MFP_EIC_RN_EIFRS_1      (7  << 2)  // external interrupt flag register, bit set (63 - 32)
#define MFP_EIC_RN_EIFRC_0      (8  << 2)  // external interrupt flag register, bit clear (31 - 0 )
#define MFP_EIC_RN_EIFRC_1      (9  << 2)  // external interrupt flag register, bit clear (63 - 32)
#define MFP_EIC_RN_EISMSK_0     (10 << 2)  // external interrupt sense mask register (31 - 0 )
#define MFP_EIC_RN_EISMSK_1     (11 << 2)  // external interrupt sense mask register (63 - 32)
#define MFP_EIC_RN_EIIPR_0      (12 << 2)  // external interrupt input pin register (31 - 0 )
#define MFP_EIC_RN_EIIPR_1      (13 << 2)  // external interrupt input pin register (63 - 32)

#define _MEM_ADDR(x)            (* (volatile unsigned *)(x))

#define MFP_EIC_EICR            _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EICR)
#define MFP_EIC_EIMSK_0         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIMSK_0)
#define MFP_EIC_EIMSK_1         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIMSK_1)
#define MFP_EIC_EIFR_0          _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFR_0)
#define MFP_EIC_EIFR_1          _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFR_1)
#define MFP_EIC_EIFRS_0         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRS_0)
#define MFP_EIC_EIFRS_1         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRS_1)
#define MFP_EIC_EIFRC_0         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRC_0)
#define MFP_EIC_EIFRC_1         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRC_1)
#define MFP_EIC_EISMSK_0        _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EISMSK_0)
#define MFP_EIC_EISMSK_1        _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EISMSK_1)
#define MFP_EIC_EIIPR_0         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIIPR_0)
#define MFP_EIC_EIIPR_1         _MEM_ADDR(MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIIPR_1)

#endif


// #ifndef MFP_MEMORY_MAPPED_REGISTERS_H
// #define MFP_MEMORY_MAPPED_REGISTERS_H

// #define MFP_RED_LEDS_ADDR       0xBF800000
// #define MFP_GREEN_LEDS_ADDR     0xBF800004
// #define MFP_SWITCHES_ADDR       0xBF800008
// #define MFP_BUTTONS_ADDR        0xBF80000C
// #define MFP_7_SEGMENT_HEX_ADDR  0xBF800010

// #define MFP_RED_LEDS            (* (volatile unsigned *) MFP_RED_LEDS_ADDR      )
// #define MFP_GREEN_LEDS          (* (volatile unsigned *) MFP_GREEN_LEDS_ADDR    )
// #define MFP_SWITCHES            (* (volatile unsigned *) MFP_SWITCHES_ADDR      )
// #define MFP_BUTTONS             (* (volatile unsigned *) MFP_BUTTONS_ADDR       )
// #define MFP_7_SEGMENT_HEX       (* (volatile unsigned *) MFP_7_SEGMENT_HEX_ADDR )

// // This define is used in boot.S code

// #define BOARD_16_LEDS_ADDR      MFP_RED_LEDS_ADDR

// #endif
