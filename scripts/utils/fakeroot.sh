#!/bin/bash

# Fakeroot utils

. settings/functions
. settings/config

setup_fakeroot() {

    echo "Setting up fakeroot"
    if [ -e "${FAKEROOT}" ]; then
        echo "Removing old fakeroot"
        rm -rf "${FAKEROOT}"
    fi

    mkdir -pv ${FAKEROOT}

    ${SYSTEM_SCRIPTS}/rootfs.sh
    check_status

}

package_fakeroot() {

    local PACKAGE_NAME=$1

    cd ${FAKEROOT}/
    tar -pczf "${FAKEROOT_PKGDIR}/${PACKAGE_NAME}.tar.gz" ./

}

