rd /s /q ..\run
md ..\run
g++ generator.cpp 2> a.lst
a.exe
del a.exe
