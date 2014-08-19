#!/bin/bash

# Fakeroot utils

. settings/functions
. settings/config

setup_fakeroot() {

    if [ -e "${FAKEROOT}" ]; then
        echo "Cleaning fakeroot"
        rm -rf "${FAKEROOT}/*"
    fi

    echo "Setting up fakeroot"

    mkdir -pv ${FAKEROOT}
    
    ${SYSTEM_SCRIPTS}/rootfs.sh
    check_status

}

package_fakeroot() {

    local PACKAGE_NAME=$1
    
    cd "${FAKEROOT}/"
    tar -pzcvf "${FAKEROOT_PKGDIR}/${PACKAGE_NAME}.tar.gz" ./
    
    cd "${CLFS}/"

}


setup_fakeroot
