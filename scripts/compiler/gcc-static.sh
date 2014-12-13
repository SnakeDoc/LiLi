#!/bin/bash

# gcc (static)

set -e
set -u

. settings/config
. scripts/utils/utils.sh

pkg_dir="$(locate_package 'gcc')"

. "${pkg_dir}/package.mk"

cd ${CLFS_SOURCES}/
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

# business time
cd "${CLFS_SOURCES}/"
tar -xvjf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

patch -Np1 -i "${SOURCES}/${PKG_NAME}-${PKG_VERSION}-musl.diff"

# make sure dependencies are available

# mpfr
sub_pkg_dir="$(locate_package 'mpfr')"
. "${sub_pkg_dir}/package.mk"
cd ${CLFS_SOURCES}/
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi
# reset import
. "${pkg_dir}/package.mk"
cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
. "${sub_pkg_dir}/package.mk"
tar -xjvf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
mv -v "${PKG_NAME}-${PKG_VERSION}" "${PKG_NAME}"

# gmp
sub_pkg_dir="$(locate_package 'gmp')"
. "${sub_pkg_dir}/package.mk"
cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi
# reset import
. "${pkg_dir}/package.mk"
cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
. "${sub_pkg_dir}/package.mk"
tar -xjvf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
mv -v "${PKG_NAME}-${PKG_VERSION}" "${PKG_NAME}"

# mpc
sub_pkg_dir="$(locate_package 'mpc')"
. "${sub_pkg_dir}/package.mk"
cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.gz" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi
# reset import
. "${pkg_dir}/package.mk"
cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
. "${sub_pkg_dir}/package.mk"
tar -zxvf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
mv -v "${PKG_NAME}-${PKG_VERSION}" "${PKG_NAME}"

# setup build
. "${pkg_dir}/package.mk"
mkdir -v "${CLFS_SOURCES}/${PKG_NAME}-build"
cd "${CLFS_SOURCES}/${PKG_NAME}-build/"

"${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/configure" "${STATIC_CONFIGURE_OPTS[@]}"
  
make all-gcc all-target-libgcc

make install-gcc install-target-libgcc

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"
rm -rf "${PKG_NAME}-build"

exit 0

