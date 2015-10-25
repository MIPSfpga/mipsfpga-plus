copy program.elf FPGA_Ram.elf
cd C:\MIPSfpga\Codescape\ExamplePrograms\Scripts\DE2_115
call loadMIPSfpga.bat C:\github\mipsfpga-plus\programs\light_sensor
C:\github\mipsfpga-plus\programs\light_sensor
del FPGA_Ram.elf
