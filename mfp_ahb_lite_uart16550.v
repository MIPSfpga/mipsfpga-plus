/* UART16550 controller for MIPSfpga+ system AHB-Lite bus
 * Copyright(c) 2017 Stanislav Zhelnio
 * https://github.com/zhelnio/ahb_lite_uart16550
 * 
 * based on https://github.com/freecores/uart16550 
 *          https://github.com/olofk/uart16550
 */

`include "uart_defines.v"

module mfp_ahb_lite_uart16550(
    //ABB-Lite side
    input                               HCLK,
    input                               HRESETn,
    input       [ 31 : 0 ]              HADDR,
    input       [  2 : 0 ]              HBURST,
    input                               HMASTLOCK,  // ignored
    input       [  3 : 0 ]              HPROT,      // ignored
    input                               HSEL,
    input       [  2 : 0 ]              HSIZE,
    input       [  1 : 0 ]              HTRANS,
    input       [ 31 : 0 ]              HWDATA,
    input                               HWRITE,
    output  reg [ 31 : 0 ]              HRDATA,
    output                              HREADY,
    output                              HRESP,
    input                               SI_Endian,  // ignored

    //UART side
    input                               UART_SRX,   // UART serial input signal
    output                              UART_STX,   // UART serial output signal
    output                              UART_RTS,   // UART MODEM Request To Send
    input                               UART_CTS,   // UART MODEM Clear To Send
    output                              UART_DTR,   // UART MODEM Data Terminal Ready
    input                               UART_DSR,   // UART MODEM Data Set Ready
    input                               UART_RI,    // UART MODEM Ring Indicator
    input                               UART_DCD,   // UART MODEM Data Carrier Detect

    //UART internal
    output                              UART_BAUD,  // UART baudrate output
    output                              UART_INT    // UART interrupt
);

    parameter   S_INIT      = 0,
                S_HR_READY  = 1,
                S_WR_WAIT   = 2;
    
    reg  [ 1:0 ]    State, Next;

    assign      HRESP  = 1'b0;
    assign      HREADY = (State == S_HR_READY);

    reg  [ 2:0 ]    ADDR_old;
    wire [ 2:0 ]    ADDR = HADDR [ 4:2 ];
    wire [ 7:0 ]    ReadData;

    parameter       HTRANS_IDLE       = 2'b0;
    wire            NeedAction = HTRANS != HTRANS_IDLE && HSEL;

    always @ (posedge HCLK) begin
        if (~HRESETn)
            State <= S_INIT;
        else
            State <= Next;
    end

    //State change decision
    always @ (*) begin
        case(State)
            S_INIT      :   Next = S_HR_READY;
            S_HR_READY  :   Next = (NeedAction && HWRITE) ? S_WR_WAIT : S_HR_READY;
            S_WR_WAIT   :   Next = S_HR_READY;
        endcase
    end

    always @ (posedge HCLK) begin
        if(State == S_HR_READY) begin
            ADDR_old <= ADDR; 
            if(NeedAction) HRDATA <= ReadData; 
        end
    end

    wire [ 2:0 ]    ActionAddr  = (State == S_WR_WAIT) ? ADDR_old : ADDR;
    wire [ 7:0 ]    WriteData   = HWDATA [ 7:0 ];
    wire            WriteAction = (State == S_WR_WAIT)  && HSEL;
    wire            ReadAction  = (State == S_HR_READY) && NeedAction;

    // Registers
    uart_regs   regs(
        .clk            (   HCLK            ),
        .wb_rst_i       (   ~HRESETn        ),
        .wb_addr_i      (   ActionAddr      ),
        .wb_dat_i       (   WriteData       ),
        .wb_dat_o       (   ReadData        ),
        .wb_we_i        (   WriteAction     ),
        .wb_re_i        (   ReadAction      ),
        .modem_inputs   (   { UART_CTS, UART_DSR, UART_RI, UART_DCD }   ),
        .stx_pad_o      (   UART_STX        ),
        .srx_pad_i      (   UART_SRX        ),
        .rts_pad_o      (   UART_RTS        ),
        .dtr_pad_o      (   UART_DTR        ),
        .int_o          (   UART_INT        ),
        .baud_o         (   UART_BAUD       )
    );

endmodule
