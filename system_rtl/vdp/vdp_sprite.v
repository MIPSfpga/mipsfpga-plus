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

    //------------------------------------------------------------------------

    reg sprite_en;

    reg [`VDP_X_WIDTH - 1:0] sprite_x;
    reg [`VDP_Y_WIDTH - 1:0] sprite_y;

    reg [`VDP_SPRITE_WIDTH * `VDP_ERGB_WIDTH - 1:0]
        rows [0:`VDP_SPRITE_HEIGHT - 1];

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            sprite_en <= 1'b0;
        else if (xy_we)
            sprite_en <= wr_data [`VDP_SPRITE_XY_ENABLE_BIT];
            
    always @ (posedge clk)
        if (xy_we)
        begin
            sprite_x <= wr_data [`VDP_SPRITE_XY_X_RANGE];
            sprite_y <= wr_data [`VDP_SPRITE_XY_Y_RANGE];
        end

    always @ (posedge clk)
        if (row_we)
            rows [wr_row_index] <= wr_data;

    //------------------------------------------------------------------------

    wire [`VDP_X_WIDTH:0] x_pixel_minus_sprite
        = { 1'b0, pixel_x } - { 1'b0, sprite_x };

    wire [`VDP_X_WIDTH:0] x_sprite_plus_w_minus_pixel
        = { 1'b0, sprite_x } + `VDP_SPRITE_WIDTH - 1 - { 1'b0, pixel_x };
        
    wire [`VDP_Y_WIDTH:0] y_pixel_minus_sprite
        = { 1'b0, pixel_y } - { 1'b0, sprite_y };

    wire [`VDP_Y_WIDTH:0] y_sprite_plus_h_minus_pixel
        = { 1'b0, sprite_y } + `VDP_SPRITE_HEIGHT - 1 - { 1'b0, pixel_y };

    //------------------------------------------------------------------------

    wire x_hit =    x_pixel_minus_sprite        [`VDP_X_WIDTH] == 1'b0
                 && x_sprite_plus_w_minus_pixel [`VDP_X_WIDTH] == 1'b0;

    wire y_hit =    y_pixel_minus_sprite        [`VDP_Y_WIDTH] == 1'b0
                 && y_sprite_plus_h_minus_pixel [`VDP_Y_WIDTH] == 1'b0;

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            rgb_en <= 1'b0;
        end
        else
        begin
        end

endmodule
