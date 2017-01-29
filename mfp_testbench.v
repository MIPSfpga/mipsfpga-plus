`include "mfp_ahb_lite_matrix_config.vh"

`timescale 1 ns / 100 ps
//`timescale 1ns / 1ps

module mfp_testbench;

    reg         SI_ClkIn;
    reg         SI_ColdReset;
    reg         SI_Reset;

    wire [31:0] HADDR;
    wire [31:0] HRDATA;
    wire [31:0] HWDATA;
    wire        HWRITE;

    reg         EJ_TRST_N_probe;
    reg         EJ_TDI;
    wire        EJ_TDO;
    reg         EJ_TMS;
    reg         EJ_TCK;
    reg         EJ_DINT;

    reg  [`MFP_N_SWITCHES          - 1:0] IO_Switches;
    reg  [`MFP_N_BUTTONS           - 1:0] IO_Buttons;
    wire [`MFP_N_RED_LEDS          - 1:0] IO_RedLEDs;
    wire [`MFP_N_GREEN_LEDS        - 1:0] IO_GreenLEDs;
    wire [`MFP_7_SEGMENT_HEX_WIDTH - 1:0] IO_7_SegmentHEX;

    `ifdef MFP_DEMO_LIGHT_SENSOR
    wire [15:0] IO_LightSensor;
    `endif

    `ifdef MFP_USE_SDRAM_MEMORY
    reg                                 SDRAM_CLK;
    wire                                SDRAM_CKE;
    wire                                SDRAM_CSn;
    wire                                SDRAM_RASn;
    wire                                SDRAM_CASn;
    wire                                SDRAM_WEn;
    wire  [`SDRAM_ADDR_BITS   - 1 : 0]  SDRAM_ADDR;
    wire  [`SDRAM_BA_BITS     - 1 : 0]  SDRAM_BA;
    wire  [`SDRAM_DQ_BITS     - 1 : 0]  SDRAM_DQ;
    wire  [`SDRAM_DM_BITS     - 1 : 0]  SDRAM_DQM;
    `endif

    reg         UART_RX;
    wire        UART_TX;

    wire        SPI_CS;
    wire        SPI_SCK;
    reg         SPI_SDO;

    //----------------------------------------------------------------

    mfp_system system
    (
        .SI_ClkIn         ( SI_ClkIn         ),
        .SI_ColdReset     ( SI_ColdReset     ),
        .SI_Reset         ( SI_Reset         ),
                                              
        .HADDR            ( HADDR            ),
        .HRDATA           ( HRDATA           ),
        .HWDATA           ( HWDATA           ),
        .HWRITE           ( HWRITE           ),
                                              
        .EJ_TRST_N_probe  ( EJ_TRST_N_probe  ),
        .EJ_TDI           ( EJ_TDI           ),
        .EJ_TDO           ( EJ_TDO           ),
        .EJ_TMS           ( EJ_TMS           ),
        .EJ_TCK           ( EJ_TCK           ),
        .EJ_DINT          ( EJ_DINT          ),

        `ifdef MFP_USE_SDRAM_MEMORY
        .SDRAM_CKE        ( SDRAM_CKE        ),
        .SDRAM_CSn        ( SDRAM_CSn        ),
        .SDRAM_RASn       ( SDRAM_RASn       ),
        .SDRAM_CASn       ( SDRAM_CASn       ),
        .SDRAM_WEn        ( SDRAM_WEn        ),
        .SDRAM_ADDR       ( SDRAM_ADDR       ),
        .SDRAM_BA         ( SDRAM_BA         ),
        .SDRAM_DQ         ( SDRAM_DQ         ),
        .SDRAM_DQM        ( SDRAM_DQM        ),
        `endif
                                              
        .IO_Switches      ( IO_Switches      ),
        .IO_Buttons       ( IO_Buttons       ),
        .IO_RedLEDs       ( IO_RedLEDs       ),
        .IO_GreenLEDs     ( IO_GreenLEDs     ), 
        .IO_7_SegmentHEX  ( IO_7_SegmentHEX  ),
                                               
        .UART_RX          ( UART_RX          ),
        .UART_TX          ( UART_TX          ), 

        .SPI_CS           ( SPI_CS           ),
        .SPI_SCK          ( SPI_SCK          ),
        .SPI_SDO          ( SPI_SDO          )
    );

    //----------------------------------------------------------------

    `ifdef MFP_USE_SDRAM_MEMORY

        `include "sdr_parameters.vh"

        initial begin
            SDRAM_CLK = 0; 
            @(posedge SI_ClkIn);
            #(`SDRAM_MEM_CLK_PHASE_SHIFT)
            forever SDRAM_CLK = #(tCK/2) ~SDRAM_CLK;
        end

        initial
        begin
            SI_ClkIn = 0;
            forever #(tCK/2) SI_ClkIn = ~SI_ClkIn;
        end

        sdr sdram0 (SDRAM_DQ, SDRAM_ADDR, SDRAM_BA, SDRAM_CLK, SDRAM_CKE, 
                    SDRAM_CSn, SDRAM_RASn, SDRAM_CASn, SDRAM_WEn, SDRAM_DQM);
    `else
        initial
        begin
            SI_ClkIn = 0;
            forever
                # 50 SI_ClkIn = ~ SI_ClkIn;
        end
    `endif //MFP_USE_SDRAM_MEMORY

    //----------------------------------------------------------------

    initial
    begin
        EJ_TRST_N_probe <= 1'b1;
        EJ_TDI          <= 1'b0;
        EJ_TMS          <= 1'b0;
        EJ_TCK          <= 1'b0;
        EJ_DINT         <= 1'b0;
        IO_Switches     <= 18'b0;
        IO_Buttons      <= 5'b0;
        UART_RX         <= 1'b0;
    end

    initial
    begin
        SI_ColdReset <= 0;
        SI_Reset     <= 0;

        repeat (10)  @(posedge SI_ClkIn);

        SI_ColdReset <= 1;
        SI_Reset     <= 1;

        repeat (20)  @(posedge SI_ClkIn);

        SI_ColdReset <= 0;
        SI_Reset     <= 0;
    end

    //----------------------------------------------------------------

    initial
    begin
        $dumpvars;

        $timeformat
        (
            -9,    // 1 ns
            1,     // Number of digits after decimal point
            "ns",  // suffix
            10     // Max number of digits 
        );
    end

    //----------------------------------------------------------------

    reg [7:0] reset_ram [0 : (1 << `MFP_RESET_RAM_ADDR_WIDTH ) - 1];
    reg [7:0] ram       [0 : (1 << `MFP_RAM_ADDR_WIDTH       ) - 1];

    integer i;

    `ifdef MFP_USE_WORD_MEMORY

    initial
    begin
        $readmemh ("program_1fc00000.hex", reset_ram);
        $readmemh ("program_00000000.hex", ram);

        for (i = 0; i < (1 << `MFP_RESET_RAM_ADDR_WIDTH); i = i + 4)
            system.ahb_lite_matrix.ahb_lite_matrix.reset_ram.ram.ram [i / 4]
                = { reset_ram [i + 3], reset_ram [i + 2], reset_ram [i + 1], reset_ram [i + 0] };

        for (i = 0; i < (1 << `MFP_RAM_ADDR_WIDTH); i = i + 4)
            system.ahb_lite_matrix.ahb_lite_matrix.ram.ram.ram [i / 4]
                = { ram [i + 3], ram [i + 2], ram [i + 1], ram [i + 0] };
    end

    `else
    `ifdef MFP_USE_BYTE_MEMORY

    generate
        genvar j;
    
        for (j = 0; j <= 3; j = j + 1)
        begin : u
            initial
            begin
                $readmemh ("program_1fc00000.hex", reset_ram);
                $readmemh ("program_00000000.hex", ram);
                    
                for (i = 0; i < (1 << `MFP_RESET_RAM_ADDR_WIDTH); i = i + 4)
                    system.ahb_lite_matrix.ahb_lite_matrix.reset_ram.u [j].ram.ram [i / 4]
                        = reset_ram [i + j];
                
                for (i = 0; i < (1 << `MFP_RAM_ADDR_WIDTH); i = i + 4)
                    system.ahb_lite_matrix.ahb_lite_matrix.ram.u [j].ram.ram [i / 4]
                        = ram [i + j];
            end
        end
    endgenerate

    `else
    `ifdef MFP_USE_BUSY_MEMORY

    initial
    begin
        $readmemh ("program_1fc00000.hex", reset_ram);
        $readmemh ("program_00000000.hex", ram);

        for (i = 0; i < (1 << `MFP_RESET_RAM_ADDR_WIDTH); i = i + 4)
            system.ahb_lite_matrix.ahb_lite_matrix.reset_ram.ram.ram [i / 4]
                = { reset_ram [i + 3], reset_ram [i + 2], reset_ram [i + 1], reset_ram [i + 0] };

        for (i = 0; i < (1 << `MFP_RAM_ADDR_WIDTH); i = i + 4)
            system.ahb_lite_matrix.ahb_lite_matrix.ram.ram [i / 4]
                = { ram [i + 3], ram [i + 2], ram [i + 1], ram [i + 0] };
    end

    `else
    `ifdef MFP_USE_SDRAM_MEMORY

    reg  [`SDRAM_COL_BITS - 1 : 0]  AddrColumn ;
    reg  [`SDRAM_ROW_BITS - 1 : 0]  AddrRow    ;
    reg  [`SDRAM_BA_BITS  - 1 : 0]  AddrBank   ;

    initial
    begin
        $readmemh ("program_1fc00000.hex", reset_ram);
        $readmemh ("program_00000000.hex", ram);

        for (i = 0; i < (1 << `MFP_RESET_RAM_ADDR_WIDTH); i = i + 4)
            system.ahb_lite_matrix.ahb_lite_matrix.reset_ram.ram.ram [i / 4]
                = { reset_ram [i + 3], reset_ram [i + 2], reset_ram [i + 1], reset_ram [i + 0] };
        
        for (i = 0; i < (1 << `MFP_RAM_ADDR_WIDTH); i = i + 2) begin

            AddrColumn  = i [ `SDRAM_COL_BITS : 1 ];
            AddrRow     = i [ `SDRAM_ROW_BITS + `SDRAM_COL_BITS : `SDRAM_COL_BITS + 1];
            AddrBank    = i [ `SDRAM_BA_BITS  + `SDRAM_ROW_BITS + `SDRAM_COL_BITS : `SDRAM_ROW_BITS + `SDRAM_COL_BITS + 1];

            case (AddrBank)
                2'b00 : sdram0.Bank0 [{AddrRow, AddrColumn}] = { ram [i + 1], ram [i + 0] };
                2'b01 : sdram0.Bank1 [{AddrRow, AddrColumn}] = { ram [i + 1], ram [i + 0] };
                2'b10 : sdram0.Bank2 [{AddrRow, AddrColumn}] = { ram [i + 1], ram [i + 0] };
                2'b11 : sdram0.Bank3 [{AddrRow, AddrColumn}] = { ram [i + 1], ram [i + 0] };
            endcase
        end
    end

    `endif //MFP_USE_SDRAM_MEMORY
    `endif //MFP_USE_BUSY_MEMORY
    `endif //MFP_USE_BYTE_MEMORY
    `endif //MFP_USE_WORD_MEMORY

    //----------------------------------------------------------------

    /*
    always @ (negedge SI_ClkIn)
    begin
        if (HADDR == 32'h1fc00058)
        begin
            $display ("Data cache initialized. About to make kseg0 cacheable.");
            $stop;
	end
	else if (HADDR == 32'h00000644)
        begin
	    $display ("Beginning of program code.");
            $stop;
	end
    end
    */

    //----------------------------------------------------------------

    integer cycle; initial cycle = 0;

    always @ (posedge SI_ClkIn)
    begin
        $display ("%5d HCLK %b HADDR %h HRDATA %h HWDATA %h HWRITE %b LEDR %b LEDG %b 7SEG %h",
            cycle, system.HCLK, HADDR, HRDATA, HWDATA, HWRITE, IO_RedLEDs, IO_GreenLEDs, IO_7_SegmentHEX);

        `ifdef MFP_DEMO_PIPE_BYPASS

        if ( system.mpc_aselwr_e  ) $display ( "%5d PIPE_BYPASS mpc_aselwr_e"  , cycle );
        if ( system.mpc_bselall_e ) $display ( "%5d PIPE_BYPASS mpc_bselall_e" , cycle );
        if ( system.mpc_aselres_e ) $display ( "%5d PIPE_BYPASS mpc_aselres_e" , cycle );
        if ( system.mpc_bselres_e ) $display ( "%5d PIPE_BYPASS mpc_bselres_e" , cycle );

        `endif

        cycle = cycle + 1;

        if (cycle > 15000)
        begin
            $display ("Timeout");
            $finish;
        end
    end

endmodule
