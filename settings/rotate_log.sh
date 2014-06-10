#!/bin/bash

# Simple script to rotate log files

LOG="runtime.log"

if [ -e "${LOG}.4" ]
then
    rm -rf ${LOG}.4
fi
if [ -e "${LOG}.3" ]
then
    mv ${LOG}.3 ${LOG}.4
fi
if [ -e "${LOG}.2" ]
then
    mv ${LOG}.2 ${LOG}.3
fi
if [ -e "${LOG}.1" ]
then
    mv ${LOG}.1 ${LOG}.2
fi
if [ -e "${LOG}" ]
then
    mv ${LOG} ${LOG}.1
fi

