module mfp_ff
# (
    parameter WIDTH = 1
)
(
    input                    clk,
    input      [WIDTH - 1:0] d, 
    output reg [WIDTH - 1:0] q
);

    always @ (posedge clk)
        q <= d;

endmodule
