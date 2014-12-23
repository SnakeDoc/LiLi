#!/bin/bash

# musl-libc

set -e
set -u

pkg_dir="$(locate_package 'musl-libc')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.gz" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -zxvf "${PKG_NAME}-${PKG_VERSION}.tar.gz"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

CC="${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc" ./configure "${PKG_CONFIGURE_OPTS[@]}"
  
CC="${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc" make

# make a temp directory to install into,
#  we'll later copy just what we need into the fakeroot.
TEMP_INSTALL="${CLFS_SOURCES}/${PKG_NAME}-install"
mkdir -pv "${TEMP_INSTALL}"

DESTDIR="${TEMP_INSTALL}" make install

# let's now copy over the files we need into the fakeroot
cp -vP "${TEMP_INSTALL}/lib/"*.so* "${FAKEROOT}/lib/"
sync

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"
rm -rf "${TEMP_INSTALL}"

exit 0

