//
//  General-purpose I/O module for Altera's DE2-115 and 
//  Digilent's (Xilinx) Nexys4-DDR board
//
//  Altera's DE2-115 board:
//  Outputs:
//  18 red LEDs (IO_LEDR), 9 green LEDs (IO_LEDG) 
//  Inputs:
//  18 slide switches (IO_Switch), 4 pushbutton switches (IO_PB[3:0])
//
//  Digilent's (Xilinx) Nexys4-DDR board:
//  Outputs:
//  15 LEDs (IO_LEDR[14:0]) 
//  Inputs:
//  15 slide switches (IO_Switch[14:0]), 
//  5 pushbutton switches (IO_PB)
//

`include "mfp_ahb_lite.vh"
`include "mfp_ahb_lite_matrix_config.vh"

module mfp_ahb_gpio_slave
(
    input             HCLK,
    input             HRESETn,
    input      [31:0] HADDR,
    input      [ 2:0] HBURST,
    input             HMASTLOCK,
    input      [ 3:0] HPROT,
    input      [ 2:0] HSIZE,
    input             HSEL,
    input      [ 1:0] HTRANS,
    input      [31:0] HWDATA,
    input             HWRITE,
    output reg [31:0] HRDATA,
    output            HREADY,
    output            HRESP,
    input             SI_Endian,
               
    input      [17:0] IO_Switches,
    input      [ 4:0] IO_Buttons,
    output reg [17:0] IO_RedLEDs,
    output reg [ 8:0] IO_GreenLEDs
);

    // Ignored: HMASTLOCK, HPROT
    // TODO: SI_Endian

    assign HREADY = 1'b1;
    assign HRESP  = 1'b0;

    reg [ 1:0] HTRANS_dly;
    reg [31:0] HADDR_dly;
    reg        HWRITE_dly;
    reg        HSEL_dly;

    always @ (posedge HCLK)
    begin
        HTRANS_dly <= HTRANS;
        HADDR_dly  <= HADDR;
        HWRITE_dly <= HWRITE;
        HSEL_dly   <= HSEL;
    end

    wire [3:0] read_ionum   = HADDR     [5:2];
    wire [3:0] write_ionum  = HADDR_dly [5:2];
    wire       write_enable = HTRANS_dly != `HTRANS_IDLE && HSEL_dly && HWRITE_dly;

    always @ (posedge HCLK or negedge HRESETn)
    begin
        if (! HRESETn)
        begin
            IO_RedLEDs    <= 18'b0;
            IO_GreenLEDs  <= 9'b0;
        end
        else if (write_enable)
        begin
            case (write_ionum)
            `MFP_RED_LEDS_IONUM   : IO_RedLEDs   <= HWDATA [17:0];
            `MFP_GREEN_LEDS_IONUM : IO_GreenLEDs <= HWDATA [ 8:0];
            endcase
        end
    end

    always @*
    begin
        case (read_ionum)
        `MFP_SWITCHES_IONUM : HRDATA = { 14'b0, IO_Switches };
        `MFP_BUTTONS_IONUM  : HRDATA = { 27'b0, IO_Buttons  };
        default:              HRDATA = 32'h00000000;
        endcase
    end

endmodule
