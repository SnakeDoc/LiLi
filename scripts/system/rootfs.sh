#!/bin/bash

# create the rootfs

. ${SETTINGS}/toolchain
. ${SETTINGS}/functions

pkg_error() {
    error "Error on package rootfs" "rootfs.sh" $1
}

fail_on_error() {
    if [ $1 -ne 0 ]
    then
        pkg_error $1
        exit $1
    fi
}

echo "Creating root file system (rootfs)"
mkdir -pv ${FAKEROOT}/{bin,boot,dev,etc,home,lib/{firmware,modules}}
RESPONSE=$?
fail_on_error ${RESPONSE}

mkdir -pv ${FAKEROOT}/{mnt,opt,proc,sbin,srv,sys}
RESPONSE=$?
fail_on_error ${RESPONSE}

mkdir -pv ${FAKEROOT}/var/{cache,lib,local,lock,log,opt,run,spool}
RESPONSE=$?
fail_on_error ${RESPONSE}

install -dv -m 0750 ${FAKEROOT}/root
RESPONSE=$?
fail_on_error ${RESPONSE}

install -dv -m 1777 ${FAKEROOT}/tmp
RESPONSE=$?
fail_on_error ${RESPONSE}

mkdir -pv ${FAKEROOT}/usr/{,local/}{bin,include,lib,sbin,share,src}
RESPONSE=$?
fail_on_error ${RESPONSE}

exit ${RESPONSE}

