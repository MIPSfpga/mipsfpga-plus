copy program.elf FPGA_Ram.elf
cd C:\MIPSfpga\Codescape\ExamplePrograms\Scripts\Nexys4_DDR
loadMIPSfpga.bat C:\github\mipsfpga-plus\programs\02_cache_misses
cd C:\github\mipsfpga-plus\programs\02_cache_misses
del FPGA_Ram.elf
