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
#define MFP_EIC_RN_EIACM_0      (14 << 2)  // external interrupt input pin register (31 - 0 )
#define MFP_EIC_RN_EIACM_1      (15 << 2)  // external interrupt input pin register (63 - 32)

#define _MEM_ADDR(x)            (* (volatile unsigned *)(x))

//EIC registers
#define MFP_EIC_EICR            _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EICR     )
#define MFP_EIC_EIMSK_0         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIMSK_0  )
#define MFP_EIC_EIMSK_1         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIMSK_1  )
#define MFP_EIC_EIFR_0          _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFR_0   )
#define MFP_EIC_EIFR_1          _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFR_1   )
#define MFP_EIC_EIFRS_0         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRS_0  )
#define MFP_EIC_EIFRS_1         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRS_1  )
#define MFP_EIC_EIFRC_0         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRC_0  )
#define MFP_EIC_EIFRC_1         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIFRC_1  )
#define MFP_EIC_EISMSK_0        _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EISMSK_0 )
#define MFP_EIC_EISMSK_1        _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EISMSK_1 )
#define MFP_EIC_EIIPR_0         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIIPR_0  )
#define MFP_EIC_EIIPR_1         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIIPR_1  )
#define MFP_EIC_EIACM_0         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIACM_0  )
#define MFP_EIC_EIACM_1         _MEM_ADDR( MFP_EIC_BASE_ADDR + MFP_EIC_RN_EIACM_1  )

//interrupt flags
#define IRQSW0      0
#define IRQSW1      1
#define IRQTIMER    7
#define IRQ63       31

#define SMSKSW0     (2*IRQSW0)
#define SMSKSW1     (2*IRQSW1)
#define SMSKTIMER   (2*IRQTIMER)

#define SMSK_LOW    0       // The low level of signalIn generates an interrupt request
#define SMSK_ANY    1       // Any logical change on signalIn generates an interrupt request
#define SMSK_FALL   2       // The falling edge of signalIn generates an interrupt request
#define SMSK_RIZE   3       // The rising edge of signalIn generates an interrupt request

#define IH_SW0      __mips_isr_eic0()
#define IH_SW1      __mips_isr_eic1()
#define IH_TIMER    __mips_isr_eic7()
#define IH_IRQ63    __mips_isr_eic63()

#define EH_GENERAL()    void __attribute__ ((interrupt, keep_interrupts_masked)) _mips_general_exception()
#define ISR(x)          void __attribute__ ((interrupt, keep_interrupts_masked)) x

#endif
