#!/bin/bash

# Install Zlib

set -e
set -u

. settings/config
. settings/toolchain
. scripts/utils/utils.sh

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

# for minimal bloat; will be copied over with shared libs
make prefix="${CLFS_TOOLS}/${CLFS_TARGET}" install

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

