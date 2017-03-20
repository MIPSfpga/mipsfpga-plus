`include "mfp_ahb_lite.vh"
`include "mfp_ahb_lite_matrix_config.vh"
`include "mfp_eic_core.vh"

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

    `ifdef MFP_DEMO_LIGHT_SENSOR
    input  [                       15 : 0 ] IO_LightSensor,
    `endif

    input                                   UART_RX,
    output                                  UART_TX,
    output                                  UART_INT,

    `ifdef MFP_USE_IRQ_EIC
    input  [ `EIC_CHANNELS        - 1 : 0 ] EIC_input,
    output [                       17 : 1 ] EIC_Offset,
    output [                        3 : 0 ] EIC_ShadowSet,
    output [                        7 : 0 ] EIC_Interrupt,
    output [                        5 : 0 ] EIC_Vector,
    output                                  EIC_Present,
    input                                   EIC_IAck,
    input  [                        7 : 0 ] EIC_IPL,
    input  [                        5 : 0 ] EIC_IVN,
    input  [                       17 : 1 ] EIC_ION,
    `endif //MFP_USE_IRQ_EIC

    input  [`MFP_N_SWITCHES          - 1:0] IO_Switches,
    input  [`MFP_N_BUTTONS           - 1:0] IO_Buttons,
    output [`MFP_N_RED_LEDS          - 1:0] IO_RedLEDs,
    output [`MFP_N_GREEN_LEDS        - 1:0] IO_GreenLEDs,
    output [`MFP_7_SEGMENT_HEX_WIDTH - 1:0] IO_7_SegmentHEX
);

    wire [ 4:0] HSEL_req;   
    reg  [ 4:0] HSEL_dly;
    wire [ 4:0] HSEL = HREADY ? HSEL_req : HSEL_dly;

    mfp_ahb_lite_decoder decoder (HADDR, HSEL_req);

    //TODO: move all HSEL logic to selector module
    always @ (posedge HCLK)
        if(~HRESETn)
            HSEL_dly <= 5'b1;
        else 
            if(HREADY) HSEL_dly <= HSEL;

    //TODO: change to arrays
    wire        HREADY_0 , HREADY_1 , HREADY_2 , HREADY_3 , HREADY_4;
    wire [31:0] HRDATA_0 , HRDATA_1 , HRDATA_2 , HRDATA_3 , HRDATA_4;
    wire        HRESP_0  , HRESP_1  , HRESP_2  , HRESP_3  , HRESP_4;

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
    wire    UART_RTS;
    wire    UART_CTS   = 1'b0;
    wire    UART_DTR;
    wire    UART_DSR   = 1'b0;
    wire    UART_RI    = 1'b0;
    wire    UART_DCD   = 1'b0;
    wire    UART_BAUD;

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
        .UART_STX         ( UART_TX         ),  // out UART serial output signal

        .UART_RTS         ( UART_RTS        ),  // out UART MODEM Request To Send
        .UART_CTS         ( UART_CTS        ),  // in  UART MODEM Clear To Send
        .UART_DTR         ( UART_DTR        ),  // out UART MODEM Data Terminal Ready
        .UART_DSR         ( UART_DSR        ),  // in  UART MODEM Data Set Ready
        .UART_RI          ( UART_RI         ),  // in  UART MODEM Ring Indicator
        .UART_DCD         ( UART_DCD        ),  // in  UART MODEM Data Carrier Detect
        .UART_BAUD        ( UART_BAUD       ),  // out UART baudrate output
        .UART_INT         ( UART_INT        )   // out UART interrupt
    );

    // EIC
    `ifdef MFP_USE_IRQ_EIC
    mfp_ahb_lite_eic eic
    (
        .HCLK             ( HCLK            ),
        .HRESETn          ( HRESETn         ),
        .HADDR            ( HADDR           ),
        .HBURST           ( HBURST          ),
        .HMASTLOCK        ( HMASTLOCK       ),
        .HPROT            ( HPROT           ),
        .HSEL             ( HSEL [4]        ),
        .HSIZE            ( HSIZE           ),
        .HTRANS           ( HTRANS          ),
        .HWDATA           ( HWDATA          ),
        .HWRITE           ( HWRITE          ),
        .HRDATA           ( HRDATA_4        ),
        .HREADY           ( HREADY_4        ),
        .HRESP            ( HRESP_4         ),
        .SI_Endian        ( SI_Endian       ),

        .EIC_input        ( EIC_input       ),

        .EIC_Offset       ( EIC_Offset      ),
        .EIC_ShadowSet    ( EIC_ShadowSet   ),
        .EIC_Interrupt    ( EIC_Interrupt   ),
        .EIC_Vector       ( EIC_Vector      ),
        .EIC_Present      ( EIC_Present     ),
        .EIC_IAck         ( EIC_IAck        ),
        .EIC_IPL          ( EIC_IPL         ),
        .EIC_IVN          ( EIC_IVN         ),
        .EIC_ION          ( EIC_ION         )
    );
    `else
    assign HREADY_4 = 1'b1;
    `endif

    assign HREADY = HREADY_0 & HREADY_1 & HREADY_2 & HREADY_3 & HREADY_4;

    mfp_ahb_lite_response_mux response_mux
    (
        .HSEL     ( HSEL_dly ),

        .HRDATA_0 ( HRDATA_0 ),
        .HRDATA_1 ( HRDATA_1 ),
        .HRDATA_2 ( HRDATA_2 ),
        .HRDATA_3 ( HRDATA_3 ),
        .HRDATA_4 ( HRDATA_4 ),

        .HRESP_0  ( HRESP_0  ),
        .HRESP_1  ( HRESP_1  ),
        .HRESP_2  ( HRESP_2  ),
        .HRESP_3  ( HRESP_3  ),
        .HRESP_4  ( HRESP_4  ),

        .HRDATA   ( HRDATA   ),
        .HRESP    ( HRESP    )
    );

endmodule

//--------------------------------------------------------------------

module mfp_ahb_lite_decoder
(
    input  [31:0] HADDR,
    output [ 4:0] HSEL
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

    // EIC   4 KB max at 0xb0402000 (physical: 0x10402000 - 0x10402fff)
    assign HSEL [4] = ( HADDR [28:12] == `MFP_EIC_ADDR_MATCH       );

endmodule

//--------------------------------------------------------------------

module mfp_ahb_lite_response_mux
(
    input      [ 4:0] HSEL,
               
    input      [31:0] HRDATA_0,
    input      [31:0] HRDATA_1,
    input      [31:0] HRDATA_2,
    input      [31:0] HRDATA_3,
    input      [31:0] HRDATA_4,
               
    input             HRESP_0,
    input             HRESP_1,
    input             HRESP_2,
    input             HRESP_3,
    input             HRESP_4,

    output reg [31:0] HRDATA,
    output reg        HRESP
);

    always @*
        casez (HSEL)
            5'b????1:   begin HRDATA = HRDATA_0; HRESP = HRESP_0; end
            5'b???10:   begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
            5'b??100:   begin HRDATA = HRDATA_2; HRESP = HRESP_2; end
            5'b?1000:   begin HRDATA = HRDATA_3; HRESP = HRESP_3; end
            5'b10000:   begin HRDATA = HRDATA_4; HRESP = HRESP_4; end
            default:    begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
        endcase

endmodule
