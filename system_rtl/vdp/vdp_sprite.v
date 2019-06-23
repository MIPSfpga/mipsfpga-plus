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
    reg use_as_tile;

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
            use_as_tile <= wr_data [`VDP_SPRITE_XY_TILE_BIT];
            sprite_x    <= wr_data [`VDP_SPRITE_XY_X_RANGE];
            sprite_y    <= wr_data [`VDP_SPRITE_XY_Y_RANGE];
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

    wire x_hit =    use_as_tile
                 ||
                       x_pixel_minus_sprite        [`VDP_X_WIDTH] == 1'b0
                    && x_sprite_plus_w_minus_pixel [`VDP_X_WIDTH] == 1'b0;

    wire y_hit =    use_as_tile
                 ||
                       y_pixel_minus_sprite        [`VDP_Y_WIDTH] == 1'b0
                    && y_sprite_plus_h_minus_pixel [`VDP_Y_WIDTH] == 1'b0;

    //------------------------------------------------------------------------

    wire [`VDP_SPRITE_COLUMN_INDEX_WIDTH - 1:0] column_index
        = use_as_tile ?
              pixel_x              [`VDP_SPRITE_COLUMN_INDEX_WIDTH - 1:0]
            : x_pixel_minus_sprite [`VDP_SPRITE_COLUMN_INDEX_WIDTH - 1:0];

    wire [`VDP_SPRITE_ROW_INDEX_WIDTH - 1:0] row_index
        = use_as_tile ?
              pixel_y              [`VDP_SPRITE_ROW_INDEX_WIDTH    - 1:0]
            : y_pixel_minus_sprite [`VDP_SPRITE_ROW_INDEX_WIDTH    - 1:0];

    wire [`VDP_SPRITE_WIDTH * `VDP_ERGB_WIDTH - 1:0] row = rows [row_index];

    // Here we assume that `VDP_SPRITE_WIDTH == 8 and `VDP_ERGB_WIDTH == 4
    // TODO: instantiate here a more generic mux that is handled by all
    // synthesis tools well

    reg [`VDP_ERGB_WIDTH - 1:0] ergb;
    
    always @*
        case (column_index)
        3'd0: ergb = row [31:28];
        3'd1: ergb = row [27:24];
        3'd2: ergb = row [23:20];
        3'd3: ergb = row [19:16];
        3'd4: ergb = row [15:12];
        3'd5: ergb = row [11: 8];
        3'd6: ergb = row [ 7: 4];
        3'd7: ergb = row [ 3: 0];
        endcase

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            rgb_en <= 1'b0;
        else if (x_hit && y_hit)
            { rgb_en, rgb } <= ergb;
        else
            rgb_en <= 1'b0;

endmodule
