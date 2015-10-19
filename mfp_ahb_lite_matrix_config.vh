//
//  Configuration parameters
//

`define MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX

// `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION
// `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SYNTHESIS

`ifdef      MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION
    `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE
    `undef  MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SYNTHESIS
`elsif      MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SYNTHESIS
    `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE
`endif

// `define MFP_RAM_RESET_INIT_FILENAME       "program_bfc00000.hex"
// `define MFP_RAM_INIT_FILENAME             "program_80000000.hex"

`ifndef MFP_RAM_RESET_INIT_FILENAME
    `define MFP_RAM_RESET_INIT_FILENAME   "ram_reset_init.txt"
`endif

`ifndef MFP_RAM_INIT_FILENAME
    `define MFP_RAM_INIT_FILENAME         "ram_program_init.txt"
`endif

`define MFP_USE_UART_PROGRAM_LOADER

//
//  Memory-mapped I/O addresses
//

`define MFP_RED_LEDS_ADDR       32'h1f800000
`define MFP_GREEN_LEDS_ADDR     32'h1f800004
`define MFP_SWITCHES_ADDR       32'h1f800008
`define MFP_BUTTONS_ADDR        32'h1f80000C
`define MFP_LIGHT_SENSOR_ADDR   32'h1f800010

`define MFP_RED_LEDS_IONUM      4'h0
`define MFP_GREEN_LEDS_IONUM    4'h1
`define MFP_SWITCHES_IONUM      4'h2
`define MFP_BUTTONS_IONUM       4'h3
`define MFP_LIGHT_SENSOR_IONUM  4'h4

//
// RAM addresses
//

`define MFP_RAM_RESET_ADDR          32'h1fc?????
`define MFP_RAM_ADDR                32'h0???????

`define MFP_RAM_RESET_ADDR_WIDTH    10 // DE0-Nano 13 DE0-CV or Basys3 // 15 Nexys 4 or DE2-115
`define MFP_RAM_ADDR_WIDTH          13 //          14                  // 16

`define MFP_RAM_RESET_ADDR_MATCH    7'h7f
`define MFP_RAM_ADDR_MATCH          1'b0
`define MFP_GPIO_ADDR_MATCH         7'h7e
