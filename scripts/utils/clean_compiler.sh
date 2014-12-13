#!/bin/bash

set -e
set -u

. settings/config

# Clean compiler directory

rm -rf ${CLFS_TOOLS}/*

exit 0

