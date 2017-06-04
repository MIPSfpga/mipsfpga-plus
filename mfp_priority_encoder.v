



module priority_encoder8_r
(
    input       [ 7 : 0 ] in,
    output reg            detect,
    output reg  [ 2 : 0 ] out
);
    always @ (*)
        casez(in)
            default     : {detect, out} = 4'b0000;
            8'b???????1 : {detect, out} = 4'b1000;
            8'b??????10 : {detect, out} = 4'b1001;
            8'b?????100 : {detect, out} = 4'b1010;
            8'b????1000 : {detect, out} = 4'b1011;
            8'b???10000 : {detect, out} = 4'b1100;
            8'b??100000 : {detect, out} = 4'b1101;
            8'b?1000000 : {detect, out} = 4'b1110;
            8'b10000000 : {detect, out} = 4'b1111;
        endcase
endmodule

module priority_encoder16_r
(
    input      [  15 : 0 ] in,
    output reg             detect,
    output reg [   3 : 0 ] out
);
    wire [1:0] detectL;
    wire [2:0] preoutL [1:0];

    //1st order entries
    priority_encoder8_r e10( in[  7:0 ], detectL[0], preoutL[0] );
    priority_encoder8_r e11( in[ 15:8 ], detectL[1], preoutL[1] );

    always @ (*)
        casez(detectL)
            default : {detect, out} = 5'b0;
            2'b?1   : {detect, out} = { 2'b10, preoutL[0] };
            2'b10   : {detect, out} = { 2'b11, preoutL[1] };
        endcase
endmodule
