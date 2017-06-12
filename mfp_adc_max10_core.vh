/* Altera MAX10 ADC controller for MIPSfpga+ system 
 * managed using AHB-Lite bus
 * Copyright(c) 2017 Stanislav Zhelnio
 */

`define ADC_ADDR_WIDTH  4
`define ADC_CH_COUNT    10
`define ADC_DATA_WIDTH  12
`define ADC_CHAN_WIDTH  5

`define ADC_REG_NONE        0   // no register selected
`define ADC_REG_ADCS        1   // ADC control and status
`define ADC_REG_ADMSK       2   // ADC channel mask
`define ADC_REG_ADC0        3   // ADC channel 0 conversion results
`define ADC_REG_ADC1        4   // ADC channel 1 conversion results
`define ADC_REG_ADC2        5   // ADC channel 2 conversion results
`define ADC_REG_ADC3        6   // ADC channel 3 conversion results
`define ADC_REG_ADC4        7   // ADC channel 4 conversion results
`define ADC_REG_ADC5        8   // ADC channel 5 conversion results
`define ADC_REG_ADC6        9   // ADC channel 6 conversion results
`define ADC_REG_ADC7       10   // ADC channel 7 conversion results
`define ADC_REG_ADC8       11   // ADC channel 8 conversion results
`define ADC_REG_ADCT       12   // ADC temperature channel conversion results

`define ADC_CH_0            5'd0
`define ADC_CH_1            5'd1
`define ADC_CH_2            5'd2
`define ADC_CH_3            5'd3
`define ADC_CH_4            5'd4
`define ADC_CH_5            5'd5
`define ADC_CH_6            5'd6
`define ADC_CH_7            5'd7
`define ADC_CH_8            5'd8
`define ADC_CH_T            5'd17
`define ADC_CH_NONE         5'd18

`define ADC_CELL_0          4'd0
`define ADC_CELL_1          4'd1
`define ADC_CELL_2          4'd2
`define ADC_CELL_3          4'd3
`define ADC_CELL_4          4'd4
`define ADC_CELL_5          4'd5
`define ADC_CELL_6          4'd6
`define ADC_CELL_7          4'd7
`define ADC_CELL_8          4'd8
`define ADC_CELL_T          4'd9

// ADCS register bit nums
`define ADC_FIELD_ADCS_EN   0   // ADC enable
`define ADC_FIELD_ADCS_SC   1   // ADC start conversion
`define ADC_FIELD_ADCS_TE   2   // ADC trigger enable
`define ADC_FIELD_ADCS_FR   3   // ADC free running
`define ADC_FIELD_ADCS_IE   4   // ADC interrupt enable
`define ADC_FIELD_ADCS_IF   5   // ADC interrupt flag
