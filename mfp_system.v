`include "m14k_const.vh"
`include "mfp_ahb_lite_matrix_config.vh"

module mfp_system
(
    input         SI_ClkIn,
    input         SI_ColdReset,
    input         SI_Reset,

    output [31:0] HADDR,
    output [31:0] HRDATA,
    output [31:0] HWDATA,
    output        HWRITE,

    input         EJ_TRST_N_probe,
    input         EJ_TDI,
    output        EJ_TDO,
    input         EJ_TMS,
    input         EJ_TCK,
    input         EJ_DINT,

    input  [17:0] IO_Switches,
    input  [ 4:0] IO_Buttons,
    output [17:0] IO_RedLEDs,
    output [ 8:0] IO_GreenLEDs,

    input         UART_RX,
    output        UART_TX
);

    wire MFP_Reset;

    wire [ 0:0] BistIn;
    wire [ 0:0] BistOut;
    wire [ 0:0] CP2_fromcp2;
    wire [ 0:0] CP2_tocp2;
    wire [ 0:0] DSP_fromdsp;
    wire [ 0:0] DSP_todsp;
    wire        EJ_DebugM;
//  wire        EJ_DINT;
    wire        EJ_DINTsup;
    wire        EJ_DisableProbeDebug;
    wire        EJ_ECREjtagBrk;
    wire [10:0] EJ_ManufID;
    wire [15:0] EJ_PartNumber;
    wire        EJ_PerRst;
    wire        EJ_PrRst;
    wire        EJ_SRstE;
//  wire        EJ_TCK;
//  wire        EJ_TDI;
//  wire        EJ_TDO;
    wire        EJ_TDOzstate;
//  wire        EJ_TMS;
    wire        EJ_TRST_N;
    wire [ 3:0] EJ_Version;
    wire [ 7:0] gmb_dc_algorithm;
    wire        gmbddfail;
    wire        gmbdifail;
    wire        gmbdone;
    wire [ 7:0] gmb_ic_algorithm;
    wire        gmbinvoke;
    wire [ 7:0] gmb_isp_algorithm;
    wire        gmbispfail;
    wire [ 7:0] gmb_sp_algorithm;
    wire        gmbspfail;
    wire        gmbtdfail;
    wire        gmbtifail;
    wire        gmbwdfail;
    wire        gmbwifail;
    wire        gscanenable;
    wire [ 0:0] gscanin;
    wire        gscanmode;
    wire [ 0:0] gscanout;
    wire        gscanramwr;
//  wire [31:0] HADDR;
    wire [ 2:0] HBURST;
    wire        HCLK;
    wire        HMASTLOCK;
    wire [ 3:0] HPROT;
//  wire [31:0] HRDATA;
    wire        HREADY;
    wire        HRESETn;
    wire        HRESP;
    wire [ 2:0] HSIZE;
    wire [ 1:0] HTRANS;
//  wire [31:0] HWDATA;
//  wire        HWRITE;
    wire [ 0:0] ISP_fromisp;
    wire [ 0:0] ISP_toisp;
    wire        PM_InstnComplete;
    wire        SI_AHBStb;
    wire        SI_BootExcISAMode;
//  wire        SI_ClkIn;
    wire        SI_ClkOut;
//  wire        SI_ColdReset;
    wire [ 9:0] SI_CPUNum;
    wire [ 3:0] SI_Dbs;
    wire        SI_EICPresent;
    wire [ 5:0] SI_EICVector;
    wire [ 3:0] SI_EISS;
    wire        SI_Endian;
    wire        SI_ERL;
    wire        SI_EXL;
    wire        SI_FDCInt;
    wire        SI_IAck;
    wire [ 7:0] SI_Ibs;
    wire [ 7:0] SI_Int;
    wire [17:1] SI_ION;
    wire [ 2:0] SI_IPFDCI;
    wire [ 7:0] SI_IPL;
    wire [ 2:0] SI_IPPCI;
    wire [ 2:0] SI_IPTI;
    wire [ 5:0] SI_IVN;
    wire [ 1:0] SI_MergeMode;
    wire        SI_NESTERL;
    wire        SI_NESTEXL;
    wire        SI_NMI;
    wire        SI_NMITaken;
    wire [17:1] SI_Offset;
    wire        SI_PCInt;
