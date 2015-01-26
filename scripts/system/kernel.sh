#!/bin/bash

# Linux Kernel

set -e
set -u

pkg_dir="$(locate_package 'linux')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -d "${CLFS_SOURCES}/${PKG_NAME}" ]; then
    git clone "${PKG_URL}" --branch "rpi-${KERNEL_VERSION}.y" --single-branch --progress
fi

cd "${CLFS_SOURCES}/${PKG_NAME}/"

# make sure source is clean
make mrproper

# ensure we have the latest source and correct version
git fetch
cur_branch="$(git symbolic-ref --short -q HEAD)"
if [ "${cur_branch}" != "rpi-${KERNEL_VERSION}.y" ]; then
    git reset --hard "origin/${cur_branch}"
    git checkout "rpi-${KERNEL_VERSION}.y"
fi
git reset --hard "origin/rpi-${KERNEL_VERSION}.y"

# make sure source is clean
make mrproper

ARCH="${CLFS_ARCH}" make bcmrpi_cutdown_defconfig

ARCH="${CLFS_ARCH}" CROSS_COMPILE="${CLFS_ENV_PATH}/${CLFS_TARGET}-" make oldconfig

ARCH="${CLFS_ARCH}" CROSS_COMPILE="${CLFS_ENV_PATH}/${CLFS_TARGET}-" make

make ARCH="${CLFS_ARCH}" CROSS_COMPILE="${CLFS_ENV_PATH}/${CLFS_TARGET}-" \
    INSTALL_MOD_PATH="${FAKEROOT}" modules_install

########## Get tools ##########
pkg_dir="$(locate_package 'tools')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -d "${CLFS_SOURCES}/${PKG_NAME}" ]; then
    git clone --depth 1 "${PKG_URL}" --progress
fi

cd "${CLFS_SOURCES}/${PKG_NAME}/"
# ensure we have the latest source and correct version
git fetch
cur_branch="$(git symbolic-ref --short -q HEAD)"
echo "Current Branch: ${cur_branch}"
echo ""
if [ "${cur_branch}" != "master" ]; then
    git reset --hard origin/master
    git checkout master
fi
git reset --hard origin/master

# change to image tools directory
cd "${CLFS_SOURCES}/${PKG_NAME}/mkimage"

# reset to kernel imports
pkg_dir="$(locate_package 'linux')"
. "${pkg_dir}/package.mk"

# make image
echo "Creating kernel image"
./imagetool-uncompressed.py "${CLFS_SOURCES}/${PKG_NAME}/arch/${CLFS_ARCH,,}/boot/Image"

# move kernel image to targetfs boot directory
echo "Installing kernel.img"
mkdir -pv "${FAKEROOT}/boot"
mv -v kernel.img "${FAKEROOT}/boot/"

exit 0

