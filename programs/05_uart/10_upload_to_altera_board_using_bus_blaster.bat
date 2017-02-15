copy program.elf FPGA_Ram.elf
cd C:\MIPSfpga\Codescape\ExamplePrograms\Scripts\DE2_115
loadMIPSfpga.bat C:\github\mipsfpga-plus\programs\00_counter
cd C:\github\mipsfpga-plus\programs\00_counter
del FPGA_Ram.elf
