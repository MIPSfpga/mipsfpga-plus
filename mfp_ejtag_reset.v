module mfp_ejtag_reset
(
    input      clk,
    output reg trst_n
);

    reg [3:0] trst_delay;
  
    always @ (posedge clk)
    begin
        if (trst_delay == 4'hf)
            trst_n     <= 1'b1;
        else
        begin
            trst_n     <= 1'b0;
            trst_delay <= trst_delay + 4'b1;
        end
    end

endmodule
