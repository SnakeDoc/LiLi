#!/bin/bash

# Busybox

set -e
set -u

pkg_dir="$(locate_package 'busybox')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# now get started
cd "${CLFS_SOURCES}/"
tar -xvjf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

make distclean

ARCH="${CLFS_ARCH}" make defconfig

# fixup some bugs with musl-libc
sed -i 's/\(CONFIG_\)\(.*\)\(INETD\)\(.*\)=y/# \1\2\3\4 is not set/g' .config
sed -i 's/\(CONFIG_IFPLUGD\)=y/# \1 is not set/' .config

ARCH="${CLFS_ARCH}" CROSS_COMPILE="${CLFS_ENV_PATH}/${CLFS_TARGET}-" make

# Install busybox to rootfs
ARCH="${CLFS_ARCH}" CROSS_COMPILE="${CLFS_ENV_PATH}/${CLFS_TARGET}-" make  \
  CONFIG_PREFIX="${FAKEROOT}" install

# copy the standard depmod file
cp -f examples/depmod.pl "${CLFS_ENV_PATH}"

chmod 755 "${CLFS}/cross-tools/bin/depmod.pl"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

