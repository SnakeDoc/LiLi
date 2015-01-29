#!/bin/bash

# libmnl

set -e
set -u

pkg_dir="$(locate_package 'libmnl')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -xjvf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

patch -Np1 -i "${SOURCES}/${PKG_NAME}-musl.patch"

CC="${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc" ./configure "${PKG_CONFIGURE_OPTS[@]}"
  
CC="${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc" make

make install prefix="${FAKEROOT}"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

