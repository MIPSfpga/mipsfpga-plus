#!/bin/sh

DIRNAME=project

rm -rf $DIRNAME
mkdir $DIRNAME

cp *.qpf $DIRNAME
cp *.qsf $DIRNAME
cp *.sdc $DIRNAME
