//  VDP defines

//  Address bits
//
//     +-++++-------------------------------- 28 : 24 VDP memory space
//     | ||||
//     | |||| +------------------------------      23 sprite indicator
//     | |||| |
//     | |||| |                     +--------       5 sprite coordinates
//     | |||| |                     |
//     | |||| |                     |+-++----  4 :  2 sprite line
//     | |||| |                     || ||
//     V VVVV V                     VV VV
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ...1 1110 I... .... .... .... ..CL LL..

`define VDP_ADDR_SPRITE_BIT_INDICATOR        23
`define VDP_ADDR_SPRITE_BIT_COORDINATES       5
`define VDP_ADDR_SPRITE_RANGE_LINE        4 : 2

//  Sprite line data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ERGB ERGB ERGB ERGB ERGB ERGB ERGB ERGB
