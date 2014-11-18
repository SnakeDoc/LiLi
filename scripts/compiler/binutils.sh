#!/bin/bash

# Binutils

. settings/config
. scripts/utils/utils.sh

pkg_dir="$(locate_package 'binutils')"

. "${pkg_dir}/package.mk"

pkg_error() {
    error "Error on package ${PKG_NAME}" "binutils.sh" "${1}"
}

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

if [ -d "${CLFS_SOURCES}/${PKG_NAME}-build" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-build"
fi

# ok, now get to business
cd "${CLFS_SOURCES}/"
tar -xvjf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/"

mkdir -v "${CLFS_SOURCES}/${PKG_NAME}-build"
cd "${CLFS_SOURCES}/${PKG_NAME}-build"

"${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/configure" "${PKG_CONFIGURE_OPTS[@]}"
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

make configure-host
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

make install
RESPONSE="${?}"
if [ "${RESPONSE}" != "0" ]; then
    pkg_error "${RESPONSE}"
    exit "${RESPONSE}"
fi

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"
rm -rf "${PKG_NAME}-build"

exit "${RESPONSE}"

