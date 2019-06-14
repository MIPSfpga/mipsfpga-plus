//  VDP defines

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

`define VDP_SPRITE_INDEX_WIDTH      3
`define VDP_SPRITE_ROW_INDEX_WIDTH  3

`define VDP_SPRITE_N_ROWS  (1 << `VDP_SPRITE_ROW_INDEX_WIDTH)
`define VDP_N_SPRITES      (1 << `VDP_SPRITE_INDEX_WIDTH)

//  Sprite coordinate data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  E... .... ..XX XXXX XXXX ..YY YYYY YYYY

`define VDP_SPRITE_XY_ENABLE_BIT       31
`define VDP_SPRITE_XY_X_RANGE     21 : 12
`define VDP_SPRITE_XY_Y_RANGE      9 :  0

`define VDP_X_WIDTH  10
`define VDP_Y_WIDTH  10

//  Sprite row data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ERGB ERGB ERGB ERGB ERGB ERGB ERGB ERGB

`define VDP_ERGB_WIDTH  4
`define VDP_RGB_WIDTH   3
