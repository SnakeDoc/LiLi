#!/bin/bash

# Fakeroot utils

. settings/functions
. settings/config

setup_fakeroot() {

    if [ -e "${FAKEROOT}" ]; then
        echo "Cleaning fakeroot"
        cd "${BUILD_ROOT}/"
        rm -rf "${FAKEROOT}/"
    fi

    echo "Setting up fakeroot"

    mkdir -pv ${FAKEROOT}
    
    ${SYSTEM_SCRIPTS}/rootfs.sh
    check_status

}

package_fakeroot() {

    local PACKAGE_NAME=$1

    # make sure directory is present
    mkdir -pv "${FAKEROOT_PKGDIR}"

    cd "${FAKEROOT}/"
    tar -pzcvf "${FAKEROOT_PKGDIR}/${PACKAGE_NAME}.tar.gz" ./

    cd "${CLFS}/"

}

# when run by itself, this script
#    will just setup the fakeroot directory
setup_fakeroot

