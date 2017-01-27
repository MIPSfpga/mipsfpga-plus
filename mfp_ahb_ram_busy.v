/* Simple SDRAM controller for MIPSfpga+ system AHB-Lite bus
 * Copyright(c) 2016 Stanislav Zhelnio
 * https://github.com/zhelnio/ahb_lite_sdram
 */

// simply ram with HREADY support
module mfp_ahb_ram_busy
#(
    parameter ADDR_WIDTH = 6
)
(
    //ABB-Lite side
    input                       HCLK,    
    input                       HRESETn,
    input       [31:0]          HADDR,
    input       [ 2:0]          HBURST,
    input                       HMASTLOCK,  // ignored
    input       [ 3:0]          HPROT,      // ignored
    input                       HSEL,
    input       [ 2:0]          HSIZE,
    input       [ 1:0]          HTRANS,
    input       [31:0]          HWDATA,
    input                       HWRITE,
    output  reg [31:0]          HRDATA,
    output                      HREADY,
    output                      HRESP,
    input                       SI_Endian   // ignored
);
    assign HRESP  = 1'b0;

    parameter   S_INIT          = 0,
                S_IDLE          = 1,
                S_READ          = 2,
                S_WRITE         = 3;

    parameter   HTRANS_IDLE     = 2'b0;

    reg     [  4 : 0 ]      State, Next;
    reg     [ 31 : 0 ]      HADDR_old;
    reg                     HWRITE_old;
    reg     [  1 : 0 ]      HTRANS_old;

    assign  HREADY = (State == S_IDLE);
    wire    NeedAction = HTRANS != HTRANS_IDLE && HSEL;

    always @ (posedge HCLK) begin
        if (~HRESETn)
            State <= S_INIT;
        else
            State <= Next;
    end

    always @ (*) begin
        Next = State;
        case(State)
            S_INIT:         Next = S_IDLE;
            S_IDLE:         Next = ~NeedAction ? S_IDLE : (HWRITE ? S_WRITE : S_READ);
            S_READ:         Next = S_IDLE;
            S_WRITE:        Next = S_IDLE;
        endcase
    end

    parameter MEM_SIZE = ( 2 ** ADDR_WIDTH ) / 4;

    `ifdef MFP_USE_WORD_MEMORY
        reg [31:0] ram [ MEM_SIZE - 1 : 0 ];
    `else
        reg [7:0] ram0 [ MEM_SIZE - 1 : 0 ];
        reg [7:0] ram1 [ MEM_SIZE - 1 : 0 ];
        reg [7:0] ram2 [ MEM_SIZE - 1 : 0 ];
        reg [7:0] ram3 [ MEM_SIZE - 1 : 0 ];
    `endif

    always @ (posedge HCLK) begin
        if(State == S_INIT) begin
            HADDR_old   <= 32'b0;
            HWRITE_old  <= 1'b0;
            HTRANS_old  <= HTRANS_IDLE;
        end

        if(State == S_IDLE && HSEL) begin
            HADDR_old   <= HADDR;
            HWRITE_old  <= HWRITE;
            HTRANS_old  <= HTRANS;
        end

        `ifdef MFP_USE_WORD_MEMORY
            if(State == S_READ)
                HRDATA <= ram[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ];
                
            if(State == S_WRITE)
                ram[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ] <= HWDATA;
        `else
            if(State == S_READ)
                HRDATA <= { ram3[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ],
                            ram2[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ],
                            ram1[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ],
                            ram0[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ] };
                
            if(State == S_WRITE)
                { ram3[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ],
                  ram2[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ],
                  ram1[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ],
                  ram0[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ] } <= HWDATA;
        `endif

    end

endmodule
