set a=20
rem set a=39
rem baud=115200

mode com%a% baud=115200 parity=n data=8 stop=1 to=off xon=off odsr=off octs=off dtr=off rts=off idsr=off
type program.rec >\\.\COM%a%
