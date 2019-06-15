//  VDP defines

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

#define VDP_ADDR_SPRITE_INDICATOR_BIT    23

#define VDP_ADDR_SPRITE_INDEX_LEFT        8
#define VDP_ADDR_SPRITE_INDEX_RIGHT       6

#define VDP_ADDR_SPRITE_XY_BIT            5

#define VDP_ADDR_SPRITE_ROW_INDEX_LEFT    4
#define VDP_ADDR_SPRITE_ROW_INDEX_RIGHT   2


#define VDP_BASE_ADDR  0xbe000000
#define VDP       ((volatile unsigned *) VDP_ADDR)


//  Sprite coordinate data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  E... .... ..XX XXXX XXXX ..YY YYYY YYYY

#define VDP_SPRITE_XY_ENABLE_BIT  31

#define VDP_SPRITE_XY_X_LEFT      21
#define VDP_SPRITE_XY_X_RIGHT     12

#define VDP_SPRITE_XY_Y_LEFT       9
#define VDP_SPRITE_XY_Y_RIGHT      0

//  Sprite row data
//
//  3322 2222 2222 1111 1111 1100 0000 0000
//  1098 7654 3210 9876 5432 1098 7654 3210
//
//  ERGB ERGB ERGB ERGB ERGB ERGB ERGB ERGB

#define VDP_RGB_WIDTH   3
#define VDP_ERGB_WIDTH  (VDP_RGB_WIDTH + 1)

//  Note that the following is assumed:
//
//  VDP_ADDR_SPRITE_INDEX_RANGE      matches VDP_SPRITE_INDEX_WIDTH
//  VDP_ADDR_SPRITE_ROW_INDEX_RANGE  matches VDP_SPRITE_ROW_INDEX_WIDTH
//

// 10 bits of X and 10 bits of Y can cover 640x480 and 800x600 VGA modes

#define VDP_X_WIDTH  (VDP_SPRITE_XY_X_RIGHT - VDP_SPRITE_XY_X_LEFT + 1)
#define VDP_Y_WIDTH  (VDP_SPRITE_XY_Y_RIGHT - VDP_SPRITE_XY_Y_LEFT + 1)

// Number and dimensions of sprites

#define VDP_SPRITE_INDEX_WIDTH         3
#define VDP_SPRITE_COLUMN_INDEX_WIDTH  3

#define VDP_SPRITE_ROW_INDEX_WIDTH  \
    (VDP_ADDR_SPRITE_ROW_INDEX_RIGHT - VDP_ADDR_SPRITE_ROW_INDEX_LEFT + 1)

#define VDP_N_SPRITES      (1 << VDP_SPRITE_INDEX_WIDTH)
#define VDP_SPRITE_WIDTH   (1 << VDP_SPRITE_COLUMN_INDEX_WIDTH)
#define VDP_SPRITE_HEIGHT  (1 << VDP_SPRITE_ROW_INDEX_WIDTH)

// Word size when writing

#define VDP_WR_DATA_WIDTH  (VDP_SPRITE_WIDTH * VDP_ERGB_WIDTH)

// RGB colors

#define VDP_COLOR_BLACK    0x8
#define VDP_COLOR_BLUE     0x9
#define VDP_COLOR_GREEN    0xa
#define VDP_COLOR_CYAN     0xb
#define VDP_COLOR_RED      0xc
#define VDP_COLOR_MAGENTA  0xd
#define VDP_COLOR_YELLOW   0xe
#define VDP_COLOR_WHITE    0xf
