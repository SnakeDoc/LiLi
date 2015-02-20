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
mv -v "${FAKEROOT}/usr/bin/"{dd,df,echo,false,ln,ls,mkdir,mknod} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/"{mv,pwd,rm,rmdir,stty,true,uname} "${FAKEROOT}/bin"
mv -v "${FAKEROOT}/usr/bin/chroot" "${FAKEROOT}/usr/sbin"

# install some bash config files specific to coreutils
mkdir -pv "${FAKEROOT}/etc/profile.d"

# /etc/profile.d/colorls.sh
cat > "${FAKEROOT}/etc/profile.d/colorls.sh" << "EOF"
# color-ls initialization

#when USER_LS_COLORS defined do not override user LS_COLORS, but use them.
if [ -z "$USER_LS_COLORS" ]; then

  alias ll='ls -l' 2>/dev/null
  alias l.='ls -d .*' 2>/dev/null


  # Skip the rest for noninteractive shells.
  [ -z "$PS1" ] && return

  COLORS=

  for colors in "$HOME/.dir_colors.$TERM" "$HOME/.dircolors.$TERM" \
      "$HOME/.dir_colors" "$HOME/.dircolors"; do
    [ -e "$colors" ] && COLORS="$colors" && break
  done

  [ -z "$COLORS" ] && [ -e "/etc/DIR_COLORS.256color" ] && \
      [ "x`tty -s && tput colors 2>/dev/null`" = "x256" ] && \
      COLORS="/etc/DIR_COLORS.256color"

  if [ -z "$COLORS" ]; then
    for colors in "/etc/DIR_COLORS.$TERM" "/etc/DIR_COLORS" ; do
      [ -e "$colors" ] && COLORS="$colors" && break
    done
  fi

  # Existence of $COLORS already checked above.
  [ -n "$COLORS" ] || return

  eval "`dircolors --sh "$COLORS" 2>/dev/null`"
  [ -z "$LS_COLORS" ] && return
  grep -qi "^COLOR.*none" $COLORS >/dev/null 2>/dev/null && return
fi

alias ll='ls -l --color=auto' 2>/dev/null
alias l.='ls -d .* --color=auto' 2>/dev/null
alias ls='ls --color=auto' 2>/dev/null
EOF

# /etc/profile.d/which2.sh
cat > "${FAKEROOT}/etc/profile.d/which2.sh" << "EOF"
# Initialization script for bash and sh

# export AFS if you are in AFS environment
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
EOF

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

