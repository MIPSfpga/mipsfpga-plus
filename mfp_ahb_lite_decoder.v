
`include "mfp_ahb_lite.vh"

module mfp_ahb_lite_decoder
#(
    parameter   ADDR_WIDTH = 32,
                ADDR_START = 0,
                ADDR_END   = (ADDR_START + ADDR_WIDTH - 1)
)
(
    input                                HCLK,
    input                                HRESETn,
    input      [ ADDR_END : ADDR_START ] HADDR,
    input      [                 2 : 0 ] HSIZE,
    input      [                 1 : 0 ] HTRANS,
    input                                HWRITE,
    input                                HSEL,

    output                               read_enable,
    output     [ ADDR_END : ADDR_START ] read_addr,
    output reg                           write_enable,
    output reg [ ADDR_END : ADDR_START ] write_addr,
    output reg [                 3 : 0 ] write_mask,
    output                               read_after_write
);
    wire   enable       = HTRANS != `HTRANS_IDLE && HSEL;

    assign read_enable  = enable & !HWRITE;
    assign read_addr    = HADDR [ ADDR_END : ADDR_START ];

    assign read_after_write = read_enable & write_enable 
                            & (read_addr == write_addr);

    wire [3:0] mask = ( HSIZE == `HSIZE_1 ) ? 4'b0001 << HADDR [1:0] : (
                      ( HSIZE == `HSIZE_2 ) ? (HADDR [1] ? 4'b1100 : 4'b0011) : (
                      ( HSIZE == `HSIZE_4 ) ? 4'b1111 : 4'b0000 ));

    always @ (posedge HCLK) begin
        if(~HRESETn) begin
            write_enable    <= 1'b0;
            write_addr      <= { ADDR_WIDTH - 1 { 1'b0 }};
            write_mask      <= 4'b0;
            end
        else begin
            write_enable    <= enable & HWRITE;
            write_addr      <= HADDR [ ADDR_END : ADDR_START ];
            write_mask      <= mask;
        end
    end

endmodule
