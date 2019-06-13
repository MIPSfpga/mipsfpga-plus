`include "mfp_ahb_lite_matrix_config.vh"
`include "mfp_ahb_lite.vh"

module vdp
# (
    parameter HPOS_WIDTH  = 10,
              VPOS_WIDTH  = 10,

              // horizontal constants

              H_DISPLAY   = 640,  // horizontal display width
              H_FRONT     =  16,  // horizontal right border (front porch)
              H_SYNC      =  96,  // horizontal sync width
              H_BACK      =  48,  // horizontal left border (back porch)

              // vertical constants

              V_DISPLAY   = 480,  // vertical display height
              V_BOTTOM    =  10,  // vertical bottom border
              V_SYNC      =   2,  // vertical sync # lines
              V_TOP       =  33   // vertical top border
)
(
    input         HCLK,
    input         HRESETn,
    input  [31:0] HADDR,
    input  [ 2:0] HBURST,
    input         HMASTLOCK,
    input  [ 3:0] HPROT,
    input         HSEL,
    input  [ 2:0] HSIZE,
    input  [ 1:0] HTRANS,
    input  [31:0] HWDATA,
    input         HWRITE,
    input         HREADY,
    output [31:0] HRDATA,
    output        HREADYOUT,
    output        HRESP,
    input         SI_Endian,

    output        vga_hsync,
    output        vga_vsync,
    output [ 2:0] vga_rgb
);
    wire clk   =   HCLK;
    wire reset = ! HRESETn;

    assign HRDATA    = 32'h0;
    assign HREADYOUT = 1'b1;
    assign HRESP     = 1'b0;

    wire                    display_on;
    wire [HPOS_WIDTH - 1:0] hpos;
    wire [VPOS_WIDTH - 1:0] vpos;

    localparam N_VDP_PIPE  = 0;

    vdp_hv_sync_generator
    # (
        .N_VDP_PIPE ( N_VDP_PIPE ),

        .HPOS_WIDTH ( HPOS_WIDTH ),
        .VPOS_WIDTH ( VPOS_WIDTH ),

        .H_DISPLAY  ( H_DISPLAY  ),
        .H_FRONT    ( H_FRONT    ),
        .H_SYNC     ( H_SYNC     ),
        .H_BACK     ( H_BACK     ),

        .V_DISPLAY  ( V_DISPLAY  ),
        .V_BOTTOM   ( V_BOTTOM   ),
        .V_SYNC     ( V_SYNC     ),
        .V_TOP      ( V_TOP      )
    )
    i_vdp_hv_sync_generator
    (
        .clk        ( clk        ),
        .reset      ( reset      ),
        .hsync      ( hsync      ),
        .vsync      ( vsync      ),
        .display_on ( display_on ),
        .hpos       ( hpos       ),
        .vpos       ( vpos       )
    );

    wire write =    ( HTRANS == `HTRANS_NONSEQ || HTRANS == `HTRANS_NONSEQ )
                 && ( HBURST == `HBURST_WRAP4  || HSIZE  == `HSIZE_4       )
                 && HSEL && HREADY && HWRITE;

    reg write_reg;

    always @ (posedge clk or posedge reset)
        if (reset)
            write_reg <= 1'b0;
        else
            write_reg <= write;

    reg [31:0] data;

    always @ (posedge clk or posedge reset)
        if (reset)
            data <= 32'h0;
        else if (write_reg)
            data <= HWDATA;

    assign vga_rgb = data [2:0] ^ { hpos [2], vpos [3], hpos [4] ^ vpos [4] };

endmodule
