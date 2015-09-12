module mfp_ahb_mem_slave
# (
    parameter ADDR_WIDTH = 6
)
(
    input         HCLK,
    input         HRESETn,
    input  [ 1:0] HTRANS,
    input  [31:0] HADDR,
    input  [ 2:0] HBURST,
    input  [ 2:0] HSIZE,
    input         HWRITE,
    input  [31:0] HWDATA,
    input         HSEL,

    output        HREADY,
    output        HRESP,
    output [31:0] HRDATA 
);

    reg [31:0] HADDR_delayed;
    reg        HWRITE_delayed;
    reg        HSEL_delayed;

    always @ (posedge HCLK)
    begin
        HADDR_delayed  <= HADDR;
        HWRITE_delayed <= HWRITE;
        HSEL_delayed   <= HSEL;
    end

    reg [3:0] mask;

    always @*
    begin
        if (! (HSEL_delayed && HWRITE_delayed))
            mask = 4'b0000;
        else if (HBURST == 0 && HSIZE == 0)  // single 1 byte
            mask = 4'b0001 << HADDR [1:0];
        else if (HBURST == 0 && HSIZE == 1)  // single 2 bytes
            mask = HADDR [1] ? 4'b1100 : 4'b0011;
        else
            mask = 4'b1111;
    end

    generate
        genvar i;

        for (i = 0; i <= 3; i = i + 1)
        begin : u
           mfp_dual_port_mem
           # (
               .ADDR_WIDTH ( ADDR_WIDTH - 2 ),
               .DATA_WIDTH ( 8              )
           )
           mem
           (
               .clk          ( HCLK                                ),
               .read_addr    ( HADDR         [ ADDR_WIDTH - 1 : 2] ),
               .write_addr   ( HADDR_delayed [ ADDR_WIDTH - 1 : 2] ),
               .write_data   ( HWDATA        [ i * 8 +: 8 ]        ),
               .write_enable ( mask          [ i ]                 ),
               .read_data    ( HRDATA        [ i * 8 +: 8 ]        )
           );
        end
    endgenerate

endmodule
