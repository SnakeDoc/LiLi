#!/bin/bash

# Unpack Tools
#  - Used to unpack packages and install base file system

. settings/functions
. settings/config

if [ -n "${1}" ]; then
    FAKEROOT="${1}"
else
    if [ -e "${FAKEROOT}" ]; then
        echo "Fakeroot exists! Cleaning..."
        cd "${BUILD_ROOT}/"
        rm -rf "${FAKEROOT}/"
    fi

    echo "Creating Fakeroot Directory..."

    mkdir -pv "${FAKEROOT}"
    check_status
fi

# now unpack everything from ${BUILD_ROOT}/packages directory
PACKAGES=$(find "${FAKEROOT_PKGDIR}/" -type f -name "*.tar.gz")

for package in ${PACKAGES[@]}; do

   echo "Extracting package: ${package}"
   tar -zxvf "${package}" -C "${FAKEROOT}/"
   check_status

done

# we shold sync now to ensure all buffers are flushed to disk
echo ""
echo -n "Syncing disk"
sync
check_status

echo ""
echo "Packages Unpacked:"
echo ""

for package in ${PACKAGES[@]}; do
   echo -n "${package}"
   show_status "${OK}"
done

echo ""
echo "All packages unpacked!"

