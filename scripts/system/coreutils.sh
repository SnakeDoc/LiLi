#!/bin/bash

# Coreutils

set -e
set -u

pkg_dir="$(locate_package 'coreutils')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.xz" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

# download pre-compiled man pages from gentoo
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}-man.tar.xz" ]; then
    wget --read-timeout=60 http://distfiles.gentoo.org/distfiles/coreutils-8.23-man.tar.xz
fi

cd "${CLFS_SOURCES}/"
# cleanup
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# now get started
cd "${CLFS_SOURCES}/"
tar -xvJf "${PKG_NAME}-${PKG_VERSION}.tar.xz"
tar -xvJf "${PKG_NAME}-${PKG_VERSION}-man.tar.xz"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

patch -Np1 -i "${SOURCES}/coreutils-8.23-uname-1.patch"
# manpage patch from gentoo, avoid building man pages
patch -Np1 -i "${SOURCES}/051_all_coreutils-mangen.patch"
cd man && touch hostname.1 && cd ../

FORCE_UNSAFE_CONFIGURE=1 ./configure "${PKG_CONFIGURE_OPTS[@]}"

make

# There are problems running these tests on a
# cross-compile toolchain
#make NON_ROOT_USERNAME=nobody check-root
#make RUN_EXPENSIVE=yes -k check || true

# Install to rootfs
DESTDIR="${FAKEROOT}" make install

# move programs to the locates specified by the FHS
mkdir -pv "${FAKEROOT}/bin"
mkdir -pv "${FAKEROOT}/usr/sbin"
mv -v "${FAKEROOT}/usr/bin/"{cat,chgrp,chmod,chown,cp,date} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/"{dd,df,echo,false,hostname,ln,ls,mkdir,mknod} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/"{mv,pwd,rm,rmdir,stty,true,uname} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/chroot" "${FAKEROOT}/usr/sbin"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

