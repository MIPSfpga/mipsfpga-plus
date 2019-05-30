/*
 * main.c for the MIPSfpga core running on Nexys4 DDR board.
 *
 * This program:
 *   (1) reads the switches on the Nexys4 DDR board and 
 *   (2) flashes the value of the switches on the LEDs
 */
#include "mfp_memory_mapped_registers.h"

void delay();

//------------------
// main()
//------------------
int main() {
  volatile unsigned int switches;

  int n;
  
  MFP_RED_LEDS = 0x33;
  MFP_GREEN_LEDS = 0xCC;

  while (1)
  {
    MFP_RED_LEDS = n ++;
    delay();
  }

  while (1) {
    switches = MFP_SWITCHES;
    MFP_7_SEGMENT_HEX = switches;
    MFP_RED_LEDS  = switches;	  
    MFP_GREEN_LEDS = switches;	  
    delay();
    MFP_RED_LEDS = 0;  // turn off LEDs
    MFP_GREEN_LEDS = 0;  // turn off LEDs
    delay();
  }
  return 0;
}

void delay() {
  volatile unsigned int j;

  for (j = 0; j < (1000000); j++) ;	// delay 
}


