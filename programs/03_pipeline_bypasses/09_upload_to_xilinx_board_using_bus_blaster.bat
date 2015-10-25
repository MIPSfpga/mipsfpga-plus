copy program.elf FPGA_Ram.elf
cd C:\MIPSfpga\Codescape\ExamplePrograms\Scripts\Nexys4_DDR
loadMIPSfpga.bat C:\github\mipsfpga-plus\programs\03_pipeline_bypasses
cd C:\github\mipsfpga-plus\programs\03_pipeline_bypasses
del FPGA_Ram.elf
