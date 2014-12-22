#!/bin/bash

# Fakeroot utils

set -e
set -u

. settings/config
. scripts/utils/utils.sh

reset_fakeroot() {

    echo "Resetting fakeroot"

    pre="$(pwd)"

    if [ -e "${FAKEROOT}" ]; then
        cd "${BUILD_ROOT}/"
        rm -rf "${FAKEROOT}/"
    fi

    mkdir -pv ${FAKEROOT}
    
    cd "${pre}"

}

package_fakeroot() {

    local PACKAGE_NAME=$1

    # make sure directory is present
    mkdir -pv "${FAKEROOT_PKGDIR}"

    cd "${FAKEROOT}/"
    tar -pzcvf "${FAKEROOT_PKGDIR}/${PACKAGE_NAME}.tar.gz" ./

    cd "${CLFS}/"

}

