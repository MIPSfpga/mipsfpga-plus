module de0_cv
(
    input           CLOCK2_50,
    input           CLOCK3_50,
    inout           CLOCK4_50,
    input           CLOCK_50,
                   
    input           RESET_N,

    input   [ 3:0]  KEY,
    input   [ 9:0]  SW,

    output  [ 9:0]  LEDR,

    output  [ 6:0]  HEX0,
    output  [ 6:0]  HEX1,
    output  [ 6:0]  HEX2,
    output  [ 6:0]  HEX3,
    output  [ 6:0]  HEX4,
    output  [ 6:0]  HEX5,
                   
    output  [12:0]  DRAM_ADDR,
    output  [ 1:0]  DRAM_BA,
    output          DRAM_CAS_N,
    output          DRAM_CKE,
    output          DRAM_CLK,
    output          DRAM_CS_N,
    inout   [15:0]  DRAM_DQ,
    output          DRAM_LDQM,
    output          DRAM_RAS_N,
    output          DRAM_UDQM,
    output          DRAM_WE_N,
                   
    output  [ 3:0]  VGA_B,
    output  [ 3:0]  VGA_G,
    output          VGA_HS,
    output  [ 3:0]  VGA_R,
    output          VGA_VS,

    inout           PS2_CLK,
    inout           PS2_CLK2,
    inout           PS2_DAT,
    inout           PS2_DAT2,
                   
    output          SD_CLK,
    inout           SD_CMD,
    inout   [ 3:0]  SD_DATA,
                   
    inout   [35:0]  GPIO_0,
    inout   [35:0]  GPIO_1
);

    wire [17:0] IO_RedLEDs;
    wire [ 8:0] IO_GreenLEDs;

    assign LEDR = { 1'b0, IO_GreenLEDs };

    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;

    mfp_system mfp_system
    (
        .SI_ClkIn         (   CLOCK_50      ),
        .SI_Reset         ( ~ RESET_N       ),
                          
        .HADDR            ( HADDR           ),
        .HRDATA           ( HRDATA          ),
        .HWDATA           ( HWDATA          ),
        .HWRITE           ( HWRITE          ),
                          
        .EJ_TRST_N_probe  (   GPIO_1 [22]   ),
        .EJ_TDI           (   GPIO_1 [21]   ),
        .EJ_TDO           (   GPIO_1 [19]   ),
        .EJ_TMS           (   GPIO_1 [23]   ),
        .EJ_TCK           (   GPIO_1 [17]   ),
        .SI_ColdReset     ( ~ GPIO_1 [20]   ),
        .EJ_DINT          (   1'b0          ),

        .IO_Switches      ( { 8'b0,   SW  } ),
        .IO_Buttons       ( { 1'b0, ~ KEY } ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ),
                          
        .UART_RX          ( GPIO_1 [31]     ),
        .UART_TX          ( /* TODO */      )
    );

    assign GPIO_1 [15] = 1'b0;
    assign GPIO_1 [14] = 1'b0;
    assign GPIO_1 [13] = 1'b1;
    assign GPIO_1 [12] = 1'b1;

    single_digit_display digit_5 (         HADDR      [31:28]   , HEX5 );
    single_digit_display digit_4 ( { 2'b0, IO_RedLEDs [17:16] } , HEX4 );
    single_digit_display digit_3 (         IO_RedLEDs [15:12]   , HEX3 );
    single_digit_display digit_2 (         IO_RedLEDs [11: 8]   , HEX2 );
    single_digit_display digit_1 (         IO_RedLEDs [ 7: 4]   , HEX1 );
    single_digit_display digit_0 (         IO_RedLEDs [ 3: 0]   , HEX0 );

endmodule

//--------------------------------------------------------------------

module single_digit_display
(
    input      [3:0] digit,
    output reg [6:0] seven_segments
);

    always @*
        case (digit)
        'h0: seven_segments = 'b1000000;  // a b c d e f g
        'h1: seven_segments = 'b1111001;
        'h2: seven_segments = 'b0100100;  //   --a--
        'h3: seven_segments = 'b0110000;  //  |     |
        'h4: seven_segments = 'b0011001;  //  f     b
        'h5: seven_segments = 'b0010010;  //  |     |
        'h6: seven_segments = 'b0000010;  //   --g--
        'h7: seven_segments = 'b1111000;  //  |     |
        'h8: seven_segments = 'b0000000;  //  e     c
        'h9: seven_segments = 'b0011000;  //  |     |
        'ha: seven_segments = 'b0001000;  //   --d-- 
        'hb: seven_segments = 'b0000011;
        'hc: seven_segments = 'b1000110;
        'hd: seven_segments = 'b0100001;
        'he: seven_segments = 'b0000110;
        'hf: seven_segments = 'b0001110;
        endcase

endmodule
