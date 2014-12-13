#!/bin/bash

set -e
set -u

. settings/config

# Clean system directory

rm -rf ${FAKEROOT}/*

exit 0

