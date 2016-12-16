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
               
    input      [`MFP_N_SWITCHES          - 1:0] IO_Switches,
    input      [`MFP_N_BUTTONS           - 1:0] IO_Buttons,
    output reg [`MFP_N_RED_LEDS          - 1:0] IO_RedLEDs,
    output reg [`MFP_N_GREEN_LEDS        - 1:0] IO_GreenLEDs,
    output reg [`MFP_7_SEGMENT_HEX_WIDTH - 1:0] IO_7_SegmentHEX

    `ifdef MFP_DEMO_LIGHT_SENSOR
    ,
    input      [15:0] IO_LightSensor
    `endif
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
            IO_RedLEDs      <= `MFP_N_RED_LEDS'b0;
            IO_GreenLEDs    <= `MFP_N_GREEN_LEDS'b0;
            IO_7_SegmentHEX <= `MFP_7_SEGMENT_HEX_WIDTH'b0;
        end
        else if (write_enable)
        begin
            case (write_ionum)
            `MFP_RED_LEDS_IONUM      : IO_RedLEDs      <= HWDATA [`MFP_N_RED_LEDS          - 1:0];
            `MFP_GREEN_LEDS_IONUM    : IO_GreenLEDs    <= HWDATA [`MFP_N_GREEN_LEDS        - 1:0];
            `MFP_7_SEGMENT_HEX_IONUM : IO_7_SegmentHEX <= HWDATA [`MFP_7_SEGMENT_HEX_WIDTH - 1:0];
            endcase
        end
    end

    always @ (posedge HCLK or negedge HRESETn)
    begin
        if (! HRESETn)
        begin
            HRDATA <= 32'h00000000;
        end
        else
        begin
            case (read_ionum)
            `MFP_SWITCHES_IONUM      : HRDATA <= { { 32 - `MFP_N_SWITCHES { 1'b0 } } , IO_Switches };
            `MFP_BUTTONS_IONUM       : HRDATA <= { { 32 - `MFP_N_BUTTONS  { 1'b0 } } , IO_Buttons  };
            
            `ifdef MFP_DEMO_LIGHT_SENSOR
            `MFP_LIGHT_SENSOR_IONUM  : HRDATA <= { 16'b0, IO_LightSensor };
            `endif
            
            default:                   HRDATA <= 32'h00000000;
            endcase
        end
    end

endmodule
