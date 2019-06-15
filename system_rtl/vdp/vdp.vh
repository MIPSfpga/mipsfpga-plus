//  VDP defines

// Screen dimensions

// 10 bits of X and 10 bits of Y can cover 640x480 and 800x600 VGA modes

`define VDP_X_WIDTH  10
`define VDP_Y_WIDTH  10

// Number and dimensions of sprites

`define VDP_SPRITE_INDEX_WIDTH         3
`define VDP_SPRITE_COLUMN_INDEX_WIDTH  3
`define VDP_SPRITE_ROW_INDEX_WIDTH     3

`define VDP_N_SPRITES      (1 << `VDP_SPRITE_INDEX_WIDTH)
`define VDP_SPRITE_WIDTH   (1 << `VDP_SPRITE_COLUMN_INDEX_WIDTH)
`define VDP_SPRITE_HEIGHT  (1 << `VDP_SPRITE_ROW_INDEX_WIDTH)

// Word size when writing

`define VDP_WR_DATA_WIDTH  32

//  Address bits
//
//     +-++++-------------------------------- 28 : 24 VDP memory space
//     | ||||
//     | |||| +------------------------------      23 sprite indicator
//     | |||| |
//     | |||| |                 + ++---------  8 :  6 sprite index
//     | |||| |                 | ||
//     | |||| |                 | ||+--------       5 sprite coordinates
//     | |||| |                 | |||
//     | |||| |                 | |||+-++----  4 :  2 sprite row index
//     | |||| |                 | |||| ||
//     V VVVV V                 V VVVV VV
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ...1 1110 S... .... .... .... ..CR RR..

`define VDP_ADDR_SPRITE_INDICATOR_BIT         23
`define VDP_ADDR_SPRITE_INDEX_RANGE       8 :  6
`define VDP_ADDR_SPRITE_XY_BIT                 5
`define VDP_ADDR_SPRITE_ROW_INDEX_RANGE   4 :  2

//  Sprite coordinate data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  E... .... ..XX XXXX XXXX ..YY YYYY YYYY

`define VDP_SPRITE_XY_ENABLE_BIT       31
`define VDP_SPRITE_XY_X_RANGE     21 : 12
`define VDP_SPRITE_XY_Y_RANGE      9 :  0

//  Sprite row data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ERGB ERGB ERGB ERGB ERGB ERGB ERGB ERGB

`define VDP_RGB_WIDTH   3
`define VDP_ERGB_WIDTH  (VDP_RGB_WIDTH + 1)
`define VDP_ERGB_INDEX_WIDTH  2
`define VDP_ERGB_WIDTH  (VDP_RGB_WIDTH + 1)


//  Note that the following is assumed:
//
//  `VDP_ADDR_SPRITE_INDEX_RANGE      matches `VDP_SPRITE_INDEX_WIDTH
//  `VDP_ADDR_SPRITE_ROW_INDEX_RANGE  matches `VDP_SPRITE_ROW_INDEX_WIDTH
//
//  `VDP_SPRITE_XY_X_RANGE            matches `VDP_X_WIDTH
//  `VDP_SPRITE_XY_Y_RANGE            matches `VDP_Y_WIDTH
//
//  `VDP_WR_DATA_WIDTH == (`VDP_SPRITE_WIDTH * `VDP_ERGB_WIDTH)
