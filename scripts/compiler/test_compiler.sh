#!/bin/bash

# Script that tests the cross-compiler to ensure it is working

set -e
set -u

. settings/config
. scripts/utils/utils.sh

# Variable will indicate if the compiler test passed
RESPONSE=0

# create a test c program to compile
TEST_PROGRAM="test"

# make sure we're clean
rm -f "${TEST_PROGRAM}.c"
rm -f "${TEST_PROGRAM}.o"

cat > "${TEST_PROGRAM}.c" << "EOF"
#include <stdio.h>

void main()
{
   printf("%s", "Hello World!");
}

EOF

# try to compile it with our new cross-compiler
"${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc" "${TEST_PROGRAM}.c" -o "${TEST_PROGRAM}.o"

# make sure it's the right arch
echo -n "Test compiled binary for correct target arch: " 
BIN_ARCH="$(file ${TEST_PROGRAM}.o | cut -d ' ' -f 6 | cut -d ',' -f 1)"
echo -n "${BIN_ARCH}"
if [ "${BIN_ARCH,,}" == "${CLFS_ARCH}" ]; then
    show_status "${OK}"
else
    show_status "${FAIL}"
    RESPONSE="1"
fi

# cleanup
rm -f "${TEST_PROGRAM}.c"
rm -f "${TEST_PROGRAM}.o"

exit "${RESPONSE}"

