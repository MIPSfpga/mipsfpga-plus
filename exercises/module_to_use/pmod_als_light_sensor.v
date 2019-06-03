// Note active positive reset

module pmod_als_light_sensor
(
    input             clk,
    input             reset,
    output            cs,
    output            sck,
    input             sdo,
    output reg [15:0] value
);

    reg [ 8:0] cnt;
    reg [15:0] shift;

    always @ (posedge clk or posedge reset)
    begin       
        if (reset)
            cnt <= 8'b100;
        else
            cnt <= cnt + 8'b1;
    end

    assign sck = ~ cnt [3];
    assign cs  =   cnt [8];

    wire sample_bit = ( cs == 1'b0 && cnt [3:0] == 4'b1111 );
    wire value_done = ( cs == 1'b1 && cnt [7:0] == 8'b0 );

    always @ (posedge clk or posedge reset)
    begin       
        if (reset)
        begin       
            shift <= 16'h0000;
            value <= 16'h0000;
        end
        else if (sample_bit)
        begin       
            shift <= (shift << 1) | sdo;
        end
        else if (value_done)
        begin       
            value <= shift;
        end
    end

endmodule
