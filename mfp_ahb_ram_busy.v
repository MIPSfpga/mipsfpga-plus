/* Simple SDRAM controller for MIPSfpga+ system AHB-Lite bus
 * Copyright(c) 2017 Stanislav Zhelnio
 */

// simply ram with HREADY support
module mfp_ahb_ram_busy
#(
    parameter ADDR_WIDTH = 6,
    parameter DELAY_VAL  = 2
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
                S_WRITE         = 3,
                S_WAIT          = 4;

    parameter   HTRANS_IDLE     = 2'b0;

    reg     [  4 : 0 ]      State, Next;
    reg     [ 31 : 0 ]      HADDR_old;
    reg                     HWRITE_old;
    reg     [  1 : 0 ]      HTRANS_old;
    reg     [  3 : 0 ]      Delay;

    assign  HREADY = (State == S_IDLE);
    wire    NeedAction = HTRANS != HTRANS_IDLE && HSEL;
    wire    DelayFinished = ( ~| Delay );

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
            S_READ:         Next = S_WAIT;
            S_WRITE:        Next = S_WAIT;
            S_WAIT:         Next = DelayFinished ? S_IDLE : S_WAIT;
        endcase
    end

    reg [31:0] ram [ (1 << ADDR_WIDTH) - 1 : 0 ];

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

        if(State == S_READ)
            HRDATA <= ram[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ];
            
        if(State == S_WRITE)
            ram[HADDR_old [ ADDR_WIDTH - 1 + 2 : 2] ] <= HWDATA;

        if(State == S_READ || State == S_WRITE)
            Delay <= DELAY_VAL;
        if(~DelayFinished)
            Delay <= Delay - 1;
    end

endmodule

/*
module mfp_ahb_ram_busy_new
#(
    parameter ADDR_WIDTH = 6,
    parameter DELAY_VAL  = 2
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
    output      [31:0]          HRDATA,
    output  reg                 HREADY,
    output                      HRESP,
    input                       SI_Endian   // ignored
);

    wire [ ADDR_WIDTH - 1 : 0 ] read_addr;
    wire                        read_enable;
    wire [ ADDR_WIDTH - 1 : 0 ] write_addr;
    wire [              3 : 0 ] write_mask;
    wire                        write_enable;
    wire                        read_after_write;

    assign HRESP  = 1'b0;

    reg     [  3 : 0 ]  Delay;
    wire                DelayFinished = ( ~| Delay );
    wire    [  3 : 0 ]  Delay_new = (read_enable | write_enable) ? DELAY_VAL : (
                                     ~DelayFinished ? (Delay - 1) : 0 );

    always @ (posedge HCLK) 
        if (~HRESETn)
            Delay <= 4'b0;
        else begin
            HREADY <= !read_after_write & DelayFinished;
            Delay  <= Delay_new;
        end

    mfp_ahb_lite_decoder 
    #(
        .ADDR_WIDTH ( ADDR_WIDTH ),
        .ADDR_START (          2 )
    )
    decoder
    (
        .HCLK               ( HCLK              ),
        .HRESETn            ( HRESETn           ),
        .HADDR              ( HADDR [ ADDR_WIDTH - 1 + 2 : 2] ),
        .HSIZE              ( HSIZE             ),
        .HTRANS             ( HTRANS            ),
        .HWRITE             ( HWRITE            ),
        .HSEL               ( HSEL              ),
        .read_enable        ( read_enable       ),
        .read_addr          ( read_addr         ),
        .write_enable       ( write_enable      ),
        .write_addr         ( write_addr        ),
        .write_mask         ( write_mask        ),
        .read_after_write   ( read_after_write  )
    );

    mfp_dual_port_ram
        #(
            .ADDR_WIDTH ( ADDR_WIDTH ),
            .DATA_WIDTH ( 32         )
        )
        ram
        (
            .clk          ( HCLK            ),
            .read_addr    ( read_addr       ),
            .write_addr   ( write_addr      ),
            .write_data   ( HWDATA          ),
            .write_enable ( write_enable    ),
            .read_data    ( HRDATA          )
        );

endmodule
*/