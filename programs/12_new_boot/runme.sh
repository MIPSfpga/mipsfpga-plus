
make clean
make TINY_MEMORY=1
stty -F /dev/ttyUSB0 raw speed 115200 -crtscts cs8 -parenb -cstopb
cat program.rec > /dev/ttyUSB0
