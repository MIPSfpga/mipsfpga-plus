`include "mfp_ahb_lite_matrix_config.vh"

module nexys4_ddr
(
    input         CLK100MHZ,
    input         CPU_RESETN,

    input         BTNC,
    input         BTNU,
    input         BTNL,
    input         BTNR,
    input         BTND,

    input  [15:0] SW, 

    output [15:0] LED,

    output        LED16_B,
    output        LED16_G,
    output        LED16_R,
    output        LED17_B,
    output        LED17_G,
    output        LED17_R,

    output        CA,
    output        CB,
    output        CC,
    output        CD,
    output        CE,
    output        CF,
    output        CG,
    output        DP,

    output [ 7:0] AN,

    inout  [12:1] JA,
    inout  [12:1] JB,

    input         UART_TXD_IN
);

    wire clk;

    `ifdef MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX

    wire       muxed_clk;
    wire [1:0] sw_db;

    mfp_multi_switch_or_button_sync_and_debouncer
    # (.WIDTH (2))
    mfp_multi_switch_or_button_sync_and_debouncer
    (   
        .clk    ( CLK100MHZ ),
        .sw_in  ( SW [1:0]  ),
        .sw_out ( sw_db     )
    );

    mfp_clock_divider_100_MHz_to_25_MHz_12_Hz_0_75_Hz 
    mfp_clock_divider_100_MHz_to_25_MHz_12_Hz_0_75_Hz
    (
        .clki    ( CLK100MHZ ),
        .sel_lo  ( sw_db [0] ),
        .sel_mid ( sw_db [1] ),
        .clko    ( muxed_clk )
    );

    BUFG BUFG_slow_clk (.O ( clk ), .I ( muxed_clk ));

    `else

    clk_wiz_0 clk_wiz_0 (.clk_in1 (CLK100MHZ), .clk_out1 (clk));

    `endif

    wire [17:0] IO_Switches  = { 2'b0, SW };
    wire [ 4:0] IO_Buttons   = { BTNU, BTND, BTNL, BTNC, BTNR };
    wire [17:0] IO_RedLEDs;
    wire [ 8:0] IO_GreenLEDs;

    assign LED = { 7'b0, clk, IO_GreenLEDs [7 /* 8 */:0] };

    assign LED16_B = 1'b0;
    assign LED16_G = 1'b0;
    assign LED16_R = 1'b0;
    assign LED17_B = 1'b0;
    assign LED17_G = 1'b0;
    assign LED17_R = 1'b0;

    // assign { CA, CB, CC, CD, CE, CF, CG, DP } = 8'b0;
    // assign AN = 8'hFF;

    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;

    wire ejtag_tck_in, ejtag_tck;

    IBUF IBUF           (.O ( ejtag_tck_in ), .I ( JB [4]       ));
    BUFG BUFG_ejtag_tck (.O ( ejtag_tck    ), .I ( ejtag_tck_in ));

    mfp_system mfp_system
    (
        .SI_ClkIn         (   clk           ),
        .SI_Reset         ( ~ CPU_RESETN    ),
                          
        .HADDR            ( HADDR           ),
        .HRDATA           ( HRDATA          ),
        .HWDATA           ( HWDATA          ),
        .HWRITE           ( HWRITE          ),

        .EJ_TRST_N_probe  (   JB [7]        ),
        .EJ_TDI           (   JB [2]        ),
        .EJ_TDO           (   JB [3]        ),
        .EJ_TMS           (   JB [1]        ),
        .EJ_TCK           (   ejtag_tck_in  ),
        .SI_ColdReset     ( ~ JB [8]        ),
        .EJ_DINT          (   1'b0          ),

        .IO_Switches      ( IO_Switches     ),
        .IO_Buttons       ( IO_Buttons      ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ),
                          
        .UART_RX          ( UART_TXD_IN /* Alternative: JA [10] */ ),
        .UART_TX          ( /* TODO */      ),

        .SPI_CS           (   JA [ 1]       ),
        .SPI_SCK          (   JA [ 4]       ),
        .SPI_SDO          (   JA [ 3]       )
    );

    assign JA [7] = 1'b0;

    wire display_clock;

    mfp_clock_divider_100_MHz_to_763_Hz mfp_clock_divider_100_MHz_to_763_Hz
        (CLK100MHZ, display_clock);

    mfp_multi_digit_display multi_digit_display
    (
        .clock          ( display_clock                  ),
        .resetn         ( CPU_RESETN                     ),
        .number         ( { 14'b0, IO_RedLEDs [17:0] }   ),

        .seven_segments ( { CG, CF, CE, CD, CC, CB, CA } ),
        .dot            ( DP                             ),
        .anodes         ( AN                             )
    );

endmodule
