#!/bin/bash

# nftables

set -e
set -u

# build libmnl
sub_pkg_dir="$(locate_package 'libmnl')"
. "${sub_pkg_dir}/package.mk"
cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi
cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi
cd "${CLFS_SOURCES}/"
tar -xjvf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"
cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"
patch -Np1 -i "${SOURCES}/${PKG_NAME}-musl.patch"
./configure "${PKG_CONFIGURE_OPTS[@]}"
make
make install DESTDIR="${FAKEROOT}"
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

# build libnftnl
sub_pkg_dir="$(locate_package 'libnftnl')"
. "${sub_pkg_dir}/package.mk"
cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi
cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi
cd "${CLFS_SOURCES}/"
tar -xjvf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"
cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"
patch -Np1 -i "${SOURCES}/${PKG_NAME}-musl.patch"

LIBMNL_CFLAGS="-I${FAKEROOT}/include" \
LIBMNL_LIBS="-L${FAKEROOT}/lib" \
./configure "${PKG_CONFIGURE_OPTS[@]}"

make
make install DESTDIR="${FAKEROOT}"
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

# build nftables
pkg_dir="$(locate_package 'nftables')"
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
cd "${CLFS_SOURCES}/"
tar -xjvf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"
cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"
patch -Np1 -i "${SOURCES}/${PKG_NAME}-musl.patch"

CFLAGS="-I${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/include" \
CPPFLAGS="-I${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/include" \
YACC="${CLFS_ENV_PATH}/bison"
LIBMNL_CFLAGS="-I${FAKEROOT}/include" \
LIBMNL_LIBS="-L${FAKEROOT}/lib" \
LIBNFTNL_CFLAGS="-I${FAKEROOT}/include" \
LIBNFTNL_LIBS="-L${FAKEROOT}/lib" \
./configure "${PKG_CONFIGURE_OPTS[@]}"

make
make install DESTDIR="${FAKEROOT}"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

