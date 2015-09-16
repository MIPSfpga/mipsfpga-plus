// mipsfpga_basys3.v
// 30 April 2015
//
// Instantiate the mipsfpga system and rename signals to
// match GPIO, LEDs and switches on Digilent's (Xilinx)
// Basys3 FPGA board


module mipsfpga_basys3( input         clk,
				 input         btnU, btnD, btnL, btnR, btnC, 
				 input  [15:0] sw,
				 output [15:0] led,
				 inout  [ 5:0] JB 
);


  // Press btnC to reset the processor. 
        
  wire clk_out; 
  wire tck_in, tck;
  
  clk_wiz_0 clk_wiz_0(.clk_in1(clk), .clk_out1(clk_out));
  IBUF IBUF1(.O(tck_in),.I(JB[3]));
  BUFG BUFG1(.O(tck), .I(tck_in));

  mipsfpga_sys mipsfpga_sys(
			   .SI_Reset_N(~btnC),
                    .SI_ClkIn(clk_out),
                    .HADDR(),
                    .HRDATA(),
                    .HWDATA(),
                    .HWRITE(),
                    .EJ_TRST_N_probe(JB[4]),
                    .EJ_TDI(JB[1]),
                    .EJ_TDO(JB[2]),
                    .EJ_TMS(JB[0]),
                    .EJ_TCK(tck),
                    .SI_ColdReset_N(JB[5]),
                    .EJ_DINT(1'b0),
                    .IO_Switch({2'b0,sw}),
                    .IO_PB({btnU, btnD, btnL, 1'b0, btnR}),
                    .IO_LEDR(led),
                    .IO_LEDG());
          
endmodule
