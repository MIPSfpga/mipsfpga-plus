set a=23
set a=21
set a=16
set a=21
set a=17
set a=23
mode com%a% baud=115200 parity=n data=8 stop=1 to=off xon=off odsr=off octs=off dtr=off rts=off idsr=off
type program.rec >\\.\COM%a%
