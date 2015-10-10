module basys3
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an,

    inout  [ 7:0] JB 
);

    wire        SI_Reset     = btnC;
    wire [17:0] IO_Switches  = { 2'b0, sw };
    wire [ 4:0] IO_Buttons   = { btnU, btnD, btnL, 1'b0, btnR };
    wire [17:0] IO_RedLEDs;
    wire [ 8:0] IO_GreenLEDs;

    assign led = IO_RedLEDs [15:0];
    assign seg = 7'b0;
    assign dp  = 1'b0;
    assign an  = 4'hf;

    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;

    wire clk_50_mhz;

    clk_wiz_0 clk_wiz_0 (.clk_in1 (clk), .clk_out1 (clk_50_mhz));

    wire ejtag_tck_in, ejtag_tck;

    IBUF IBUF (.O ( ejtag_tck_in ), .I ( JB [3]       ));
    BUFG BUFG (.O ( ejtag_tck    ), .I ( ejtag_tck_in ));

    mfp_system mfp_system
    (
        .SI_ClkIn         ( clk_50_mhz      ),
        .SI_Reset         ( SI_Reset        ),
                          
        .HADDR            ( HADDR           ),
        .HRDATA           ( HRDATA          ),
        .HWDATA           ( HWDATA          ),
        .HWRITE           ( HWRITE          ),

        .EJ_TRST_N_probe  (   JB [4]        ),
        .EJ_TDI           (   JB [1]        ),
        .EJ_TDO           (   JB [2]        ),
        .EJ_TMS           (   JB [0]        ),
        .EJ_TCK           (   ejtag_tck     ),
        .SI_ColdReset     ( ~ JB [5]        ),
        .EJ_DINT          (   1'b0          ),

        .IO_Switches      ( IO_Switches     ),
        .IO_Buttons       ( IO_Buttons      ),
        .IO_RedLEDs       ( IO_RedLEDs      ),
        .IO_GreenLEDs     ( IO_GreenLEDs    ),
                          
        .UART_RX          ( /* TODO */      ),
        .UART_TX          ( /* TODO */      )
    );

endmodule
