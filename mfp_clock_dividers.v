module mfp_clock_divider
(
    input      clki,
    input      sel_lo,
    input      sel_mid,
    output reg clko
);

    // 50 MHz / 2 ** 26 = 0.75 Hz
    parameter DIV_POW = 26;

    reg [DIV_POW - 1: 0] counter;

    always @ (posedge clki)
        counter <= counter + 1'b1;

    always @ (posedge clki)
	clko <= sel_lo  ? counter [DIV_POW - 1] : 
                sel_mid ? counter [DIV_POW - 5] :
                          ~ clko;

endmodule

//--------------------------------------------------------------------

module mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz
(
    input  clki,
    input  sel_lo,
    input  sel_mid,
    output clko
);

    mfp_clock_divider # (.DIV_POW (26))
    mfp_clock_divider (clki, sel_lo, sel_mid, clko);

endmodule

//--------------------------------------------------------------------

module mfp_clock_divider_50_MHz_to_763_Hz
(
    input  clki,
    output clko
);

    mfp_clock_divider
    # (.DIV_POW (16))
    mfp_clock_divider
    (
        .clki    ( clki ),
        .sel_lo  ( 1'b1 ),
        .sel_mid ( 1'b0 ),
        .clko    ( clko )
    );

endmodule
