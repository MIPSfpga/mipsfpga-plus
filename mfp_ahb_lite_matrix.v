`include "mfp_ahb_lite.vh"
`include "mfp_ahb_lite_matrix_config.vh"

module mfp_ahb_lite_matrix
(
    input         HCLK,
    input         HRESETn,
    input  [31:0] HADDR,
    input  [ 2:0] HBURST,
    input         HMASTLOCK,
    input  [ 3:0] HPROT,
    input  [ 2:0] HSIZE,
    input  [ 1:0] HTRANS,
    input  [31:0] HWDATA,
    input         HWRITE,
    output [31:0] HRDATA,
    output        HREADY,
    output        HRESP,
    input         SI_Endian,

    `ifdef MFP_USE_SDRAM_MEMORY
    output                                  SDRAM_CKE,
    output                                  SDRAM_CSn,
    output                                  SDRAM_RASn,
    output                                  SDRAM_CASn,
    output                                  SDRAM_WEn,
    output [`SDRAM_ADDR_BITS - 1 : 0 ]      SDRAM_ADDR,
    output [`SDRAM_BA_BITS   - 1 : 0 ]      SDRAM_BA,
    inout  [`SDRAM_DQ_BITS   - 1 : 0 ]      SDRAM_DQ,
    output [`SDRAM_DM_BITS   - 1 : 0 ]      SDRAM_DQM,
    `endif

    input  [`MFP_N_SWITCHES          - 1:0] IO_Switches,
    input  [`MFP_N_BUTTONS           - 1:0] IO_Buttons,
    output [`MFP_N_RED_LEDS          - 1:0] IO_RedLEDs,
    output [`MFP_N_GREEN_LEDS        - 1:0] IO_GreenLEDs,
    output [`MFP_7_SEGMENT_HEX_WIDTH - 1:0] IO_7_SegmentHEX,

    `ifdef MFP_DEMO_LIGHT_SENSOR
    input  [15:0] IO_LightSensor,
    `endif

    input         UART_RX,
    output        UART_TX
);

    wire [ 3:0] HSEL;

    mfp_ahb_lite_decoder decoder (HADDR, HSEL);

    reg  [ 3:0] HSEL_dly;

    always @ (posedge HCLK)
        if(HREADY)
            HSEL_dly <= HSEL;

    wire        HREADY_0 , HREADY_1 , HREADY_2 , HREADY_3;
    wire [31:0] HRDATA_0 , HRDATA_1 , HRDATA_2 , HRDATA_3;
    wire        HRESP_0  , HRESP_1  , HRESP_2  , HRESP_3;

    //RESET
    mfp_ahb_ram_slave
    # (
        .ADDR_WIDTH ( `MFP_RESET_RAM_ADDR_WIDTH )
    )
    reset_ram
    (
        .HCLK       ( HCLK       ),
        .HRESETn    ( HRESETn    ),
        .HADDR      ( HADDR      ),
        .HBURST     ( HBURST     ),
        .HMASTLOCK  ( HMASTLOCK  ),
        .HPROT      ( HPROT      ),
        .HSEL       ( HSEL [0]   ),
        .HSIZE      ( HSIZE      ),
        .HTRANS     ( HTRANS     ),
        .HWDATA     ( HWDATA     ),
        .HWRITE     ( HWRITE     ),
        .HRDATA     ( HRDATA_0   ),
        .HREADY     ( HREADY_0   ),
        .HRESP      ( HRESP_0    ),
        .SI_Endian  ( SI_Endian  )
    );

    //RAM
    `ifdef MFP_USE_SDRAM_MEMORY
        mfp_ahb_ram_sdram
        #(
            .ADDR_BITS  ( `SDRAM_ADDR_BITS  ),
            .ROW_BITS   ( `SDRAM_ROW_BITS   ),
            .COL_BITS   ( `SDRAM_COL_BITS   ),
            .DQ_BITS    ( `SDRAM_DQ_BITS    ),
            .DM_BITS    ( `SDRAM_DM_BITS    ),
            .BA_BITS    ( `SDRAM_BA_BITS    )
        )
    `elsif MFP_USE_BUSY_MEMORY
        mfp_ahb_ram_busy
        #(
            .ADDR_WIDTH ( `MFP_RAM_ADDR_WIDTH )
        )
    `else
        mfp_ahb_ram_slave
        #(
            .ADDR_WIDTH ( `MFP_RAM_ADDR_WIDTH )
        )
    `endif
    ram
    (
        .HCLK       ( HCLK          ),
        .HRESETn    ( HRESETn       ),
        .HADDR      ( HADDR         ),
        .HBURST     ( HBURST        ),
        .HMASTLOCK  ( HMASTLOCK     ),
        .HPROT      ( HPROT         ),
        .HSEL       ( HSEL [1]      ),
        .HSIZE      ( HSIZE         ),
        .HTRANS     ( HTRANS        ),
        .HWDATA     ( HWDATA        ),
        .HWRITE     ( HWRITE        ),
        .HRDATA     ( HRDATA_1      ),
        .HREADY     ( HREADY_1      ),
        .HRESP      ( HRESP_1       ),
        .SI_Endian  ( SI_Endian     )

        `ifdef MFP_USE_SDRAM_MEMORY
        ,
        .CKE        (   SDRAM_CKE   ),
        .CSn        (   SDRAM_CSn   ),
        .RASn       (   SDRAM_RASn  ),
        .CASn       (   SDRAM_CASn  ),
        .WEn        (   SDRAM_WEn   ),
        .ADDR       (   SDRAM_ADDR  ),
        .BA         (   SDRAM_BA    ),
        .DQ         (   SDRAM_DQ    ),
        .DQM        (   SDRAM_DQM   )
        `endif
    );

    //GPIO
    mfp_ahb_gpio_slave gpio
    (
        .HCLK             ( HCLK            ),
        .HRESETn          ( HRESETn         ),
        .HADDR            ( HADDR           ),
        .HBURST           ( HBURST          ),
        .HMASTLOCK        ( HMASTLOCK       ),
        .HPROT            ( HPROT           ),
        .HSEL             ( HSEL [2]        ),
        .HSIZE            ( HSIZE           ),
        .HTRANS           ( HTRANS          ),
        .HWDATA           ( HWDATA          ),
        .HWRITE           ( HWRITE          ),
        .HRDATA           ( HRDATA_2        ),
        .HREADY           ( HREADY_2        ),
        .HRESP            ( HRESP_2         ),
        .SI_Endian        ( SI_Endian       ),
                                           
        .IO_Switches      ( IO_Switches     ),
        .IO_Buttons       ( IO_Buttons      ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ),
        .IO_7_SegmentHEX  ( IO_7_SegmentHEX )

        `ifdef MFP_DEMO_LIGHT_SENSOR
        ,
        .IO_LightSensor   ( IO_LightSensor  )
        `endif
    );

    //UART
    mfp_ahb_lite_uart16550  uart
    (
        .HCLK             ( HCLK            ),
        .HRESETn          ( HRESETn         ),
        .HADDR            ( HADDR           ),
        .HBURST           ( HBURST          ),
        .HMASTLOCK        ( HMASTLOCK       ),
        .HPROT            ( HPROT           ),
        .HSEL             ( HSEL [3]        ),
        .HSIZE            ( HSIZE           ),
        .HTRANS           ( HTRANS          ),
        .HWDATA           ( HWDATA          ),
        .HWRITE           ( HWRITE          ),
        .HRDATA           ( HRDATA_3        ),
        .HREADY           ( HREADY_3        ),
        .HRESP            ( HRESP_3         ),
        .SI_Endian        ( SI_Endian       ),

        .UART_SRX         ( UART_RX         ),  // in  UART serial input signal
        .UART_STX         ( UART_TX         )   // out UART serial output signal

        /*
        .UART_RTS         ( UART_RTS        ),  // out UART MODEM Request To Send
        .UART_CTS         ( UART_CTS        ),  // in  UART MODEM Clear To Send
        .UART_DTR         ( UART_DTR        ),  // out UART MODEM Data Terminal Ready
        .UART_DSR         ( UART_DSR        ),  // in  UART MODEM Data Set Ready
        .UART_RI          ( UART_RI         ),  // in  UART MODEM Ring Indicator
        .UART_DCD         ( UART_DCD        ),  // in  UART MODEM Data Carrier Detect
        .UART_BAUD        ( UART_BAUD       ),  // out UART baudrate output
        .UART_INT         ( UART_INT        )   // out UART interrupt
        */
    );

    assign HREADY = HREADY_0 & HREADY_1 & HREADY_2 & HREADY_3;

    mfp_ahb_lite_response_mux response_mux
    (
        .HSEL     ( HSEL_dly ),

        .HRDATA_0 ( HRDATA_0 ),
        .HRDATA_1 ( HRDATA_1 ),
        .HRDATA_2 ( HRDATA_2 ),
        .HRDATA_3 ( HRDATA_3 ),

        .HRESP_0  ( HRESP_0  ),
        .HRESP_1  ( HRESP_1  ),
        .HRESP_2  ( HRESP_2  ),
        .HRESP_3  ( HRESP_3  ),

        .HRDATA   ( HRDATA   ),
        .HRESP    ( HRESP    )
    );

endmodule

//--------------------------------------------------------------------

module mfp_ahb_lite_decoder
(
    input  [31:0] HADDR,
    output [ 3:0] HSEL
);

    // Decode based on most significant bits of the address

    // RAM   4 MB max at 0xbfc00000 (physical: 0x1fc00000 - 0x1fffffff)
    assign HSEL [0] = ( HADDR [28:22] == `MFP_RESET_RAM_ADDR_MATCH );

    // RAM  64 MB max at 0x80000000 (physical: 0x00000000 - 0x03FFFFFF)
    assign HSEL [1] = ( HADDR [28:26] == `MFP_RAM_ADDR_MATCH       );

    // GPIO  4 MB max at 0xbf800000 (physical: 0x1f800000 - 0x1fbfffff)
    assign HSEL [2] = ( HADDR [28:22] == `MFP_GPIO_ADDR_MATCH      );

    // UART  4 KB max at 0xb0401000 (physical: 0x10401000 - 0x10401fff)
    assign HSEL [3] = ( HADDR [28:12] == `MFP_UART_ADDR_MATCH      );

endmodule

//--------------------------------------------------------------------

module mfp_ahb_lite_response_mux
(
    input      [ 3:0] HSEL,
               
    input      [31:0] HRDATA_0,
    input      [31:0] HRDATA_1,
    input      [31:0] HRDATA_2,
    input      [31:0] HRDATA_3,
               
    input             HRESP_0,
    input             HRESP_1,
    input             HRESP_2,
    input             HRESP_3,

    output reg [31:0] HRDATA,
    output reg        HRESP
);

    always @*
        casez (HSEL)
<<<<<<< HEAD
            4'b???1:   begin HRDATA = HRDATA_0; HRESP = HRESP_0; end
            4'b??10:   begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
            4'b?100:   begin HRDATA = HRDATA_2; HRESP = HRESP_2; end
            4'b1000:   begin HRDATA = HRDATA_3; HRESP = HRESP_3; end
            default:   begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
=======
            3'b??1:   begin HRDATA = HRDATA_0; HRESP = HRESP_0; end
            3'b?10:   begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
            3'b100:   begin HRDATA = HRDATA_2; HRESP = HRESP_2; end
            default:  begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
>>>>>>> refs/remotes/MIPSfpga/master
        endcase

endmodule
