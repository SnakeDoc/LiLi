#!/bin/bash

# Bootscripts

set -e
set -u

pkg_dir="$(locate_package 'bootscripts')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}.tar.gz" ]; then
    wget --read-timeout=20 -O "${PKG_NAME}.tar.gz" "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}"
fi

# now get started
cd "${CLFS_SOURCES}/"
tar -zxvf "${PKG_NAME}.tar.gz"

cd "${CLFS_SOURCES}/${PKG_NAME}/"

patch -Np1 -i "${SOURCES}/shutdown.patch"

make DESTDIR="${FAKEROOT}" install-bootscripts

install -dv "${FAKEROOT}/etc/init.d"

ln -svf ../rc.d/startup "${FAKEROOT}/etc/init.d/rcS"
ln -svf halt "${FAKEROOT}/sbin/shutdown"
ln -svf reboot "${FAKEROOT}/sbin/restart"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}"

exit 0

