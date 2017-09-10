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

make icarus
make gtkwave

:return
