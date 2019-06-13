//
//  Derived from:
//
//  1. Designing Video Game Hardware in Verilog by Hugg Steven
//  https://8bitworkshop.com
//
//  2. ZEOWAA board examples on AliExpress
//
//  3. An article on VGA controller by Scott Larson
//  https://www.digikey.com/eewiki/pages/viewpage.action?pageId=15925278
//
//  Video sync generator, used to drive a simulated CRT.
//
//  To use:
//
//      - Wire the hsync and vsync signals to top level outputs
//      - Add a 3-bit (or more) "rgb" output to the top level
//

module vga
(
  input            clk,
  input            reset,
  output reg       hsync,
  output reg       vsync,
  output reg       display_on,
  output reg [9:0] hpos,
  output reg [9:0] vpos
);

  // horizontal constants

  parameter H_DISPLAY       = 640; // horizontal display width
  parameter H_FRONT         =  16; // horizontal right border (front porch)
  parameter H_SYNC          =  96; // horizontal sync width
  parameter H_BACK          =  48; // horizontal left border (back porch)

  // vertical constants

  parameter V_DISPLAY       = 480; // vertical display height
  parameter V_BOTTOM        =  10; // vertical bottom border
  parameter V_SYNC          =   2; // vertical sync # lines
  parameter V_TOP           =  33; // vertical top border

  // derived constants

  parameter H_SYNC_START    = H_DISPLAY + H_FRONT;
  parameter H_SYNC_END      = H_DISPLAY + H_FRONT  + H_SYNC          - 1;
  parameter H_MAX           = H_DISPLAY + H_FRONT  + H_SYNC + H_BACK - 1;

  parameter V_SYNC_START    = V_DISPLAY + V_BOTTOM;
  parameter V_SYNC_END      = V_DISPLAY + V_BOTTOM + V_SYNC          - 1;
  parameter V_MAX           = V_DISPLAY + V_BOTTOM + V_SYNC + V_TOP  - 1;

  // calculating next values of the counters

  reg [9:0] d_hpos;
  reg [9:0] d_vpos;

  always @*
    if (hpos == H_MAX)
    begin
      d_hpos = 10'd0;

      if (vpos == V_MAX)
        d_vpos = 10'd0;
      else
        d_vpos = vpos + 10'd1;
    end
    else
    begin
      d_hpos = hpos + 10'd1;
      d_vpos = vpos;
    end

  // enable to divide clock from 50 MHz to 25 MHz

  reg clk_en;

  always @ (posedge clk or posedge reset)
    if (reset)
      clk_en <= 1'b0;
    else
      clk_en <= ~ clk_en;

  // making all outputs registered

  always @ (posedge clk or posedge reset)
    if (reset)
    begin
      hsync       <= 1'b0;
      vsync       <= 1'b0;
      display_on  <= 1'b0;
      hpos        <= 1'b0;
      vpos        <= 1'b0;
    end
    else if (clk_en)
    begin
      hsync       <= ~ ( d_hpos >= H_SYNC_START && d_hpos <= H_SYNC_END );
      vsync       <= ~ ( d_vpos >= V_SYNC_START && d_vpos <= V_SYNC_END );

      display_on  <=   ( d_hpos <  H_DISPLAY    && d_vpos <  V_DISPLAY  );

      hpos        <= d_hpos;
      vpos        <= d_vpos;
    end

endmodule
