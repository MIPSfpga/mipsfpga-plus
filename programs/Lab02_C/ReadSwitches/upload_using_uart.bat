set a=16
mode com%a% baud=115200 parity=n data=8 stop=1 to=off xon=off odsr=off octs=off dtr=off rts=off idsr=off

make
type FPGA_Ram.rec >\\.\COM%a%
make clean
