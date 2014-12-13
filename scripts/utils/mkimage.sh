#!/bin/bash

# Make Image of Filesystem

set -e
set -u

. settings/config
. scripts/utils/utils.sh

if [ -e "${IMAGE_DIR}" ]; then

   echo "Image Directory exists! Cleaning..."
   cd "${BUILD_ROOT}/"
   rm -rf "${IMAGE_DIR}/"

fi

echo "Creating Image Directory..."

mkdir -pv "${IMAGE_DIR}"

IMAGE_DATE=$(date +%Y%m%d)
SHORT_VERSION=$(echo ${VERSION} | cut -d " " -f 1)
IMAGE_NAME="${IMAGE_DATE}-${OS_NAME,,}-${SHORT_VERSION}-${CLFS_ARM_ARCH}-rpi.img"

echo "Creating Image File ${IMAGE_NAME} in ${IMAGE_DIR}"

dd if=/dev/zero of="${IMAGE_DIR}/${IMAGE_NAME}" bs="${IMAGE_SIZE_BS}" count="${IMAGE_SIZE_COUNT}"
check_status

# we wrote a lot to disk, sync now
echo ""
echo -n "Sync disk"
sync
check_status

# now make the partitions
echo ""
echo "Creating Image Partitions..."
(echo n; echo p; echo 1; echo ; echo +128M; 
   echo n; echo p; echo 2; echo ; echo ; echo t; 
   echo 1; echo c; echo a; echo 1; echo p; echo w;) | fdisk "${IMAGE_DIR}/${IMAGE_NAME}"
check_status

# now format the partitions
echo -n "Creating loopback devices..."
MAPPING=($(kpartx -l "${IMAGE_DIR}/${IMAGE_NAME}" | cut -d " " -f 1))
kpartx -a "${IMAGE_DIR}/${IMAGE_NAME}"
check_status

sleep 2

echo "Formatting partition 1 as vfat..."
mkfs.vfat "/dev/mapper/${MAPPING[0]}"
check_status
sync

sleep 2

echo "Formatting partition 2 as ext4..."
mkfs.ext4 "/dev/mapper/${MAPPING[1]}"
check_status
sync

sleep 2

echo "Creating base directory structure..."
mkdir -pv "${IMAGE_DIR}/rootfs"
check_status

# now mount the image file
echo -n "Mounting image..."
mount "/dev/mapper/${MAPPING[1]}" "${IMAGE_DIR}/rootfs" && 
   mkdir -pv "${IMAGE_DIR}/rootfs/boot" && 
   mount -t vfat "/dev/mapper/${MAPPING[0]}" "${IMAGE_DIR}/rootfs/boot"
check_status

# unpack base packages into image
echo "Unpacking base packages..."
"${SCRIPTS}/utils/unpack.sh" "${IMAGE_DIR}/rootfs"
check_status

echo -n "Syncing disk..."
sync
check_status

## cleanup ##
# unmount
echo -n "Unmounting image..."
umount "${IMAGE_DIR}/rootfs/boot" && umount "${IMAGE_DIR}/rootfs"
check_status

# cleanup loopbacks
echo -n "Cleaning up loopback devices..."
kpartx -d "${IMAGE_DIR}/${IMAGE_NAME}"
check_status

## Completed ##
echo -n "Image created:"
show_status "${OK}"

exit 0

