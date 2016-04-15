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

    // UART is not supported this implementation of the module

    assign UART_TX = 1'b0;

    wire [ 2:0] HSEL;

    mfp_ahb_lite_decoder decoder (HADDR, HSEL);

    reg  [ 2:0] HSEL_dly;

    always @ (posedge HCLK)
        HSEL_dly <= HSEL;

    wire        HREADY_0 , HREADY_1 , HREADY_2 ;
    wire [31:0] HRDATA_0 , HRDATA_1 , HRDATA_2 ;
    wire        HRESP_0  , HRESP_1  , HRESP_2  ;

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

    mfp_ahb_ram_slave
    # (
        .ADDR_WIDTH ( `MFP_RAM_ADDR_WIDTH )
    )
    ram
    (
        .HCLK       ( HCLK       ),
        .HRESETn    ( HRESETn    ),
        .HADDR      ( HADDR      ),
        .HBURST     ( HBURST     ),
        .HMASTLOCK  ( HMASTLOCK  ),
        .HPROT      ( HPROT      ),
        .HSEL       ( HSEL [1]   ),
        .HSIZE      ( HSIZE      ),
        .HTRANS     ( HTRANS     ),
        .HWDATA     ( HWDATA     ),
        .HWRITE     ( HWRITE     ),
        .HRDATA     ( HRDATA_1   ),
        .HREADY     ( HREADY_1   ),
        .HRESP      ( HRESP_1    ),
        .SI_Endian  ( SI_Endian  )
    );

    `ifdef MFP_DEMO_CACHE_MISSES

    wire burst = HTRANS == `HTRANS_NONSEQ && HBURST == `HBURST_WRAP4;
    assign IO_GreenLEDs = { { `MFP_N_GREEN_LEDS - (1 + 1 + 6) { 1'b0 } }, HCLK, burst, HADDR [7:2] };

    `endif

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

        `ifdef MFP_DEMO_CACHE_MISSES
        .IO_GreenLEDs     (                 ),
        `else
        .IO_GreenLEDs     ( IO_GreenLEDs    ),
        `endif

        .IO_7_SegmentHEX  ( IO_7_SegmentHEX )


        `ifdef MFP_DEMO_LIGHT_SENSOR
        ,
        .IO_LightSensor   ( IO_LightSensor  )
        `endif
    );

    assign HREADY = HREADY_0 | HREADY_1 | HREADY_2;

    mfp_ahb_lite_response_mux response_mux
    (
        .HSEL     ( HSEL_dly ),

        .HRDATA_0 ( HRDATA_0 ),
        .HRDATA_1 ( HRDATA_1 ),
        .HRDATA_2 ( HRDATA_2 ),

        .HRESP_0  ( HRESP_0  ),
        .HRESP_1  ( HRESP_1  ),
        .HRESP_2  ( HRESP_2  ),

        .HRDATA   ( HRDATA   ),
        .HRESP    ( HRESP    )
    );

endmodule

//--------------------------------------------------------------------

module mfp_ahb_lite_decoder
(
    input  [31:0] HADDR,
    output [ 2:0] HSEL
);

    // Decode based on most significant bits of the address

    // 128 KB RAM at 0xbfc00000 (physical: 0x1fc00000)

    assign HSEL [0] = ( HADDR [28:22] == `MFP_RESET_RAM_ADDR_MATCH );

    // 256 KB RAM at 0x80000000 (physical: 0x00000000)

    assign HSEL [1] = ( HADDR [28]    == `MFP_RAM_ADDR_MATCH       );

    // GPIO       at 0xbf800000 (physical: 0x1f800000)

    assign HSEL [2] = ( HADDR [28:22] == `MFP_GPIO_ADDR_MATCH      );

endmodule

//--------------------------------------------------------------------

module mfp_ahb_lite_response_mux
(
    input      [ 2:0] HSEL,
               
    input      [31:0] HRDATA_0,
    input      [31:0] HRDATA_1,
    input      [31:0] HRDATA_2,
               
    input             HRESP_0,
    input             HRESP_1,
    input             HRESP_2,

    output reg [31:0] HRDATA,
    output reg        HRESP
);

    always @*
        casez (HSEL)
	3'b??1:   begin HRDATA = HRDATA_0; HRESP = HRESP_0; end
	3'b?10:   begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
	3'b100:   begin HRDATA = HRDATA_2; HRESP = HRESP_2; end
	default:  begin HRDATA = HRDATA_1; HRESP = HRESP_1; end
        endcase

endmodule
