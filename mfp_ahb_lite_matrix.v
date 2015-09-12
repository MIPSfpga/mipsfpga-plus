`include "mfp_ahb_lite.vh"

module mfp_ahb_lite_matrix
(
    input               HCLK,
    input               HRESETn,
    input      [ 31: 0] HADDR,
    input      [  2: 0] HBURST,
    input               HMASTLOCK,
    input      [  3: 0] HPROT,
    input      [  2: 0] HSIZE,
    input      [  1: 0] HTRANS,
    input      [ 31: 0] HWDATA,
    input               HWRITE,
    output     [ 31: 0] HRDATA,
    output              HREADY,
    output              HRESP,
    input               SI_Endian,

    input      [ 17: 0] IO_Switches,
    input      [  4: 0] IO_Buttons,
    output     [ 17: 0] IO_RedLEDs,
    output     [  8: 0] IO_GreenLEDs
);

    wire [ 2:0] HSEL;
    reg  [ 2:0] HSEL_dly;

    mfp_ahb_lite_mem_slave
    # (
        .ADDR_WIDTH (`MFP_RAM_RESET_ADDR_WIDTH)
    )
    reset_ram
    (
        .HCLK       ( HCLK       ),
        .HRESETn    ( HRESETn    ),
        .HADDR      ( HADDR      ),
        .HBURST     ( HBURST     ),
        .HMASTLOCK  ( HMASTLOCK  ),
        .HPROT      ( HPROT      ),
        .HSEL       ( HSEL [0]   ),
        .HSIZE      ( HSIZE      ),
        .HTRANS     ( HTRANS     ),
        .HWDATA     ( HWDATA     ),
        .HWRITE     ( HWRITE     ),
        .HRDATA     ( HRDATA_0   ),
        .HREADY     ( HREADY_0   ),
        .HRESP      ( HRESP_0    ),
        .SI_Endian  ( SI_Endian  ),
    );

    mfp_ahb_lite_mem_slave
    # (
        .ADDR_WIDTH (`MFP_RAM_ADDR_WIDTH)
    )
    ram
    (
        .HCLK       ( HCLK       ),
        .HRESETn    ( HRESETn    ),
        .HADDR      ( HADDR      ),
        .HBURST     ( HBURST     ),
        .HMASTLOCK  ( HMASTLOCK  ),
        .HPROT      ( HPROT      ),
        .HSEL       ( HSEL [1]   ),
        .HSIZE      ( HSIZE      ),
        .HTRANS     ( HTRANS     ),
        .HWDATA     ( HWDATA     ),
        .HWRITE     ( HWRITE     ),
        .HRDATA     ( HRDATA_1   ),
        .HREADY     ( HREADY_1   ),
        .HRESP      ( HRESP_1    ),
        .SI_Endian  ( SI_Endian  ),
    );

    input               HCLK,
    input               HRESETn,
    input      [  3: 0] HADDR,
    input      [ 31: 0] HWDATA,
    input               HWRITE,
    input               HSEL,
    output reg [ 31: 0] HRDATA,


    mfp_ahb_lite_gpio_slave gpio
    (
        .HCLK       ( HCLK       ),
        .HRESETn    ( HRESETn    ),
        .HADDR      ( HADDR      ),
        .HBURST     ( HBURST     ),
        .HMASTLOCK  ( HMASTLOCK  ),
        .HPROT      ( HPROT      ),
        .HSEL       ( HSEL [2]   ),
        .HSIZE      ( HSIZE      ),
        .HTRANS     ( HTRANS     ),
        .HWDATA     ( HWDATA     ),
        .HWRITE     ( HWRITE     ),
        .HRDATA     ( HRDATA_2   ),
        .HREADY     ( HREADY_2   ),
        .HRESP      ( HRESP_2    ),
        .SI_Endian  ( SI_Endian  ),
    );




 (HCLK, HRESETn, HADDR, HWDATA, HWRITE_d, HSEL[0], HRDATA0);
  // Module 1
  mipsfpga_ahb_ram mipsfpga_ahb_ram(HCLK, HRESETn, HADDR, HWDATA, HWRITE_d, HSEL[1], HRDATA1);
  // Module 2
  mipsfpga_ahb_gpio mipsfpga_ahb_gpio(HCLK, HRESETn, HADDR_d[5:2], HWDATA, HWRITE_d, HSEL[2], HRDATA2, IO_Switch, IO_PB, IO_LEDR, IO_LEDG);
  

  ahb_decoder ahb_decoder(HADDR_d, HSEL);

    wire        HREADY_0 , HREADY_1 , HREADY_2 ;
    wire [31:0] HRDATA_0 , HRDATA_1 , HRDATA_2 ;
    wire        HRESP_0  , HRESP_1  , HRESP_2  ;

    assign HREADY = HREADY_0 | HREADY_1 | HREADY_2;

    always @ (posedge HCLK)
        HSEL_dly <= HSEL;

    mfp_ahb_lite_mux mfp_ahb_lite_mux
    (
        .HSEL     ( HSEL_dly ),

        .HRDATA_0 ( HRDATA_0 ),
        .HRDATA_1 ( HRDATA_1 ),
        .HRDATA_2 ( HRDATA_2 ),

        .HRRESP_0 ( HRRESP_0 ),
        .HRRESP_1 ( HRRESP_1 ),
        .HRRESP_2 ( HRRESP_2 ),

        .HRDATA   ( HRDATA   ),
        .HRRESP   ( HRRESP   )
    );

endmodule


module ahb_decoder
(
    input  [31:0] HADDR,
    output [ 2:0] HSEL
);

  // Decode based on most significant bits of the address
  assign HSEL[0] = (HADDR[28:22] == `H_RAM_RESET_ADDR_Match); // 128 KB RAM  at 0xbfc00000 (physical: 0x1fc00000)
  assign HSEL[1] = (HADDR[28]    == `H_RAM_ADDR_Match);         // 256 KB RAM at 0x80000000 (physical: 0x00000000)
  assign HSEL[2] = (HADDR[28:22] == `H_LEDR_ADDR_Match);      // GPIO at 0xbf800000 (physical: 0x1f800000)
endmodule


module ahb_mux
(
    input      [ 2:0] HSEL,
    input      [31:0] HRDATA2, HRDATA1, HRDATA0,
    output reg [31:0] HRDATA
);

    always @(*)
      casez (HSEL)
	      3'b??1:    HRDATA = HRDATA0;
	      3'b?10:    HRDATA = HRDATA1;
	      3'b100:    HRDATA = HRDATA2;
	      default:   HRDATA = HRDATA1;
      endcase
endmodule
