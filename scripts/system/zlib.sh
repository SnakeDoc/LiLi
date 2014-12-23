#!/bin/bash

# Install Zlib

set -e
set -u

pkg_dir="$(locate_package 'zlib')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.gz" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# now get started
cd "${CLFS_SOURCES}/"
tar -zxvf "${PKG_NAME}-${PKG_VERSION}.tar.gz"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

cp configure{,.orig}

sed -e 's/-O3/-Os/g' configure.orig > configure

./configure --shared

make

# make a temp directy to install into,
#  we'll later copy just what we need into the fakeroot.
TEMP_INSTALL="${CLFS_SOURCES}/${PKG_NAME}-install"
mkdir -pv "${TEMP_INSTALL}"

make prefix="${TEMP_INSTALL}" install

# let's now copy over the file we need into fakeroot
cp -vP "${TEMP_INSTALL}/lib/"*.so* "${FAKEROOT}/lib/"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"
rm -rf "${TEMP_INSTALL}"

exit 0

