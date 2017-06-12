#ifndef MFP_ADCM10_H
#define MFP_ADCM10_H

#define MFP_ADCM10_BASE_ADDR    0xB0403000

// ADC registers addr offset
#define MFP_ADCM10_RN_ADCS      (1  << 2)   // ADC control and status
#define MFP_ADCM10_RN_ADMSK     (2  << 2)   // ADC channel mask
#define MFP_ADCM10_RN_ADC0      (3  << 2)   // ADC channel 0 conversion results
#define MFP_ADCM10_RN_ADC1      (4  << 2)   // ADC channel 1 conversion results
#define MFP_ADCM10_RN_ADC2      (5  << 2)   // ADC channel 2 conversion results
#define MFP_ADCM10_RN_ADC3      (6  << 2)   // ADC channel 3 conversion results
#define MFP_ADCM10_RN_ADC4      (7  << 2)   // ADC channel 4 conversion results
#define MFP_ADCM10_RN_ADC5      (8  << 2)   // ADC channel 5 conversion results
#define MFP_ADCM10_RN_ADC6      (9  << 2)   // ADC channel 6 conversion results
#define MFP_ADCM10_RN_ADC7      (10 << 2)   // ADC channel 7 conversion results
#define MFP_ADCM10_RN_ADC8      (11 << 2)   // ADC channel 8 conversion results
#define MFP_ADCM10_RN_ADCT      (12 << 2)   // ADC temperature channel conversion results

#define _MEM_ADDR(x)            (* (volatile unsigned *)(x))

// ADC registers
#define MFP_ADCM10_ADCS     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADCS  )
#define MFP_ADCM10_ADMSK    _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADMSK )
#define MFP_ADCM10_ADC0     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC0  )
#define MFP_ADCM10_ADC1     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC1  )
#define MFP_ADCM10_ADC2     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC2  )
#define MFP_ADCM10_ADC3     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC3  )
#define MFP_ADCM10_ADC4     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC4  )
#define MFP_ADCM10_ADC5     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC5  )
#define MFP_ADCM10_ADC6     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC6  )
#define MFP_ADCM10_ADC7     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC7  )
#define MFP_ADCM10_ADC8     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADC8  )
#define MFP_ADCM10_ADCT     _MEM_ADDR( MFP_ADCM10_BASE_ADDR + MFP_ADCM10_RN_ADCT  )

// ADCS flags
#define ADCS_EN     (1 << 0)    // ADC enable
#define ADCS_SC     (1 << 1)    // ADC start conversion
#define ADCS_TE     (1 << 2)    // ADC trigger enable
#define ADCS_FR     (1 << 3)    // ADC free running
#define ADCS_IE     (1 << 4)    // ADC interrupt enable
#define ADCS_IF     (1 << 5)    // ADC interrupt flag

// ADMSK flags
#define ADMSK0      (1 << 0)
#define ADMSK1      (1 << 1)
#define ADMSK2      (1 << 2)
#define ADMSK3      (1 << 3)
#define ADMSK4      (1 << 4)
#define ADMSK5      (1 << 5)
#define ADMSK6      (1 << 6)
#define ADMSK7      (1 << 7)
#define ADMSK8      (1 << 8)
#define ADMSKT      (1 << 9)


#define IH_TIMER    __mips_isr_hw5()
#define IH_ADC      __mips_isr_hw4()

#define EH_GENERAL()    void __attribute__ ((interrupt, keep_interrupts_masked)) _mips_general_exception()
#define ISR(x)          void __attribute__ ((interrupt, keep_interrupts_masked)) x

#endif //MFP_ADCM10_H
