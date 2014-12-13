#!/bin/bash

# Simple script to rotate log files

set -e
set -u

LOG="runtime.log"

if [ -e "${LOG}.2" ]; then
    rm -f ${LOG}.2
fi

if [ -e "${LOG}.1" ]; then
    mv ${LOG}.1 ${LOG}.2
fi

if [ -e "${LOG}" ]; then
    mv ${LOG} ${LOG}.1
fi

exit 0

