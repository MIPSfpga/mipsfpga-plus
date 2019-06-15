`include "mfp_ahb_lite_matrix_config.vh"

module vdp_hvsync
# (
    parameter N_VDP_PIPE  = 0,
              HPOS_WIDTH  = 10,
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
    input                         clk,
    input                         reset,
    output reg                    hsync,
    output reg                    vsync,
    output reg                    display_on,
    output reg [HPOS_WIDTH - 1:0] hpos,
    output reg [VPOS_WIDTH - 1:0] vpos
);

    //------------------------------------------------------------------------

    // derived constants

    localparam H_SYNC_START  = H_DISPLAY    + H_FRONT + N_VDP_PIPE,
               H_SYNC_END    = H_SYNC_START + H_SYNC - 1,
               H_MAX         = H_SYNC_END   + H_BACK,

               V_SYNC_START  = V_DISPLAY    + V_BOTTOM,
               V_SYNC_END    = V_SYNC_START + V_SYNC - 1,
               V_MAX         = V_SYNC_END   + V_TOP;

    //------------------------------------------------------------------------

    // calculating next values of the counters

    reg [HPOS_WIDTH - 1:0] d_hpos;
    reg [VPOS_WIDTH - 1:0] d_vpos;

    always @*
    begin
        if (hpos == H_MAX)
        begin
            d_hpos = 1'd0;

            if (vpos == V_MAX)
                d_vpos = 1'd0;
            else
                d_vpos = vpos + 1'd1;
        end
        else
        begin
          d_hpos = hpos + 1'd1;
          d_vpos = vpos;
        end
    end

    //------------------------------------------------------------------------

    `ifdef MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX

         wire clk_en = 1'b1;
         
    `else

        // enable to divide clock from 50 MHz to 25 MHz

        reg clk_en;

        always @ (posedge clk or posedge reset)
            if (reset)
                clk_en <= 1'b0;
            else
                clk_en <= ~ clk_en;
    `endif

    //------------------------------------------------------------------------

    // making all outputs registered

    always @ (posedge clk or posedge reset)
    begin
        if (reset)
        begin
            hsync       <= 1'b0;
            vsync       <= 1'b0;
            display_on  <= 1'b0;
            hpos        <= 1'b0;
            vpos        <= 1'b0;
        end
        else if (clk_en)
        begin
            hsync       <= ~ (    d_hpos >= H_SYNC_START
                               && d_hpos <= H_SYNC_END   );

            vsync       <= ~ (    d_vpos >= V_SYNC_START
                               && d_vpos <= V_SYNC_END   );

            display_on  <=   (    d_hpos <  H_DISPLAY    
                               && d_vpos <  V_DISPLAY    );

            hpos        <= d_hpos;
            vpos        <= d_vpos;
        end
    end

endmodule
