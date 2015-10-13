module mfp_pmod_als_spi_receiver
(
    input             clock,
    input             reset_n,
    output            cs,
    output            sck,
    input             sdo,
    output reg [15:0] value
);

    reg [21:0] cnt;
    reg [15:0] shift;

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            cnt <= 22'b100;
        else
            cnt <= cnt + 1;

    assign cs  =   cnt [8];
    assign sck = ~ cnt [3];

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            shift <= 16'b00;
        else if (cs == 1'b0 && cnt [3:0] == 4'b0111)
            shift <= (shift << 1) | sdo;
        else if (cnt [21:0] == 22'b0)
            value <= shift;

endmodule
