//
//  Configuration parameters
//

// `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION
`define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SYNTHESIS

`ifdef      MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION
    `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE
    `undef  MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SYNTHESIS
`elsif      MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SYNTHESIS
    `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE
`endif

`define MFP_RAM_RESET_INIT_FILENAME   "ram_reset_init.txt"
`define MFP_RAM_INIT_FILENAME         "ram_program_init.txt"

`define MFP_USE_UART_PROGRAM_LOADER

//
//  Memory-mapped I/O addresses
//

`define MFP_RED_LEDS_ADDR     32'h1f800000
`define MFP_GREEN_LEDS_ADDR   32'h1f800004
`define MFP_SWITCHES_ADDR     32'h1f800008
`define MFP_BUTTONS_ADDR      32'h1f80000C

`define MFP_RED_LEDS_IONUM    4'h0
`define MFP_GREEN_LEDS_IONUM  4'h1
`define MFP_SWITCHES_IONUM    4'h2
`define MFP_BUTTONS_IONUM     4'h3

//
// RAM addresses
//

`define MFP_RAM_RESET_ADDR          32'h1fc?????
`define MFP_RAM_ADDR                32'h0???????

`define MFP_RAM_RESET_ADDR_WIDTH    13 
`define MFP_RAM_ADDR_WIDTH          14 

`define MFP_RAM_RESET_ADDR_MATCH    7'h7f
`define MFP_RAM_ADDR_MATCH          1'b0
`define MFP_GPIO_ADDR_MATCH         7'h7e
