`include "mfp_ahb_lite_matrix_config.vh"

module de0_nano
(
    input         CLOCK_50,
    output [ 7:0] LED,
    input  [ 1:0] KEY,
    input  [ 3:0] SW,

    output [12:0] DRAM_ADDR,
    output [ 1:0] DRAM_BA,
    output        DRAM_CAS_N,
    output        DRAM_CKE,
    output        DRAM_CLK,
    output        DRAM_CS_N,
    inout  [15:0] DRAM_DQ,
    output [ 1:0] DRAM_DQM,
    output        DRAM_RAS_N,
    output        DRAM_WE_N,

    output        EPCS_ASDO,
    input         EPCS_DATA0,
    output        EPCS_DCLK,
    output        EPCS_NCSO,

    output        G_SENSOR_CS_N,
    input         G_SENSOR_INT,
    output        I2C_SCLK,
    inout         I2C_SDAT,

    output        ADC_CS_N,
    output        ADC_SADDR,
    output        ADC_SCLK,
    input         ADC_SDAT,

    inout  [12:0] GPIO_2,
    input  [ 2:0] GPIO_2_IN,

    inout  [33:0] GPIO_0_D,
    input  [ 1:0] GPIO_0_IN,

    inout  [33:0] GPIO_1_D,
    input  [ 1:0] GPIO_1_IN
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
    wire [17:0] IO_Switches   = { 14'b0, SW  [3:0] };
    wire [ 4:0] IO_Buttons    = {  3'b0, KEY [1:0] };

    assign LED = IO_RedLEDs [7:0] };
                          
    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;

    mfp_system mfp_system
    (
        .SI_ClkIn         (   clk           ),
        .SI_Reset         ( ~ KEY [1]       ),
                          
        .HADDR            ( HADDR           ),
        .HRDATA           ( HRDATA          ),
        .HWDATA           ( HWDATA          ),
        .HWRITE           ( HWRITE          ),
                          
        .EJ_TRST_N_probe  (   GPIO_0_D [20] ),
        .EJ_TDI           (   GPIO_0_D [19] ),
        .EJ_TDO           (   GPIO_0_D [17] ),
        .EJ_TMS           (   GPIO_0_D [21] ),
        .EJ_TCK           (   GPIO_0_D [15] ),
        .SI_ColdReset     ( ~ GPIO_0_D [18] ),
        .EJ_DINT          (   1'b0          ),

        .IO_Switches      ( IO_Switches     ),
        .IO_Buttons       ( IO_Buttons      ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ),
                          
        .UART_RX          ( GPIO_0_D [29]   ),
        .UART_TX          ( /* TODO */      ),

        .SPI_CS           ( GPIO_0_D [32]   ),
        .SPI_SCK          ( GPIO_0_D [26]   ),
        .SPI_SDO          ( GPIO_0_D [28]   )
    );

    assign GPIO_0_D [13] = 1'b0;
    assign GPIO_0_D [12] = 1'b0;
    assign GPIO_0_D [11] = 1'b1;
    assign GPIO_0_D [10] = 1'b1;

endmodule
