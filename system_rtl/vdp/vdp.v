`include "mfp_ahb_lite_matrix_config.vh"
`include "mfp_ahb_lite.vh"
`include "vdp.vh"

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
    //------------------------------------------------------------------------

    wire clk   =   HCLK;
    wire reset = ! HRESETn;

    assign HRDATA    = 32'h0;
    assign HREADYOUT = 1'b1;
    assign HRESP     = 1'b0;

    //------------------------------------------------------------------------

    wire                    display_on;
    wire [HPOS_WIDTH - 1:0] hpos;
    wire [VPOS_WIDTH - 1:0] vpos;

    //------------------------------------------------------------------------

    localparam N_VDP_PIPE  = 1;

    //------------------------------------------------------------------------

    vdp_hvsync
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
        .hsync      ( vga_hsync  ),
        .vsync      ( vga_vsync  ),
        .display_on ( display_on ),
        .hpos       ( hpos       ),
        .vpos       ( vpos       )
    );

    //------------------------------------------------------------------------

    wire write =    ( HTRANS == `HTRANS_NONSEQ || HTRANS == `HTRANS_NONSEQ )
                 && ( HBURST == `HBURST_WRAP4  || HSIZE  == `HSIZE_4       )
                 && HSEL && HREADY && HWRITE;

    reg [31:0] addr_reg;

    always @ (posedge clk)
        addr_reg <= HADDR;

    reg write_reg;

    always @ (posedge clk or posedge reset)
        if (reset)
            write_reg <= 1'b0;
        else
            write_reg <= write;

    //------------------------------------------------------------------------

    wire [`VDP_X_WIDTH - 1:0] pixel_x = hpos;
    wire [`VDP_Y_WIDTH - 1:0] pixel_y = vpos;

    wire [`VDP_WR_DATA_WIDTH - 1:0] wr_data = HWDATA;

    wire sprite_mem_we
        = write_reg && addr_reg [`VDP_ADDR_SPRITE_INDICATOR_BIT];
        
    wire xy_we  = sprite_mem_we &&   addr_reg [`VDP_ADDR_SPRITE_XY_BIT];
    wire row_we = sprite_mem_we && ~ addr_reg [`VDP_ADDR_SPRITE_XY_BIT];
    
    wire [`VDP_SPRITE_ROW_INDEX_WIDTH - 1:0] wr_row_index
        = addr_reg [`VDP_ADDR_SPRITE_ROW_INDEX_RANGE];

    //------------------------------------------------------------------------

    wire [`VDP_N_SPRITES - 1:0] sprite_we
        = 1 << addr_reg [`VDP_ADDR_SPRITE_INDEX_RANGE];

    wire [`VDP_N_SPRITES - 1:0] sprite_rgb_en;

    wire [`VDP_RGB_WIDTH - 1:0] sprite_rgb [0:`VDP_N_SPRITES - 1];

    //------------------------------------------------------------------------

    generate

        genvar i;

        for (i = 0; i < `VDP_N_SPRITES; i = i + 1)
        begin : gen_vdp_sprite

            vdp_sprite sprite
            (
                .clk           ( clk                           ),
                .reset         ( reset                         ),

                .pixel_x       ( pixel_x                       ),
                .pixel_y       ( pixel_y                       ),

                .wr_data       ( wr_data                       ),
                .xy_we         ( xy_we         & sprite_we [i] ),
                .row_we        ( row_we        & sprite_we [i] ),
                .wr_row_index  ( wr_row_index                  ),

                .rgb_en        ( sprite_rgb_en [i]             ),
                .rgb           ( sprite_rgb    [i]             )
            );
        end
    
    endgenerate
    
    //------------------------------------------------------------------------

    // Here we assume that VDP_N_SPRITES == 8

    wire any_sprite_rgb_en = | sprite_rgb_en;

    wire [`VDP_RGB_WIDTH - 1:0] selected_sprite_rgb

        = (|      sprite_rgb_en [7:4]) ?
              (|  sprite_rgb_en [7:6]) ?
                  sprite_rgb_en [7]    ? sprite_rgb [7] : sprite_rgb [6]
                : sprite_rgb_en [5]    ? sprite_rgb [5] : sprite_rgb [4]
            : (|  sprite_rgb_en [3:2]) ?
                  sprite_rgb_en [3]    ? sprite_rgb [3] : sprite_rgb [2]
                : sprite_rgb_en [1]    ? sprite_rgb [1] : sprite_rgb [0];

    // TODO: Compare with:

    wire [`VDP_RGB_WIDTH - 1:0] selected_sprite_rgb_unoptimized

        =   sprite_rgb_en [7] ? sprite_rgb [7]
          : sprite_rgb_en [6] ? sprite_rgb [6]
          : sprite_rgb_en [5] ? sprite_rgb [5]
          : sprite_rgb_en [4] ? sprite_rgb [4]
          : sprite_rgb_en [3] ? sprite_rgb [3]
          : sprite_rgb_en [2] ? sprite_rgb [2]
          : sprite_rgb_en [1] ? sprite_rgb [1]
          : sprite_rgb_en [0];

    //------------------------------------------------------------------------

    assign vga_rgb = any_sprite_rgb_en ? selected_sprite_rgb
        : { 1'b0, pixel_x [4], pixel_y [5] }; // `VDP_RGB_WIDTH'b0;

endmodule
