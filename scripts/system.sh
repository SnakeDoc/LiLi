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
        reset_fakeroot
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
use_toolchain_env
VERIFY="$(${CC} --version | awk 'NR==1{print $1}')" || true
if [ "${VERIFY}" != "$(basename ${CC})" ]; then
    # use the system env vars for gcc, etc...
    use_system_env
    mkdir -pv "${CLFS_SOURCES}"
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

    # copy the cross compiler to our working directory
    cp -R "${CLFS_SOURCES}/LiLiCompiler/target/cross-tools" "${CLFS}/"
    sync

fi
######################################
#         END CROSS COMPILER         #
######################################

# busybox and musl-libc seem to have some compatibility issues.
# busybox makes excessive use of linux kernel headers, which
# have a tendency to clash with userspace.
# patch the kernel headers used during the build so that we can
# work around most of this ugliness.
OLD_PWD="$(pwd)"
cd "${CLFS_TOOLS}/${CLFS_TARGET}/"
patch -Np1 -i "${SOURCES}/busybox-musl-kernel-compatibility-1.patch" || true
patch -Np1 -i "${SOURCES}/busybox-musl-kernel-compatibility-2.patch" || true
patch -Np1 -i "${SOURCES}/busybox-musl-kernel-compatibility-3.patch" || true
patch -Np1 -i "${SOURCES}/busybox-musl-kernel-compatibility-4.patch" || true
patch -Np1 -i "${SOURCES}/busybox-musl-kernel-compatibility-5.patch" || true
cd "${OLD_PWD}"

######################################
#     BUILD BASE SYSTEM PACKAGES     #
######################################
use_toolchain_env
build_base_packages
######################################
#   END BUILD BASE SYSTEM PACKAGES   #
######################################

echo ""
echo -n "System Package Build: "
show_status "${OK}"
echo ""

exit 0

