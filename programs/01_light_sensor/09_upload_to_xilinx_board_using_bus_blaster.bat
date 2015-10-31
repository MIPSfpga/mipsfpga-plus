copy program.elf FPGA_Ram.elf
cd C:\MIPSfpga\Codescape\ExamplePrograms\Scripts\DE2_115
rem Yes, it is working with DE2_115 script
loadMIPSfpga.bat C:\github\mipsfpga-plus\programs\01_light_sensor
cd C:\github\mipsfpga-plus\programs\01_light_sensor
del FPGA_Ram.elf
