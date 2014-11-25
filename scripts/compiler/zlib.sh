#!/bin/bash

# Install Zlib

. settings/config
. settings/toolchain
. scripts/utils/utils.sh

pkg_dir="$(locate_package 'zlib')"

. "${pkg_dir}/package.mk"

pkg_error() {
    error "Error on package ${PKG_NAME}" "zlib.sh" "${1}"
}

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
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

sed -e 's/-O3/-Os/g' configure.orig > configure
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

./configure --shared
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

make
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

# for minimal bloat; will be copied over with shared libs
make prefix="${CLFS_TOOLS}/${CLFS_TARGET}" install
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit "${RESPONSE}"

