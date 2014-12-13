#!/bin/bash

# Install wireless tools

set -e
set -u

pkg_dir="$(locate_package 'wireless_tools')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION}.tar.gz" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION}"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -zxvf "${PKG_NAME}.${PKG_VERSION}.tar.gz"

cd "${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION}/"

sed -i "s|gcc|${CC}|g" Makefile

sed -i "s|\ ar|\ ${AR}|g" Makefile

sed -i "s|\ ranlib|\ ${RANLIB}|g" Makefile

make PREFIX="${FAKEROOT}/usr"

make install PREFIX="${FAKEROOT}/usr"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}.${PKG_VERSION}"

exit 0

