#!/bin/bash

# create the rootfs

set -e
set -u

echo "Creating root file system (rootfs)"
mkdir -pv "${FAKEROOT}/"{bin,boot,dev,etc,home,lib/{firmware,modules}}

mkdir -pv "${FAKEROOT}/"{mnt,opt,proc,sbin,srv,sys}

mkdir -pv "${FAKEROOT}/var/"{cache,lib,local,lock,log,opt,run,spool}

install -dv -m 0750 "${FAKEROOT}/root"

install -dv -m 1777 "${FAKEROOT}/tmp"

mkdir -pv "${FAKEROOT}/usr/"{,local/}{bin,include,lib,sbin,share,src}

exit 0

