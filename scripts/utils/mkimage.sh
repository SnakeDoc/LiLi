#!/bin/bash

# Make Image of Filesystem

. settings/functions
. settings/config

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


# now mount the image file
echo ""
echo "Creating base directory structure..."
mkdir -pv "${IMAGE_DIR}/mnt/boot"
check_status



