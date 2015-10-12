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

    input  [15:0] LED,

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

    output [12:1] JA,
    output [12:1] JB
);

    wire       slow_clk_g, slow_clk;
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
        .clko    ( slow_clk  )
    );

    BUFG BUFG (.O ( slow_clk ), .I ( slow_clk_g ));

    wire [17:0] IO_Switches  = { 2'b0, SW };
    wire [ 4:0] IO_Buttons   = { BTNU, BTND, BTNL, BTNC, BTNR };
    wire [17:0] IO_RedLEDs;
    wire [ 8:0] IO_GreenLEDs;

    assign LED = IO_RedLEDs [15:0];

    assign LED16_B = 1'b0;
    assign LED16_G = 1'b0;
    assign LED16_R = 1'b0;
    assign LED17_B = 1'b0;
    assign LED17_G = 1'b0;
    assign LED17_R = 1'b0;

    assign { CA, CB, CC, CD, CE, CF, CG, DP } = 8'b0;
    assign AN = 8'hFF;

    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;

    wire ejtag_tck_in, ejtag_tck;

    IBUF IBUF (.O ( ejtag_tck_in ), .I ( JB [4]       ));
    BUFG BUFG (.O ( ejtag_tck    ), .I ( ejtag_tck_in ));

    mfp_system mfp_system
    (
        .SI_ClkIn         (   slow_clk_g    ),
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
        .SI_ColdReset_N   ( ~ JB [8]        ),
        .EJ_DINT          (   1'b0          ),

        .IO_Switches      ( IO_Switches     ),
        .IO_Buttons       ( IO_Buttons      ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ),
                          
        .UART_RX          (   JA [10]       ),
        .UART_TX          ( /* TODO */      )
    );

    assign JA [7] = 1'b0;

endmodule
