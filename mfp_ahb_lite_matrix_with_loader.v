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

    input  [17:0] IO_Switches,
    input  [ 4:0] IO_Buttons,
    output [17:0] IO_RedLEDs,
    output [ 8:0] IO_GreenLEDs,

    input         UART_RX,
    output        UART_TX,

    output        MFP_Reset
);

    wire [7:0] char_data;
    wire       char_ready;

    uart_receiver uart_receiver
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

    srec_parser srec_parser
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

    wire [31:0] loader_HADDR       = { 3'b0, write_address [28:0] };
    wire [ 1:0] loader_HTRANS      = write_enable ? `HTRANS_NONSEQ : `HTRANS_IDLE;

    wire [31:0] padded_write_byte  = { 24'b0, write_byte };
    wire [ 4:0] write_byte_shift   = { write_address [1:0], 3'b0 };
    wire [31:0] loader_HWDATA_next = padded_write_byte << write_byte_shift;

    reg  [31:0] loader_HWDATA;

    always @ (posedge HCLK)
        loader_HWDATA <= loader_HWDATA_next;

    mfp_ahb_lite_matrix ahb_lite_matrix
    (
        .HCLK          ( HCLK          ),
        .HRESETn       ( HRESETn       ),

        .HADDR         ( in_progress ? loader_HADDR   : HADDR     ),
        .HBURST        ( in_progress ? `HBURST_SINGLE : HBURST    ),
        .HMASTLOCK     ( in_progress ? 1'b0           : HMASTLOCK ),
        .HPROT         ( in_progress ? 4'b0           : HPROT     ),
        .HSIZE         ( in_progress ? HSIZE_1        : HSIZE     ),
        .HTRANS        ( in_progress ? loader_HTRANS  : HTRANS    ),
        .HWDATA        ( in_progress ? loader_HWDATA  : HWDATA    ),
        .HWRITE        ( in_progress ? write_enable   : HWRITE    ),

        .HRDATA        ( HRDATA        ),
        .HREADY        ( HREADY        ),
        .HRESP         ( HRESP         ),
        .SI_Endian     ( SI_Endian     ),
                                         
        .IO_Switches   ( IO_Switches   ),
        .IO_Buttons    ( IO_Buttons    ),
        .IO_RedLEDs    ( IO_RedLEDs    ),
        .IO_GreenLEDs  ( IO_GreenLEDs  ), 
                                       
        .UART_RX       ( UART_RX       ), 
        .UART_TX       ( UART_TX       ) 
    );

endmodule
