`include "mfp_ahb_lite_matrix_config.vh"
`include "mfp_ahb_lite.vh"

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

    input  [`MFP_N_SWITCHES          - 1:0] IO_Switches,
    input  [`MFP_N_BUTTONS           - 1:0] IO_Buttons,
    output [`MFP_N_RED_LEDS          - 1:0] IO_RedLEDs,
    output [`MFP_N_GREEN_LEDS        - 1:0] IO_GreenLEDs,
    output [`MFP_7_SEGMENT_HEX_WIDTH - 1:0] IO_7_SegmentHEX,

    `ifdef MFP_DEMO_LIGHT_SENSOR
    input  [15:0] IO_LightSensor,
    `endif

    input         UART_RX,
    output        UART_TX,

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
                                             
        .IO_Switches      ( IO_Switches     ),
        .IO_Buttons       ( IO_Buttons      ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ), 
        .IO_7_SegmentHEX  ( IO_7_SegmentHEX ),

        `ifdef MFP_DEMO_LIGHT_SENSOR
        .IO_LightSensor   ( IO_LightSensor  ), 
        `endif
                                       
        .UART_RX          ( UART_RX         ), 
        .UART_TX          ( UART_TX         ) 
    );

endmodule
