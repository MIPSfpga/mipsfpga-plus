//board specific settings

//SDRAM parameters for 64MB (Terasic DE0-CV)
`ifdef MFP_USE_SDRAM_MEMORY
    `define SDRAM_ADDR_BITS         13
    `define SDRAM_ROW_BITS          13
    `define SDRAM_COL_BITS          10
    `define SDRAM_DQ_BITS           16
    `define SDRAM_BA_BITS           2
    `define SDRAM_DM_BITS           2
    `define MFP_RAM_ADDR_WIDTH      (`SDRAM_ROW_BITS + `SDRAM_COL_BITS + `SDRAM_BA_BITS)

    //values for fclk=50 MHz
    `define SDRAM_DELAY_nCKE        10000
    `define SDRAM_DELAY_tREF        360
    `define SDRAM_DELAY_tRP         0
    `define SDRAM_DELAY_tRFC        2
    `define SDRAM_DELAY_tMRD        0
    `define SDRAM_DELAY_tRCD        0
    `define SDRAM_DELAY_tCAS        0
    `define SDRAM_DELAY_afterREAD   0
    `define SDRAM_DELAY_afterWRITE  2
    `define SDRAM_COUNT_initAutoRef 8
`endif
