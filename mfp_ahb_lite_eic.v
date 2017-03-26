/* Simple external interrupt controller for MIPSfpga+ system 
 * managed using AHB-Lite bus
 * Copyright(c) 2017 Stanislav Zhelnio
 */  

`include "mfp_eic_core.vh"

module mfp_ahb_lite_eic
(
    //ABB-Lite side
    input                              HCLK,
    input                              HRESETn,
    input      [ 31 : 0 ]              HADDR,
    input      [  2 : 0 ]              HBURST,     // ignored
    input                              HMASTLOCK,  // ignored
    input      [  3 : 0 ]              HPROT,      // ignored
    input                              HSEL,
    input      [  2 : 0 ]              HSIZE,      // ignored
    input      [  1 : 0 ]              HTRANS,
    input      [ 31 : 0 ]              HWDATA,
    input                              HWRITE,
    output reg [ 31 : 0 ]              HRDATA,
    output reg                         HREADY,
    output                             HRESP,
    input                              SI_Endian,  // ignored

    //Interrupt signal side
    input      [ `EIC_CHANNELS-1 : 0 ] EIC_input,

    //CPU side
    output     [ 17 : 1 ]              EIC_Offset,    // connect to SI_Offset
    output     [  3 : 0 ]              EIC_ShadowSet, // connect to SI_EISS
    output     [  7 : 0 ]              EIC_Interrupt, // connect to SI_Int
    output     [  5 : 0 ]              EIC_Vector,    // connect to SI_EICVector
    output                             EIC_Present,   // connect to SI_EICPresent
    input                              EIC_IAck,      // connect to SI_IAck
    input      [  7 : 0 ]              EIC_IPL,       // connect to SI_IPL
    input      [  5 : 0 ]              EIC_IVN,       // connect to SI_IVN
    input      [ 17 : 1 ]              EIC_ION        // connect to SI_ION
);
    assign      HRESP  = 1'b0;

    wire [ `EIC_ADDR_WIDTH - 1 : 0 ] read_addr;
    wire [                  31 : 0 ] read_data;
    reg  [ `EIC_ADDR_WIDTH - 1 : 0 ] write_addr;
    wire [                  31 : 0 ] write_data;
    reg                              write_enable;
    
    wire [ `EIC_ADDR_WIDTH - 1 : 0 ] ADDR = HADDR [ `EIC_ADDR_WIDTH + 2 : 2 ];
    reg  [ `EIC_ADDR_WIDTH - 1 : 0 ] ADDR_old;
    reg                              HWRITE_old;
    reg  [                  31 : 0 ] HADDR_old;

    wire        read_after_write = ADDR == ADDR_old && HWRITE_old && !HWRITE 
                                   && HTRANS != `HTRANS_IDLE && HADDR_old != `HTRANS_IDLE && HSEL;

    parameter   HTRANS_IDLE = 2'b0;
    wire        NeedRead    = HTRANS != HTRANS_IDLE && HSEL;
    wire        NeedWrite   = NeedRead & HWRITE;

    assign      write_data  = HWDATA;
    assign      read_addr   = ADDR;

    always @ (posedge HCLK) begin
        if(~HRESETn)
            write_enable <= 1'b0;
        else begin
            if(NeedRead)
                HRDATA <= read_data;

            if(NeedWrite)
                write_addr <= ADDR;
            write_enable <= NeedWrite;
        end

        ADDR_old <= ADDR;
        HREADY   <= !read_after_write;
    end

    mfp_eic_core eic_core
    (
        .CLK            ( HCLK          ),
        .RESETn         ( HRESETn       ),
        .signal         ( EIC_input     ),
        .read_addr      ( read_addr     ),
        .read_data      ( read_data     ),
        .write_addr     ( write_addr    ),
        .write_data     ( write_data    ),
        .write_enable   ( write_enable  ),
        .EIC_Offset     ( EIC_Offset    ),
        .EIC_ShadowSet  ( EIC_ShadowSet ),
        .EIC_Interrupt  ( EIC_Interrupt ),
        .EIC_Vector     ( EIC_Vector    ),
        .EIC_Present    ( EIC_Present   ),
        .EIC_IAck       ( EIC_IAck      ),
        .EIC_IPL        ( EIC_IPL       ),
        .EIC_IVN        ( EIC_IVN       ),
        .EIC_ION        ( EIC_ION       )
    );

endmodule
