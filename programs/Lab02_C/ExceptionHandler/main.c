/*
 * main.c for the MIPSfpga core running on Nexys4 DDR board.
 *
 * This program:
 *   (1) reads the switches on the Nexys4 DDR board and 
 *   (2) flashes the value of the switches on the LEDs
 */

int main() {
  volatile int *test_error = (int*)0x0;   

  *test_error = 56;   // write to address 0 will cause an exception

  return 0;
}

void _mips_handle_exception(void* ctx, int reason) {
  volatile int *IO_LEDR = (int*)0xbf800000;

  *IO_LEDR = 0x8001;  // Display 0x8001 on LEDs to indicate error state
  while (1) ;
}

