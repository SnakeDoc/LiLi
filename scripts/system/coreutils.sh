#!/bin/bash

# Coreutils

set -e
set -u

pkg_dir="$(locate_package 'coreutils')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.xf" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# now get started
cd "${CLFS_SOURCES}/"
tar -xvJf "${PKG_NAME}-${PKG_VERSION}.tar.xz"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

patch -Np1 -i "${SOURCES}/coreutils-8.23-uname-1.patch"

FORCE_UNSAFE_CONFIGURE=1 ./configure "${PKG_CONFIGURE_OPTS[@]}"

make

make NON_ROOT_USERNAME=nobody check-root

make RUN_EXPENSIVE=yes -k check || true

# Install to rootfs
DESTDIR="${FAKEROOT}" make install

# move programs to the locates specified by the FHS
mv -v "${FAKEROOT}/usr/bin/"{cat,chgrp,chmod,chown,cp,date} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/"{dd,df,echo,false,hostname,ln,ls,mkdir,mknod} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/"{mv,pwd,rm,rmdir,stty,true,uname} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/chroot" "${FAKEROOT}/usr/sbin"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

