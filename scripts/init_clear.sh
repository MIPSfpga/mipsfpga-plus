#!/bin/bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
TOP_BOARD=$SCRIPTPATH/../boards
TOP_PROGRAM=$SCRIPTPATH/../programs

for program in $TOP_PROGRAM/*
do
    if [ -d $program ]; then
	rm -f $program/*.bat
    rm -f $program/*.sh
    fi
done
