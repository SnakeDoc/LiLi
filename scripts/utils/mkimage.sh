#!/bin/bash

# Make Image of Filesystem

set -e
set -u

. settings/config
. scripts/utils/utils.sh

MNT_TMP="${IMAGE_DIR}/rootfs"
LOOP="$(losetup -f)"

DISK_SIZE="$((${SYSTEM_SIZE} + ${STORAGE_SIZE} + 4))"
IMAGE_DATE=$(date +%Y%m%d)
SHORT_VERSION=$(echo ${VERSION} | cut -d " " -f 1)
IMAGE_NAME="${IMAGE_DATE}-${OS_NAME,,}-${SHORT_VERSION}-${CLFS_ARM_ARCH}-rpi.img"
DISK="${IMAGE_DIR}/${IMAGE_NAME}"

cleanup() {
    echo "Cleaning up..."
    umount "${MNT_TMP}" &>/dev/null || true
    losetup -a | cut -d ' ' -f 3 | cut -d '(' -f 2 | cut -d ')' -f 1 | xargs losetup -d
    rm -rf "${MNT_TMP}"
    exit
}

trap cleanup SIGINT

if [ -e "${IMAGE_DIR}" ]; then

   echo "Image Directory exists! Cleaning..."
   cd "${BUILD_ROOT}/"
   rm -rf "${IMAGE_DIR}/"

fi

echo "Creating Image Directory..."
mkdir -pv "${IMAGE_DIR}"

echo "Creating base directory structure..."
mkdir -pv "${MNT_TMP}"
check_status

# ensure loop is not in use
umount "${MNT_TMP}" &>/dev/null || true
umount "${LOOP}" &>/dev/null >/dev/null || true
losetup -d "${LOOP}" &>/dev/null >/dev/null || true

echo "Creating Image File ${IMAGE_NAME} in ${IMAGE_DIR}"

dd if=/dev/zero of="${DISK}" bs="${IMAGE_SIZE_BS}" count="${DISK_SIZE}"
sync

# make disklabel
echo "Creating partition table on ${DISK}"
losetup "${LOOP}" "${DISK}"
parted -s "${LOOP}" mklabel msdos
sync

# create partition 1
echo "Creating part1 on ${DISK}"
SYSTEM_PART_END="$((${SYSTEM_SIZE} * 1024 * 1024 / 512 + 2048))"

parted -s "${LOOP}" -a min unit s mkpart primary fat32 2048 "${SYSTEM_PART_END}"
sync
parted -s "${LOOP}" set 1 boot on
sync

# create partition 2
echo "Creating part2 on ${DISK}"
STORAGE_PART_START="$((${SYSTEM_PART_END} + 2048))"
STORAGE_PART_END="$((${STORAGE_PART_START} + ((${STORAGE_SIZE} * 1024 * 1024 / 512))))"
parted -s "${LOOP}" -a min unit s mkpart primary ext4 "${STORAGE_PART_START}" "${STORAGE_PART_END}"
sync

# create filesystem on part1
losetup -d "${LOOP}"
echo "Creating filesystem on part1"
PART1_OFFSET="$((2048 * 512))"
PART1_SIZELIMIT="$((${SYSTEM_SIZE} * 1024 * 1024))"
losetup -o "${PART1_OFFSET}" --sizelimit "${PART1_SIZELIMIT}" "${LOOP}" "${DISK}"
mkfs.vfat "${LOOP}"
sync

# make sure part1 is not mounted
umount "${LOOP}" || true

# create filesystem on part2
losetup -d "${LOOP}"
echo "Creating filesystem on part2"
PART2_OFFSET="$((${STORAGE_PART_START} * 512))"
PART2_SIZELIMIT="$((${STORAGE_SIZE} * 1024 * 1024))"
losetup -o "${PART2_OFFSET}" --sizelimit "${PART2_SIZELIMIT}" "${LOOP}" "${DISK}"
mke2fs -q -t ext4 -m 0 "${LOOP}"
UUID_STORAGE="$(uuidgen)"
tune2fs -U "${UUID_STORAGE}" "${LOOP}"
e2fsck -n "${LOOP}"
sync

# now mount the image file
echo -n "Mounting part2"
mount "${LOOP}" "${MNT_TMP}"
echo "creating boot directory"
mkdir -pv "${MNT_TMP}/boot"
echo -n "Mounting part1 on ${MNT_TMP}/boot"
PART1_OFFSET="$((2048 * 512))"
PART1_SIZELIMIT="$((${SYSTEM_SIZE} * 1024 * 1024))"
losetup -o "${PART1_OFFSET}" --sizelimit "${PART1_SIZELIMIT}" "${LOOP}" "${DISK}"
mount -t vfat "${LOOP}" "${MNT_TMP}/boot"

# unpack base packages into image
echo "Unpacking base packages..."
"${SCRIPTS}/utils/unpack.sh" "${MNT_TMP}"
sync

## cleanup ##
# unmount
echo -n "Unmounting image..."
umount "${MNT_TMP}/boot"
umount "${MNT_TMP}"

## Completed ##
echo -n "Image created:"
show_status "${OK}"

# cleanup workspace
cleanup

