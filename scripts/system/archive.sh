#!/bin/bash

# Archive the root filesystem

. ${SETTINGS}/toolchain
. ${SETTINGS}/functions

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

mkdir -pv ${CLFS}/archives

BUILD_DATE=$(date +%Y%m%d)

echo "Archiving root filesystem"
cd ${FAKEROOT}/
SHORT_VERSION=$(echo ${VERSION} | cut -d " " -f 1)
ARCHIVE_NAME="${BUILD_DATE}-${OS_NAME,,}-${SHORT_VERSION}-${CLFS_ARM_ARCH}-rpi.tar.bz2"

tar jcfv ${CLFS}/archives/${ARCHIVE_NAME} *
fail_on_error $?

echo ""
echo "Archive ${ARCHIVE_NAME} is now avilable at ${CLFS}/archives/"
echo ""

exit 0 # normal exit