//  wire        SI_Reset;
    wire        SI_RP;
    wire        SI_Sleep;
    wire [ 3:0] SI_SRSDisable;
    wire [ 1:0] SI_SWInt;
    wire        SI_TimerInt;
    wire        SI_TraceDisable;
    wire [ 2:0] TC_ClockRatio;
    wire [63:0] TC_Data;
    wire        TC_PibPresent;
    wire        TC_Stall;
    wire        TC_Valid;
    wire [ 0:0] UDI_fromudi;
    wire [ 0:0] UDI_toudi;

    m14k_top m14k_top
    (
        .BistIn                ( BistIn                ),
        .BistOut               ( BistOut               ),
        .CP2_fromcp2           ( CP2_fromcp2           ),
        .CP2_tocp2             ( CP2_tocp2             ),
        .DSP_fromdsp           ( DSP_fromdsp           ),
        .DSP_todsp             ( DSP_todsp             ),
        .EJ_DebugM             ( EJ_DebugM             ),
        .EJ_DINT               ( EJ_DINT               ),
        .EJ_DINTsup            ( EJ_DINTsup            ),
        .EJ_DisableProbeDebug  ( EJ_DisableProbeDebug  ),
        .EJ_ECREjtagBrk        ( EJ_ECREjtagBrk        ),
        .EJ_ManufID            ( EJ_ManufID            ),
        .EJ_PartNumber         ( EJ_PartNumber         ),
        .EJ_PerRst             ( EJ_PerRst             ),
        .EJ_PrRst              ( EJ_PrRst              ),
        .EJ_SRstE              ( EJ_SRstE              ),
        .EJ_TCK                ( EJ_TCK                ),
        .EJ_TDI                ( EJ_TDI                ),
        .EJ_TDO                ( EJ_TDO                ),
        .EJ_TDOzstate          ( EJ_TDOzstate          ),
        .EJ_TMS                ( EJ_TMS                ),
        .EJ_TRST_N             ( EJ_TRST_N             ),
        .EJ_Version            ( EJ_Version            ),
        .gmb_dc_algorithm      ( gmb_dc_algorithm      ),
        .gmbddfail             ( gmbddfail             ),
        .gmbdifail             ( gmbdifail             ),
        .gmbdone               ( gmbdone               ),
        .gmb_ic_algorithm      ( gmb_ic_algorithm      ),
        .gmbinvoke             ( gmbinvoke             ),
        .gmb_isp_algorithm     ( gmb_isp_algorithm     ),
        .gmbispfail            ( gmbispfail            ),
        .gmb_sp_algorithm      ( gmb_sp_algorithm      ),
        .gmbspfail             ( gmbspfail             ),
        .gmbtdfail             ( gmbtdfail             ),
        .gmbtifail             ( gmbtifail             ),
        .gmbwdfail             ( gmbwdfail             ),
        .gmbwifail             ( gmbwifail             ),
        .gscanenable           ( gscanenable           ),
        .gscanin               ( gscanin               ),
        .gscanmode             ( gscanmode             ),
        .gscanout              ( gscanout              ),
        .gscanramwr            ( gscanramwr            ),
        .HADDR                 ( HADDR                 ),
        .HBURST                ( HBURST                ),
        .HCLK                  ( HCLK                  ),
        .HMASTLOCK             ( HMASTLOCK             ),
        .HPROT                 ( HPROT                 ),
        .HRDATA                ( HRDATA                ),
        .HREADY                ( HREADY                ),
        .HRESETn               ( HRESETn               ),
        .HRESP                 ( HRESP                 ),
        .HSIZE                 ( HSIZE                 ),
        .HTRANS                ( HTRANS                ),
        .HWDATA                ( HWDATA                ),
        .HWRITE                ( HWRITE                ),
        .ISP_fromisp           ( ISP_fromisp           ),
        .ISP_toisp             ( ISP_toisp             ),
        .PM_InstnComplete      ( PM_InstnComplete      ),
        .SI_AHBStb             ( SI_AHBStb             ),
        .SI_BootExcISAMode     ( SI_BootExcISAMode     ),
        .SI_ClkIn              ( SI_ClkIn              ),
        .SI_ClkOut             ( SI_ClkOut             ),
        .SI_ColdReset          ( SI_ColdReset          ),
        .SI_CPUNum             ( SI_CPUNum             ),
        .SI_Dbs                ( SI_Dbs                ),
        .SI_EICPresent         ( SI_EICPresent         ),
        .SI_EICVector          ( SI_EICVector          ),
        .SI_EISS               ( SI_EISS               ),
        .SI_Endian             ( SI_Endian             ),
        .SI_ERL                ( SI_ERL                ),
        .SI_EXL                ( SI_EXL                ),
        .SI_FDCInt             ( SI_FDCInt             ),
        .SI_IAck               ( SI_IAck               ),
        .SI_Ibs                ( SI_Ibs                ),
        .SI_Int                ( SI_Int                ),
        .SI_ION                ( SI_ION                ),
        .SI_IPFDCI             ( SI_IPFDCI             ),
        .SI_IPL                ( SI_IPL                ),
        .SI_IPPCI              ( SI_IPPCI              ),
        .SI_IPTI               ( SI_IPTI               ),
        .SI_IVN                ( SI_IVN                ),
        .SI_MergeMode          ( SI_MergeMode          ),
        .SI_NESTERL            ( SI_NESTERL            ),
        .SI_NESTEXL            ( SI_NESTEXL            ),
        .SI_NMI                ( SI_NMI                ),
        .SI_NMITaken           ( SI_NMITaken           ),
        .SI_Offset             ( SI_Offset             ),
        .SI_PCInt              ( SI_PCInt              ),
        .SI_Reset              ( SI_Reset | MFP_Reset  ),
        .SI_RP                 ( SI_RP                 ),
        .SI_Sleep              ( SI_Sleep              ),
        .SI_SRSDisable         ( SI_SRSDisable         ),
        .SI_SWInt              ( SI_SWInt              ),
        .SI_TimerInt           ( SI_TimerInt           ),
        .SI_TraceDisable       ( SI_TraceDisable       ),
        .TC_ClockRatio         ( TC_ClockRatio         ),
        .TC_Data               ( TC_Data               ),
        .TC_PibPresent         ( TC_PibPresent         ),
        .TC_Stall              ( TC_Stall              ),
        .TC_Valid              ( TC_Valid              ),
        .UDI_fromudi           ( UDI_fromudi           ),
        .UDI_toudi             ( UDI_toudi             )
    );

        assign BistIn                =  1'b0;
        assign CP2_tocp2             =  1'b0;
        assign DSP_todsp             =  1'b0;
    //  assign EJ_DINT               =  1'b0;
        assign EJ_DINTsup            =  1'b0;
        assign EJ_DisableProbeDebug  =  1'b0;
        assign EJ_ManufID            = 11'b0;
        assign EJ_PartNumber         = 16'b0;
    //  assign EJ_TCK                =  1'b0;
    //  assign EJ_TDI                =  1'b0;
    //  assign EJ_TMS                =  1'b0;
    //  assign EJ_TRST_N             =  1'b0;
        assign EJ_Version            =  4'b0;
        assign gmb_dc_algorithm      =  8'b0;
        assign gmb_ic_algorithm      =  8'b0;
        assign gmbinvoke             =  1'b0;
        assign gmb_isp_algorithm     =  8'b0;
        assign gmb_sp_algorithm      =  8'b0;
        assign gscanenable           =  1'b0;
        assign gscanin               =  1'b0;
        assign gscanmode             =  1'b0;
        assign gscanramwr            =  1'b0;
    //  assign HRDATA                = 32'b0;
    //  assign HREADY                =  1'b0;
    //  assign HRESP                 =  1'b0;
        assign ISP_toisp             =  1'b0;
    //  assign SI_AHBStb             =  1'b0;
        assign SI_BootExcISAMode     =  1'b0;
    //  assign SI_ClkIn              =  1'b0;
    //  assign SI_ColdReset          =  1'b0;
        assign SI_CPUNum             = 10'b0;
        assign SI_EICPresent         =  1'b0;
        assign SI_EICVector          =  6'b0;
        assign SI_EISS               =  4'b0;
        assign SI_Endian             =  1'b0;
        assign SI_Int                =  8'b0;
        assign SI_IPFDCI             =  3'b0;
        assign SI_IPPCI              =  3'b0;
        assign SI_IPTI               =  3'b0;
        assign SI_MergeMode          =  2'b0;
        assign SI_NMI                =  1'b0;
        assign SI_Offset             = 17'b0;
    //  assign SI_Reset              =  1'b0;
    //  assign SI_SRSDisable         =  4'b0;
    //  assign SI_TraceDisable       =  1'b0;
        assign TC_PibPresent         =  1'b0;
        assign TC_Stall              =  1'b0;
        assign UDI_toudi             =  1'b0;

    // Module for hardware reset of EJTAG just after FPGA configuration
    // It pulses EJ_TRST_N low for 16 clock cycles.
    
    mfp_ejtag_reset ejtag_reset (.clk (SI_ClkIn), .trst_n (trst_n));

    assign EJ_TRST_N       = trst_n & EJ_TRST_N_probe;
    assign SI_SRSDisable   = 4'b1111;  // Disable banks of shadow sets
    assign SI_TraceDisable = 1'b1;     // Disables trace hardware
    assign SI_AHBStb       = 1'b1;     // AHB: Signal indicating phase and frequency relationship between clk and hclk.

    assign UART_TX         = 1'b0;

    mfp_ahb_lite_matrix_with_loader ahb_lite_matrix
    (
        .HCLK          (   HCLK          ),
        .HRESETn       ( ~ SI_Reset      ),  // Not HRESETn - this is necessary for serial loader
        .HADDR         (   HADDR         ),
        .HBURST        (   HBURST        ),
        .HMASTLOCK     (   HMASTLOCK     ),
        .HPROT         (   HPROT         ),
        .HSIZE         (   HSIZE         ),
        .HTRANS        (   HTRANS        ),
        .HWDATA        (   HWDATA        ),
        .HWRITE        (   HWRITE        ),
        .HRDATA        (   HRDATA        ),
        .HREADY        (   HREADY        ),
        .HRESP         (   HRESP         ),
        .SI_Endian     (   SI_Endian     ),
                                           
        .IO_Switches   (   IO_Switches   ),
        .IO_Buttons    (   IO_Buttons    ),
        .IO_RedLEDs    (   IO_RedLEDs    ),
        .IO_GreenLEDs  (   IO_GreenLEDs  ), 
                           
        .UART_RX       (   UART_RX       ), 
        .UART_TX       (   UART_TX       ),
                           
        .MFP_Reset     (   MFP_Reset     )
    );

endmodule

//--------------------------------------------------------------------

module mfp_ejtag_reset
(
    input      clk,
    output reg trst_n
);

    reg [3:0] trst_delay;
  
    always @ (posedge clk)
    begin
        if (trst_delay == 4'hf)
            trst_n     <= 1'b1;
        else
        begin
            trst_n     <= 1'b0;
            trst_delay <= trst_delay + 4'b1;
        end
    end

endmodule
