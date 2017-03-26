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
//  Common configuration parameters
//
`define MFP_USE_UART_PROGRAM_LOADER
`define MFP_USE_DUPLEX_UART
`define MFP_USE_MPSSE_DEBUGGER
// `define MFP_INITIALIZE_MEMORY_FROM_TXT_FILE
// `define MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX
// `define MFP_DEMO_LIGHT_SENSOR
// `define MFP_DEMO_CACHE_MISSES
// `define MFP_DEMO_PIPE_BYPASS

//
//  Memory type (choose one)
//
//`define MFP_USE_BYTE_MEMORY
`define MFP_USE_WORD_MEMORY
//`define MFP_USE_BUSY_MEMORY
//`define MFP_USE_SDRAM_MEMORY

//
// Enable external interrupt controller
// see additional settings in mfp_eic_core.vh
//
//`define MFP_USE_IRQ_EIC

//
// global SDRAM bus params
//

`ifdef MFP_USE_SDRAM_MEMORY
    `undef MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX
    `ifdef SIMULATION
        //only x16 supported
        `define x16
        `define den64Mb
        `define sg75
        
        //these values should be relevant to sdr_parameters.vh
        `ifdef den64Mb
            `define SDRAM_ADDR_BITS         12
            `define SDRAM_ROW_BITS          12
            `define SDRAM_COL_BITS          8
        `elsif den128Mb
            `define SDRAM_ADDR_BITS         12
            `define SDRAM_ROW_BITS          12
            `define SDRAM_COL_BITS          9
        `elsif den256Mb
            `define SDRAM_ADDR_BITS         13
            `define SDRAM_ROW_BITS          13
            `define SDRAM_COL_BITS          9
        `else 
            `define den512Mb
            `define SDRAM_ADDR_BITS         13
            `define SDRAM_ROW_BITS          13
            `define SDRAM_COL_BITS          10
        `endif

        `define SDRAM_DQ_BITS               16
        `define SDRAM_DM_BITS               2
        `define SDRAM_BA_BITS               2
        `define SDRAM_DELAY_nCKE            20
        `define SDRAM_MEM_CLK_PHASE_SHIFT   12
        `define MFP_RAM_ADDR_WIDTH          (`SDRAM_ROW_BITS + `SDRAM_COL_BITS + `SDRAM_BA_BITS)
    `else
        `include "board_config.vh"
    `endif
`endif


//not all types of memory can work with HSIZE_1
`ifdef MFP_USE_UART_PROGRAM_LOADER
    `ifndef MFP_USE_BYTE_MEMORY
        `define MFP_USE_UART_PROGRAM_LOADER_WORD_ALIGN
    `endif
`endif

// mpsse debug cant be enabled on Simulation
`ifdef SIMULATION
    `undef MFP_USE_MPSSE_DEBUGGER
`endif

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

`ifndef MFP_RAM_ADDR_WIDTH
    `ifdef SIMULATION
    `define MFP_RAM_ADDR_WIDTH          16
    `else
    `define MFP_RAM_ADDR_WIDTH          15  // DE1: 10, DE0-Nano: 13, DE0-CV or Basys3: 14, Nexys 4 or DE2-115: 16, DE10-Lite: 15
    `endif
`endif

`define MFP_RESET_RAM_ADDR_MATCH    7'h7f
`define MFP_RAM_ADDR_MATCH          3'b0
`define MFP_GPIO_ADDR_MATCH         7'h7e
`define MFP_UART_ADDR_MATCH         17'h10401
`define MFP_EIC_ADDR_MATCH          17'h10402
