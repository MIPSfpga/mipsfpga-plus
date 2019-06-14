`include "vdp.vh"

module vdp_sprite
(
    input             clk,
    input             reset,

    input [HPOS_WIDTH - 1:0] hpos,
    input [VPOS_WIDTH - 1:0] vpos,

    input      [31:0] wr_data,
    input      [ 2:0] wr_row,
    input             wr_row_we,
    input             wr_xy_we,

    output reg        rgb_en,
    output reg [ 1:0] rgb
);

    reg [HPOS_WIDTH - 1:0] x;
    reg [HPOS_WIDTH - 1:0] y;
    
    reg [31:0] rows [0:7];

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
