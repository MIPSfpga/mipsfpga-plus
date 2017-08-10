
echo off

rem Set the simulation topmodule name here
set TOPMODULE=mfp_testbench

rem iverilog compile settings
set IVARG=-g2005 
set IVARG=%IVARG% -D SIMULATION
set IVARG=%IVARG% -I ..\..\..\core
set IVARG=%IVARG% -I ..\..\..\system_rtl
set IVARG=%IVARG% -I ..\..\..\system_rtl\uart16550
set IVARG=%IVARG% -I ..\..\..\testbench
set IVARG=%IVARG% -I ..\..\..\testbench\sdr_sdram
set IVARG=%IVARG% -s %TOPMODULE%
set IVARG=%IVARG% ..\..\..\core\*.v
set IVARG=%IVARG% ..\..\..\system_rtl\*.v
set IVARG=%IVARG% ..\..\..\system_rtl\uart16550\*.v
set IVARG=%IVARG% ..\..\..\testbench\*.v
set IVARG=%IVARG% ..\..\..\testbench\sdr_sdram\*.v

rem checks that iverilog & vvp are installed
where iverilog.exe
if errorlevel 1 (
    echo "iverilog.exe not found!"
    echo "Please install IVERILOG and add 'iverilog\bin' and 'iverilog\gtkwave\bin' directories to PATH"
    goto return
)

where vvp.exe
if errorlevel 1 (
    echo "vvp.exe not found!"
    echo "Please install IVERILOG and add 'iverilog\bin' and 'iverilog\gtkwave\bin' directories to PATH"
    goto return
)

where gtkwave.exe
if errorlevel 1 (
    echo "gtkwave.exe not found!"
    echo "Please install IVERILOG and add 'iverilog\bin' and 'iverilog\gtkwave\bin' directories to PATH"
    goto return
)

rem old simulation clear
rd /s /q sim
md sim
cd sim

copy ..\*.hex .

rem compile
iverilog %IVARG%

rem simulation
vvp -la.lst a.out -n

rem output
gtkwave dump.vcd

cd ..

:return
