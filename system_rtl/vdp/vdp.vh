//  VDP defines

//  Address bits
//
//     +-++++-------------------------------- 28 : 24 VDP memory space
//     | ||||
//     | |||| +------------------------------      23 sprite indicator
//     | |||| |
//     | |||| |                 + ++---------  8 :  6 sprite number
//     | |||| |                 | ||
//     | |||| |                 | ||+--------       5 sprite coordinates
//     | |||| |                 | |||
//     | |||| |                 | |||+-++----  4 :  2 sprite row
//     | |||| |                 | |||| ||
//     V VVVV V                 V VVVV VV
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ...1 1110 S... .... .... .... ..CR RR..

`define VDP_ADDR_SPRITE_BIT_INDICATOR         23
`define VDP_ADDR_SPRITE_RANGE_NUMBER      8 :  6
`define VDP_ADDR_SPRITE_BIT_COORDINATES        5
`define VDP_ADDR_SPRITE_RANGE_ROW         4 :  2

//  Sprite coordinates data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  E... .... ..XX XXXX XXXX ..YY YYYY YYYY

`define VDP_SPRITE_COORD_BIT_ENABLE           31
`define VDP_SPRITE_COORD_RANGE_X         21 : 12
`define VDP_SPRITE_COORD_RANGE_Y          9 :  0

//  Sprite row data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ERGB ERGB ERGB ERGB ERGB ERGB ERGB ERGB
