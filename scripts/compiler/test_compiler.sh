#!/bin/bash

# Script that tests the cross-compiler to ensure it is working

. settings/config
. scripts/utils/utils.sh

pkg_error() {
    error "Error testing cross-compiler!" "test_compiler.sh" "${1}"
}

# make sure we're clean
rm -f "${TEST_PROGRAM}.c"
rm -f "${TEST_PROGRAM}.o"

# create a test c program to compile
TEST_PROGRAM="test"

cat > "${TEST_PROGRAM}.c" << "EOF"
#include <stdio.h>

void main()
{
   printf("%s", "Hello World!");
}

EOF

# try to compile it with our new cross-compiler
"${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc" "${TEST_PROGRAM}.c" -o "${TEST_PROGRAM}.o"
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

# make sure it's the right arch
echo -n "Test compiled binary for correct target arch: " 
BIN_ARCH="$(file ${TEST_PROGRAM}.o | cut -d ' ' -f 6 | cut -d ',' -f 1)"
echo -n "${BIN_ARCH}"
if [ "${BIN_ARCH,,}" == "${CLFS_ARCH}" ]; then
    show_status "${OK}"
    RESPONSE="0"
else
    show_status "${FAIL}"
    RESPONSE="1"
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

# cleanup
rm -f "${TEST_PROGRAM}.c"
rm -f "${TEST_PROGRAM}.o"

exit "${RESPONSE}"

