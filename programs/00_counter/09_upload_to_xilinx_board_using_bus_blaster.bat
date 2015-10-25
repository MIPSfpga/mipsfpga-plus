copy program.elf FPGA_Ram.elf
cd C:\MIPSfpga\Codescape\ExamplePrograms\Scripts\Nexys4_DDR
loadMIPSfpga.bat C:\github\mipsfpga-plus\programs\00_counter
cd C:\github\mipsfpga-plus\programs\00_counter
del FPGA_Ram.elf
