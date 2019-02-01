rd /s /q project
mkdir project
copy *.qpf project
copy *.qsf project
copy *.sdc project

echo "Project created. You can also use a 'make' tool to build it and program FPGA chip in console mode. Run 'make help' for detailes"
