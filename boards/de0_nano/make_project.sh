#!/bin/sh

DIRNAME=project

rm -rf $DIRNAME
mkdir $DIRNAME

cp *.qpf $DIRNAME
cp *.qsf $DIRNAME
cp *.sdc $DIRNAME

echo "Project created. You can also use a 'make' tool to build it and program FPGA chip in console mode. Run 'make help' for detailes"
