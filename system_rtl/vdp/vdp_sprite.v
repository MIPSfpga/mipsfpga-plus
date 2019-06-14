`include "vdp.vh"

module vdp_sprite
(
    input                                          clk,
    input                                          reset,

    input      [`VDP_X_WIDTH                - 1:0] pixel_x,
    input      [`VDP_Y_WIDTH                - 1:0] pixel_y,

    input      [`VDP_WR_DATA_WIDTH          - 1:0] wr_data,
    input                                          xy_we,
    input                                          row_we,
    input      [`VDP_SPRITE_ROW_INDEX_WIDTH - 1:0] wr_row_index,

    output reg                                     rgb_en,
    output reg [`VDP_RGB_WIDTH              - 1:0] rgb
);

    reg sprite_en;

    reg [`VDP_X_WIDTH - 1:0] sprite_x;
    reg [`VDP_Y_WIDTH - 1:0] sprite_y;

    reg [`VDP_WR_DATA_WIDTH - 1:0] rows [0:`VDP_SPRITE_N_ROWS - 1];

    always @ (posedge clk or posedge reset)
        if (reset)
            sprite_en <= 1'b0;
        else if (coord_we)
            sprite_en <= wr_data [`VDP_SPRITE_COORD_BIT_ENABLE];
            
    always @ (posedge clk)
        if (coord_we)
        begin
            x <= wr_data [`VDP_SPRITE_COORD_RANGE_X];
            y <= wr_data [`VDP_SPRITE_COORD_RANGE_Y];
        end

endmodule
