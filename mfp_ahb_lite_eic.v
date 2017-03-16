/* Simple external interrupt controller for MIPSfpga+ system 
 * managed using AHB-Lite bus
 * Copyright(c) 2017 Stanislav Zhelnio
 * https://github.com/zhelnio/ahb_lite_eic
 */  

`include "mfp_eic_core.vh"

module mfp_ahb_lite_eic
(
    //ABB-Lite side
    input                              HCLK,
    input                              HRESETn,
    input      [ 31 : 0 ]              HADDR,
    input      [  2 : 0 ]              HBURST,
    input                              HMASTLOCK,  // ignored
    input      [  3 : 0 ]              HPROT,      // ignored
    input                              HSEL,
    input      [  2 : 0 ]              HSIZE,
    input      [  1 : 0 ]              HTRANS,
    input      [ 31 : 0 ]              HWDATA,
    input                              HWRITE,
    output reg [ 31 : 0 ]              HRDATA,
    output                             HREADY,
    output                             HRESP,
    input                              SI_Endian,  // ignored

    //Interrupt side
    input      [ `EIC_CHANNELS-1 : 0 ] signal,

    //CPU side
    output     [ 17 : 1 ]              EIC_Offset,
    output     [  3 : 0 ]              EIC_ShadowSet,
    output     [  7 : 0 ]              EIC_Interrupt,
    output     [  5 : 0 ]              EIC_Vector,
    output                             EIC_Present
);
    assign      HRESP  = 1'b0;
    assign      HREADY = 1'b1;

    wire [ `EIC_ADDR_WIDTH - 1 : 0 ] read_addr;
    wire [                  31 : 0 ] read_data;
    reg  [ `EIC_ADDR_WIDTH - 1 : 0 ] write_addr;
    wire [                  31 : 0 ] write_data;
    reg                              write_enable;

    wire [ `EIC_ADDR_WIDTH - 1 : 0 ] ADDR = HADDR [ `EIC_ADDR_WIDTH + 2 : 2 ];

    parameter   HTRANS_IDLE = 2'b0;
    wire        NeedRead    = HTRANS != HTRANS_IDLE && HSEL;
    wire        NeedWrite   = NeedRead & HWRITE;

    assign      write_data  = HWDATA;
    assign      read_addr   = ADDR;

    always @ (posedge HCLK)
        if(~HRESETn)
            write_enable <= 1'b0;
        else begin
            if(NeedRead)
                HRDATA <= read_data;

            if(NeedWrite)
                write_addr <= ADDR;
            write_enable <= NeedWrite;
        end

    mfp_eic_core eic_core
    (
        .CLK            ( HCLK          ),
        .RESETn         ( HRESETn       ),
        .signal         ( signal        ),
        .read_addr      ( read_addr     ),
        .read_data      ( read_data     ),
        .write_addr     ( write_addr    ),
        .write_data     ( write_data    ),
        .write_enable   ( write_enable  ),
        .EIC_Offset     ( EIC_Offset    ),
        .EIC_ShadowSet  ( EIC_ShadowSet ),
        .EIC_Interrupt  ( EIC_Interrupt ),
        .EIC_Vector     ( EIC_Vector    ),
        .EIC_Present    ( EIC_Present   )
    );

endmodule
