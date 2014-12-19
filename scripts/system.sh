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
    
}

echo ""
echo -n "System Package Build: "
show_status "${OK}"
echo ""

