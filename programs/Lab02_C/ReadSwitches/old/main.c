/*
 * main.c for the MIPSfpga core running on Nexys4 DDR board.
 *
 * This program:
 *   (1) reads the switches on the Nexys4 DDR board and 
 *   (2) flashes the value of the switches on the LEDs
 */

void delay();

//------------------
// main()
//------------------
int main() {
  volatile int *IO_SWITCHES = (int*)0xbf800008;
  volatile int *IO_LEDR = (int*)0xbf800000;
  volatile unsigned int switches;

  while (1)
  {
    *IO_LEDR = switches;
    switches += 5;
    delay ();	  
  }

  while (1) {
    switches = *IO_SWITCHES;
    *IO_LEDR = switches;	  
    //delay();
    //*IO_LEDR = 0;  // turn off LEDs
    //delay();
  }
  return 0;
}

void delay() {
  volatile unsigned int j;
return;
  for (j = 0; j < (1000000); j++) ;	// delay 
}


