#!/bin/bash

# Archive the root filesystem

. settings/functions
. settings/config
. settings/toolchain

pkg_error() {
    error "Error on package archive" "archive.sh" $1
}

fail_on_error() {
    if [ $1 -ne 0 ]
    then
        pkg_error $1
        exit $1
    fi
}

echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~          WARNING !!           ~"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "This script requires sudo access!"
echo ""
echo "Manual password entry will be required if visudo not configured otherwise!"
echo ""

mkdir -pv ${CLFS}/archives

BUILD_DATE=$(date +%Y%m%d)

echo "Archiving root filesystem"
cd ${CLFS_TARGETFS}/
SHORT_VERSION=$(echo ${VERSION} | cut -d " " -f 1)
ARCHIVE_NAME="${BUILD_DATE}-${OS_NAME,,}-${SHORT_VERSION}-${CLFS_ARM_ARCH}-rpi.tar.bz2"

sudo tar jcfv ${CLFS}/archives/${ARCHIVE_NAME} *
fail_on_error $?

echo ""
echo "Archive ${ARCHIVE_NAME} is now avilable at ${CLFS}/archives/"
echo ""

exit 0 # normal exit

