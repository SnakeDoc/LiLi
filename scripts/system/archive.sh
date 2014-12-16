#!/bin/bash

# Archive the root filesystem

set -e
set -u

# make sure all data is synced to disk
sync

mkdir -pv "${CLFS}/archives"

BUILD_DATE="$(date +%Y%m%d)"

echo "Archiving base packages"
cd "${FAKEROOT_PKGDIR}/"
SHORT_VERSION="$(echo ${VERSION} | cut -d " " -f 1)"
ARCHIVE_NAME="${BUILD_DATE}-${OS_NAME,,}-${SHORT_VERSION}-${CLFS_ARM_ARCH}-rpi.tar.bz2"

tar jcfv "${CLFS}/archives/${ARCHIVE_NAME}" *

echo ""
echo "Package archive ${ARCHIVE_NAME} is now avilable at ${CLFS}/archives/"
echo ""

exit 0 # normal exit

