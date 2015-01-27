#!/bin/bash

# Bash

set -e
set -u

pkg_dir="$(locate_package 'bash')"

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

make install prefix="${FAKEROOT}"

# symlink /bin/sh to /bin/bash for legacy compatibility
ln -svf /bin/bash "${FAKEROOT}/bin/sh"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

