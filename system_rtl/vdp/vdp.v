`include "mfp_ahb_lite_matrix_config.vh"
`include "mfp_ahb_lite.vh"

module vdp
(
    input         HCLK,
    input         HRESETn,
    input  [31:0] HADDR,
    input  [ 2:0] HBURST,
    input         HMASTLOCK,
    input  [ 3:0] HPROT,
    input         HSEL,
    input  [ 2:0] HSIZE,
    input  [ 1:0] HTRANS,
    input  [31:0] HWDATA,
    input         HWRITE,
    input         HREADY,
    output [31:0] HRDATA,
    output        HREADYOUT,
    output        HRESP,
    input         SI_Endian,

    output        vga_hsync,
    output        vga_vsync,
    output [ 2:0] vga_rgb
);
    wire clk   =   HCLK;
    wire reset = ! HRESETn;

    assign HRDATA    = '0;
    assign HREADYOUT = 1'b1;
    assign HRESP     = 1'b0;

    wire                    display_on;
    wire [HPOS_WIDTH - 1:0] hpos;
    wire [VPOS_WIDTH - 1:0] vpos;

    localparam N_VDP_PIPE  = 0,
               HPOS_WIDTH  = 10,
               VPOS_WIDTH  = 10;

    vdp_hv_sync_generator
    # (
        .N_VDP_PIPE  ( N_VDP_PIPE ),
        .HPOS_WIDTH  ( HPOS_WIDTH ),
        .VPOS_WIDTH  ( VPOS_WIDTH )
    )
    i_vdp_hv_sync_generator (.*);

    wire write =    ( HTRANS == `HTRANS_NONSEQ || HTRANS == `HTRANS_NONSEQ )
                 && ( HBURST == `HBURST_WRAP4  || HSIZE  == `HSIZE_4       )
                 && HSEL && HREADY && HWRITE;

    reg write_reg;

    always @ (posedge clk or posedge reset)
        if (reset)
            write_reg <= 1'b0;
        else
            write_reg <= write;

    reg [31:0] data;

    always @ (posedge clk or posedge reset)
        if (reset)
            data <= '0;
        else if (write_reg)
            data <= HWDATA;

    assign vga_rgb = data [2:0];

endmodule
