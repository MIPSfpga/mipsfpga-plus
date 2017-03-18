/* Simple external interrupt controller for MIPSfpga+ system 
 * managed using AHB-Lite bus
 * Copyright(c) 2017 Stanislav Zhelnio
 */

//reg addrs
`define EIC_REG_NONE        0   // no register selected
`define EIC_REG_EICR        1   // external interrupt control register
`define EIC_REG_EIMSK_0     2   // external interrupt mask register (31 - 0 )
`define EIC_REG_EIMSK_1     3   // external interrupt mask register (63 - 32)
`define EIC_REG_EIFR_0      4   // external interrupt flag register (31 - 0 )
`define EIC_REG_EIFR_1      5   // external interrupt flag register (63 - 32)
`define EIC_REG_EIFRS_0     6   // external interrupt flag register, bit set (31 - 0 )
`define EIC_REG_EIFRS_1     7   // external interrupt flag register, bit set (63 - 32)
`define EIC_REG_EIFRC_0     8   // external interrupt flag register, bit clear (31 - 0 )
`define EIC_REG_EIFRC_1     9   // external interrupt flag register, bit clear (63 - 32)
`define EIC_REG_EISMSK_0    10  // external interrupt sense mask register (31 - 0 )
`define EIC_REG_EISMSK_1    11  // external interrupt sense mask register (63 - 32)
`define EIC_REG_EIIPR_0     12  // external interrupt input pin register (31 - 0 )
`define EIC_REG_EIIPR_1     13  // external interrupt input pin register (63 - 32)
`define EIC_REG_EIACM_0     14  // external interrupt auto clear mask register (31 - 0 )
`define EIC_REG_EIACM_1     15  // external interrupt auto clear mask register (63 - 32)


`define EIC_ADDR_WIDTH      4   // register addr width

//default interrupt count
`ifndef EIC_DIRECT_CHANNELS
    `define EIC_DIRECT_CHANNELS 31  // 0-31
`endif
`ifndef EIC_SENSE_CHANNELS
    `define EIC_SENSE_CHANNELS  32  // 0-32
`endif

`define EIC_USE_EXPLICIT_VECTOR_OFFSET

`define EIC_CHANNELS        (`EIC_DIRECT_CHANNELS + `EIC_SENSE_CHANNELS)

