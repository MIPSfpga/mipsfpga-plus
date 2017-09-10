#!/bin/bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
TOP_BOARD=$SCRIPTPATH/../boards
TOP_PROGRAM=$SCRIPTPATH/../programs

for board in $TOP_BOARD/*
do
    if [ -d $board ] && [ "$TOP_BOARD/program" != "$board" ]; then
	rm -f $board/*.bat
    rm -f $board/*.sh
    fi
done

for program in $TOP_PROGRAM/*
do
    if [ -d $program ]; then
	rm -f $program/*.bat
    rm -f $program/*.sh
    fi
done
