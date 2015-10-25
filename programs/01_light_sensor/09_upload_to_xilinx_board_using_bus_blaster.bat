copy program.elf FPGA_Ram.elf
cd C:\MIPSfpga\Codescape\ExamplePrograms\Scripts\Nexys4_DDR
loadMIPSfpga.bat C:\github\mipsfpga-plus\programs\01_light_sensor
cd C:\github\mipsfpga-plus\programs\01_light_sensor
del FPGA_Ram.elf
