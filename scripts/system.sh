#!/bin/bash

# Build the LiLi System

set -e
set -u

. settings/config
. settings/toolchain
. scripts/utils/utils.sh
. scripts/utils/fakeroot.sh

build_base_packages() {
    packages=("rootfs.sh"
              "base_files.sh"
              "busybox.sh"
              "iana-etc.sh"
              "kernel.sh"
              "bcm2835_firmware.sh"
              "bootscripts.sh"
              "network.sh"
              "dropbear.sh"
              "wireless_tools.sh"
              "e2fsprogs.sh"
              "musl-libc.sh"
              "zlib.sh")

    for package in "${packages[@]}"; do
        setup_fakeroot
        "${SYSTEM_SCRIPTS}/${package}"
        package_fakeroot "$(echo ${package} | cut -d "." -f 1)"
        echo ""
        echo -n "${package}"
        show_status "${OK}"
        echo ""
    done
}

build_all_packages() {
    true;
}

######################################
#           CROSS COMPILER           #
######################################
# ensure we have a cross compiler handy
#  ... we prefer the LiLiCompiler ...
VERIFY="$(${CC} --version)"
if [ "${?}" != "0" ] && [ "$(echo ${VERIFY} | cut -d ' ' -f 1)" != "${CC}" ]; then
    cd "${CLFS_SOURCES}/"
    if [ ! -d "${CLFS_SOURCES}/LiLiCompiler" ]; then
        git clone --depth 1 https://github.com/SnakeDoc/LiLiCompiler --progress
    fi

    cd "${CLFS_SOURCES}/LiLiCompiler/"

    # make sure we have the lastest compiler source
    #  and are on the 'master' branch
    git fetch
    cur_branch="$(git symbolic-ref --short -q HEAD)"
    echo "Current Branch: ${cur_branch}"
    echo ""
    if [ "${cur_branch}" != "master" ]; then
        git reset --hard "origin/${cur_branch}"
        git checkout master
    fi
    git reset --hard origin/master

    # compile the cross compiler
    cd "${CLFS_SOURCES}/LiLiCompiler/"
    make compiler
    sync
fi
######################################
#         END CROSS COMPILER         #
######################################

######################################
#     BUILD BASE SYSTEM PACKAGES     #
######################################
build_base_packages
######################################
#   END BUILD BASE SYSTEM PACKAGES   #
######################################

echo ""
echo -n "System Package Build: "
show_status "${OK}"
echo ""

exit 0

