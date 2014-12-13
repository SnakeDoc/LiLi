#!/bin/bash

# Install Dropbear SSH Client/Server

set -e
set -u

pkg_dir="$(locate_package 'dropbear')"

. "${pkg_dir}/package.mk"

echo "CC: ${CC}"
cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -xvjf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

sed -i 's/.*mandir.*//g' Makefile.in

CC="${CC} -Os" ./configure --prefix=/usr --host="${CLFS_TARGET}"
make MULTI=1 \
  PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

make MULTI=1 \
  PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" \
  install DESTDIR="${FAKEROOT}"

install -dv "${FAKEROOT}/etc/dropbear"

# setup dropbear bootscripts
pkg_dir="$(locate_package 'bootscripts')"

. "${pkg_dir}/package.mk"

# check if bootscripts is already downloaded
cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}.tar.gz" ]; then
    wget --read-timeout=20 -O "${PKG_NAME}.tar.gz" "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}"
fi

# unpack bootscripts
cd "${CLFS_SOURCES}/"
tar -zxvf "${PKG_NAME}.tar.gz"

cd "${CLFS_SOURCES}/${PKG_NAME}/"

make install-dropbear DESTDIR="${FAKEROOT}"

# cleanup bootscripts
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}"

# reset dropbear script includes
pkg_dir="$(locate_package 'dropbear')"

. "${pkg_dir}/package.mk"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

