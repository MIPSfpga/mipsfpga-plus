`include "mfp_ahb_lite_matrix_config.vh"
`include "mfp_ahb_lite.vh"
`include "mfp_eic_core.vh"

module mfp_ahb_lite_matrix_with_loader
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

    //reset uart
    input         UART_RX,
    output        UART_TX,
    output        UART_INT,

    `ifdef MFP_USE_DUPLEX_UART
    //communication uart
    input         UART_SRX,
    output        UART_STX,
    `endif

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

    output        MFP_Reset
);

    wire [7:0] char_data;
    wire       char_ready;

    mfp_uart_receiver mfp_uart_receiver
    (
        .clock      ( HCLK       ),
        .reset_n    ( HRESETn    ),
        .rx         ( UART_RX    ),
        .byte_data  ( char_data  ),
        .byte_ready ( char_ready )
    );                     

    wire        in_progress;
    wire        format_error;
    wire        checksum_error;
    wire [ 7:0] error_location;

    wire [31:0] write_address;
    wire [ 7:0] write_byte;
    wire        write_enable;

//    assign IO_RedLEDs = { in_progress, format_error, checksum_error, write_enable, write_address [31:0] };

    mfp_srec_parser mfp_srec_parser
    (
        .clock           ( HCLK           ),
        .reset_n         ( HRESETn        ),

        .char_data       ( char_data      ),
        .char_ready      ( char_ready     ), 

        .in_progress     ( in_progress    ),
        .format_error    ( format_error   ),
        .checksum_error  ( checksum_error ),
        .error_location  ( error_location ),

        .write_address   ( write_address  ),
        .write_byte      ( write_byte     ),
        .write_enable    ( write_enable   )
    );

    assign MFP_Reset = in_progress;

    wire [31:0] loader_HADDR;
    wire [ 2:0] loader_HBURST;
    wire        loader_HMASTLOCK;
    wire [ 3:0] loader_HPROT;
    wire [ 2:0] loader_HSIZE;
    wire [ 1:0] loader_HTRANS;
    wire [31:0] loader_HWDATA;
    wire        loader_HWRITE;

    mfp_srec_parser_to_ahb_lite_bridge mfp_srec_parser_to_ahb_lite_bridge
    (
        .clock          ( HCLK             ),
        .reset_n        ( HRESETn          ),
        .big_endian     ( SI_Endian        ),
    
        .write_address  ( write_address    ),
        .write_byte     ( write_byte       ),
        .write_enable   ( write_enable     ), 
    
        .HADDR          ( loader_HADDR     ),
        .HBURST         ( loader_HBURST    ),
        .HMASTLOCK      ( loader_HMASTLOCK ),
        .HPROT          ( loader_HPROT     ),
        .HSIZE          ( loader_HSIZE     ),
        .HTRANS         ( loader_HTRANS    ),
        .HWDATA         ( loader_HWDATA    ),
        .HWRITE         ( loader_HWRITE    )
    );

    mfp_ahb_lite_matrix ahb_lite_matrix
    (
        .HCLK             ( HCLK            ),
        .HRESETn          ( HRESETn         ),
                         
        .HADDR            ( in_progress ? loader_HADDR     : HADDR     ),
        .HBURST           ( in_progress ? loader_HBURST    : HBURST    ),
        .HMASTLOCK        ( in_progress ? loader_HMASTLOCK : HMASTLOCK ),
        .HPROT            ( in_progress ? loader_HPROT     : HPROT     ),
        .HSIZE            ( in_progress ? loader_HSIZE     : HSIZE     ),
        .HTRANS           ( in_progress ? loader_HTRANS    : HTRANS    ),
        .HWDATA           ( in_progress ? loader_HWDATA    : HWDATA    ),
        .HWRITE           ( in_progress ? loader_HWRITE    : HWRITE    ),
                         
        .HRDATA           ( HRDATA          ),
        .HREADY           ( HREADY          ),
        .HRESP            ( HRESP           ),
        .SI_Endian        ( SI_Endian       ),

        `ifdef MFP_USE_SDRAM_MEMORY
        .SDRAM_CKE        ( SDRAM_CKE       ),
        .SDRAM_CSn        ( SDRAM_CSn       ),
        .SDRAM_RASn       ( SDRAM_RASn      ),
        .SDRAM_CASn       ( SDRAM_CASn      ),
        .SDRAM_WEn        ( SDRAM_WEn       ),
        .SDRAM_ADDR       ( SDRAM_ADDR      ),
        .SDRAM_BA         ( SDRAM_BA        ),
        .SDRAM_DQ         ( SDRAM_DQ        ),
        .SDRAM_DQM        ( SDRAM_DQM       ),
        `endif  // MFP_USE_SDRAM_MEMORY
                                             
        `ifdef MFP_DEMO_LIGHT_SENSOR
        .IO_LightSensor   ( IO_LightSensor  ), 
        `endif

        `ifdef MFP_USE_DUPLEX_UART
        .UART_RX          ( UART_SRX        ), 
        .UART_TX          ( UART_STX        ),
        `else
        .UART_RX          ( 1'b0            ), 
        .UART_TX          ( UART_TX         ),
        `endif //MFP_USE_DUPLEX_UART
        .UART_INT         ( UART_INT        ),

        `ifdef MFP_USE_IRQ_EIC
        .EIC_input        ( EIC_input       ),
        .EIC_Offset       ( EIC_Offset      ),
        .EIC_ShadowSet    ( EIC_ShadowSet   ),
        .EIC_Interrupt    ( EIC_Interrupt   ),
        .EIC_Vector       ( EIC_Vector      ),
        .EIC_Present      ( EIC_Present     ),
        .EIC_IAck         ( EIC_IAck        ),
        .EIC_IPL          ( EIC_IPL         ),
        .EIC_IVN          ( EIC_IVN         ),
        .EIC_ION          ( EIC_ION         ),
        `endif //MFP_USE_IRQ_EIC

        .IO_Switches      ( IO_Switches     ),
        .IO_Buttons       ( IO_Buttons      ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ), 
        .IO_7_SegmentHEX  ( IO_7_SegmentHEX )
    );
endmodule
