#!/bin/bash

# Unpack Tools
#  - Used to unpack packages and install base file system

. settings/functions
. settings/config

if [ -e "${FAKEROOT}" ]; then
    echo "Fakeroot exists! Cleaning..."
    cd "${BUILD_ROOT}/"
    rm -rf "${FAKEROOT}/"

fi

echo "Creating Fakeroot Directory..."

mkdir -pv "${FAKEROOT}"
check_status

# now unpack everything from ${BUILD_ROOT}/packages directory
PACKAGES=$(find "${FAKEROOT_PKGDIR}/" -type f -name "*.tar.gz")

for package in "${PACKAGES[@]}"; do

   echo "Extracting package: ${package}"
   tar -zxvf "${package}" -C "${FAKEROOT}/"
   check_status

done

echo ""
echo "Packages Unpacked:"
echo ""

for package in "${PACKAGES[@]}"; do
   echo -n "${package}"
   show_status "${OK}"
done

echo ""
echo "All packages unpacked!"

