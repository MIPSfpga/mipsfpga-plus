`include "mfp_ahb_lite_matrix_config.vh"

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

    wire clk;

    `ifdef MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX

    wire       muxed_clk;
    wire [1:0] sw_db;

    mfp_multi_switch_or_button_sync_and_debouncer
    # (.WIDTH (2))
    mfp_multi_switch_or_button_sync_and_debouncer
    (   
        .clk    ( CLOCK_50 ),
        .sw_in  ( SW [1:0] ),
        .sw_out ( sw_db    )
    );

    mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz 
    mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz
    (
        .clki    ( CLOCK_50  ),
        .sel_lo  ( sw_db [0] ),
        .sel_mid ( sw_db [1] ),
        .clko    ( muxed_clk )
    );

    global gclk
    (
        .in     ( muxed_clk  ), 
        .out    ( clk        )
    );

    `else

    assign clk = CLOCK_50;

    `endif

    wire [17:0] IO_RedLEDs;
    wire [ 8:0] IO_GreenLEDs;

    assign LEDR = { 1'b0, IO_GreenLEDs };

    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;

    mfp_system mfp_system
    (
        .SI_ClkIn         (   clk           ),
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
        .UART_TX          ( /* TODO */      ),

        .SPI_CS           ( /* TODO */      ),
        .SPI_SCK          ( /* TODO */      ),
        .SPI_SDO          ( /* TODO */      )
    );

    assign GPIO_1 [15] = 1'b0;
    assign GPIO_1 [14] = 1'b0;
    assign GPIO_1 [13] = 1'b1;
    assign GPIO_1 [12] = 1'b1;

    mfp_single_digit_seven_segment_display digit_5
        (         HADDR      [31:28]   , HEX5 );

    mfp_single_digit_seven_segment_display digit_4
        ( { 2'b0, IO_RedLEDs [17:16] } , HEX4 );

    mfp_single_digit_seven_segment_display digit_3
        (         IO_RedLEDs [15:12]   , HEX3 );

    mfp_single_digit_seven_segment_display digit_2
        (         IO_RedLEDs [11: 8]   , HEX2 );

    mfp_single_digit_seven_segment_display digit_1
        (         IO_RedLEDs [ 7: 4]   , HEX1 );

    mfp_single_digit_seven_segment_display digit_0
        (         IO_RedLEDs [ 3: 0]   , HEX0 );

endmodule
