//
//  Simulation and synthesis
//

`ifdef SYNTHESIS
    `undef SIMULATION
`endif

`ifndef SIMULATION
    `ifdef MODEL_TECH
        `define SIMULATION
    `elsif XILINX_ISIM
        `define SIMULATION
    `endif
`endif

//
//  Configuration parameters
//

// `define MFP_USE_WORD_MEMORY
// `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE
`define MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX
`define MFP_USE_UART_PROGRAM_LOADER
// `define MFP_DEMO_LIGHT_SENSOR
// `define MFP_DEMO_CACHE_MISSES
// `define MFP_DEMO_PIPE_BYPASS

//
//  Memory-mapped I/O addresses
//

`define MFP_N_RED_LEDS              18
`define MFP_N_GREEN_LEDS            16
`define MFP_N_SWITCHES              18
`define MFP_N_BUTTONS               5
`define MFP_7_SEGMENT_HEX_WIDTH     32

`define MFP_RED_LEDS_ADDR           32'h1f800000
`define MFP_GREEN_LEDS_ADDR         32'h1f800004
`define MFP_SWITCHES_ADDR           32'h1f800008
`define MFP_BUTTONS_ADDR            32'h1f80000C
`define MFP_7_SEGMENT_HEX_ADDR      32'h1f800010

`ifdef MFP_DEMO_LIGHT_SENSOR
`define MFP_LIGHT_SENSOR_ADDR       32'h1f800014
`endif

`define MFP_RED_LEDS_IONUM          4'h0
`define MFP_GREEN_LEDS_IONUM        4'h1
`define MFP_SWITCHES_IONUM          4'h2
`define MFP_BUTTONS_IONUM           4'h3
`define MFP_7_SEGMENT_HEX_IONUM     4'h4
                                    
`ifdef MFP_DEMO_LIGHT_SENSOR            
`define MFP_LIGHT_SENSOR_IONUM      4'h5
`endif

//
// RAM addresses
//

`define MFP_RESET_RAM_ADDR          32'h1fc?????
`define MFP_RAM_ADDR                32'h0???????

`define MFP_RESET_RAM_ADDR_WIDTH    10  // The boot sequence is the same for everything

`ifdef SIMULATION
`define MFP_RAM_ADDR_WIDTH          16
`else
`define MFP_RAM_ADDR_WIDTH          10  // DE1: 10, DE0-Nano: 13, DE0-CV or Basys3: 14, Nexys 4 or DE2-115: 16
`endif

`define MFP_RESET_RAM_ADDR_MATCH    7'h7f
`define MFP_RAM_ADDR_MATCH          1'b0
`define MFP_GPIO_ADDR_MATCH         7'h7e
