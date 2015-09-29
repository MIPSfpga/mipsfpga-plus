MIPSfpga+ / mipsfpga-plus / mfp is a cleaned-up and improved variant of
MIPSfpga-based system defined in MIPSfpga Getting Started package.

Right now mipsfpga-plus works on Terasic DE0-CV board with Altera Cyclone V
FPGA ($150 commercial price, $99 academic price). It will take probably less
then 1/2 hour to make it working on Digilent Basys3 or Nexys 4 DDR boards
with Xilinx Artix-7 FPGA. All pieces for Xilinx are there.

The improvements over the original MIPSfpga wrapper are:

1. There are two additional modules - uart_receiver and srec_parser.
uart_receiver receives file from PC using FTDI-based USB-to-UART connector
that is widely available and cost less than $3 in bulk on aliexpress.com.
srec_parser parses Motorola S-Records file produced by running makefile in
MIPSfpga original software examples.

2. Text is more uniform and clean, there are many cosmetic fixes in text
alignment, consistency of identifiers etc.

3. AHB-Lite protocol is implemented in more correct fashion, allows narrow
(1-byte, 2-bytes) writes. AHB-Lite memory slave in the original MIPSfpga
allowed only words.

The combination of uart_receiver and srec_parser is an aternative to using
Bus Blaster and OpenOCD to load programs into MIPSfpga memory (AHB-Lite
slave). The solution requires no software on PC side; user just has to run
the following three commands ("21" is an example number assigned by Windows
to virtual COM port in USB, it should be tuned by each user according to his
Windows device manager):

set a=21
mode com%a% baud=115200 parity=n data=8 stop=1 to=off xon=off odsr=off octs=off dtr=off rts=off idsr=off
type FPGA_Ram.rec >\\.\COM%a%

This solution does not remove support for BusBlaster/OpenOCD, you can still
use them with the system.

A major disadvantage of loading the program through
USB-FTDI-UART-uart_receiver-srec_parser is that you cannot debug the
software this way.  To use a debugger like gdb, you still need BusBlaster.

A minor disadvantage of mipsfpga-plus (can be fixed): it does not allow
hardwiring ram and reset_ram with different .txt files during synthesys.
Since hardwired memory is typically used in the first example only, where
the second ram is empty, this should not be a problem.

However UART-based loader (I would call it "Serial Loader") can still be
used with MIPSfpga in places when BusBlaster is not available or software is
not compatible (like 32-bit Windows).

mipsfpga-plus uses relative file paths. It is expected to be installed in
C:\github\mipsfpga-plus and it expects the original MIPSfpga package to be
installed in C:\MIPSfpga.

How to synthesize mipsfpga-plus for Terasic DE0-CV board:

1. Unzip MIPSfpga to C:\MIPSfpga

2. Get mipsfpgfa-plus into C:\github\mipsfpga-plus

3. cd C:\github\mipsfpga-plus\boards\de0_cv

4. make_project.bat

5. Run Altera Quartus II

6. Open project C:\github\mipsfpga-plus\boards\de0_cv\project\de0_cv.qpf

7. Analyze/Synthesize/Place&Route/Assemble

8. Open Device / Hardware Setup / ByteBlaster / Set file / ouput_files /
de0_cv.sof / Start

How to load a software example into mipsfpga-plus using BusBlaster and
OpenOCD:

cd C:\github\mipsfpga-plus\programs\Lab02_C\ReadSwitches\
upload_using_bus_blaster.bat 

How to load a software example into mipsfpga-plus using FTDI-based "Serial
Loader" / uart_receiver / srec_parser:

cd C:\github\mipsfpga-plus\programs\Lab02_C\ReadSwitches\
upload_using_uart.bat
