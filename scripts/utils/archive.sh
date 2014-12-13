#!/bin/bash

set -e
set -u

. settings/config
. scripts/utils/utils.sh

# Archives builds

ERR_MSG="Error while archiving build!"
ERR_LOC="${SCRIPTS}/utils/archive.sh"

BUILD_DATE=$(date +%Y%m%d)

SHORT_VERSION=$(echo ${VERSION} | cut -d " " -f 1)
ARCHIVE_NAME="${BUILD_DATE}-${OS_NAME,,}-${SHORT_VERSION}-${CLFS_ARM_ARCH}-rpi"

# Ensure builds directory exists
mkdir -pv "${BUILDS}/"

######################################
#### Make archive of all packages ####
######################################
if [ -d "${FAKEROOT_PKGDIR}" ]; then
    echo "Creating archive of all packages"
    pre="$(pwd)"
    cd "${FAKEROOT_PKGDIR}/"

    # make tar.bz2 archive
    tar jcfv "${BUILDS}/${ARCHIVE_NAME}-packages.tar.bz2" *
    sync

    # make tar.gz archive
    tar cvzf "${BUILDS}/${ARCHIVE_NAME}-packages.tar.gz" *
    sync

    cd "${pre}/"
fi

################################
#### Make archive of rootfs ####
################################
# Unpack rootfs
echo "Creating archive of rootfs"
"${SCRIPTS}/utils/unpack.sh"

pre="$(pwd)"
cd "${FAKEROOT}/"

# Make tar.bz2 archive
tar jcfv "${BUILDS}/${ARCHIVE_NAME}-rootfs.tar.bz2" *
sync

# Make tar.gz archive
tar pzcvf "${BUILDS}/${ARCHIVE_NAME}-rootfs.tar.gz" *
sync

cd "${pre}/"

####################################
#### Make archive of disk image ####
####################################
echo "Creating archive of disk image"

imgs=$(find "${IMAGE_DIR}/" -type f -name "*.img")
for i in "${imgs[@]}"; do
    cp "${i}" "${BUILDS}/"
    sync

    gzip -c "${i}" > "${i}.gz"
    sync

    mv "${i}.gz" "${BUILDS}/"
    sync
done

echo -n "Archiving build: "
show_status "${OK}"

