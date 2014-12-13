#!/bin/bash

# Raspberry Pi Firmware

set -e
set -u

pkg_dir="$(locate_package 'firmware')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -d "${CLFS_SOURCES}/${PKG_NAME}" ]; then
    git clone --depth 1 "${PKG_URL}" --progress
fi

cd "${CLFS_SOURCES}/${PKG_NAME}/"

# ensure we have the latest source and correct version
git fetch
cur_branch="$(git symbolic-ref --short -q HEAD)"
echo "Current Branch: ${cur_branch}"
echo ""
if [ "${cur_branch}" != "master" ]; then
    git reset --hard origin/master
    git checkout master
fi
git reset --hard origin/master

cd "${CLFS_SOURCES}/${PKG_NAME}/"

# copy firmware to boot directory
echo "Installing firmware"
cp -v "${CLFS_SOURCES}"/firmware/boot/{bootcode.bin,fixup.dat,fixup_cd.dat,start.elf,start_cd.elf} "${FAKEROOT}/boot/"

clear > "${FAKEROOT}/boot/cmdline.txt"
echo "Installing boot variables"
cat > "${FAKEROOT}/boot/cmdline.txt" << "EOF"
dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootdelay=2
EOF

if [ "${OVERCLOCK}" == "1" ]; then
    echo "Overclocking enabled"
    echo "Installing boot/config.txt"
   
    # cleanup
    echo "Remove old boot/config.txt"
    rm -fv "${FAKEROOT}/boot/config.txt"
 
echo "Install new boot/config.txt"
cat > "${FAKEROOT}/boot/config.txt" << EOF
arm_freq="${ARM_FREQ}"
arm_freq_min="${ARM_FREQ_MIN}"
core_freq="${CORE_FREQ}"
core_freq_min="${CORE_FREQ_MIN}"
sdram_freq="${SDRAM_FREQ}"
over_voltage="${OVER_VOLTAGE}"
EOF

elif [ "${OVERCLOCK}" == "0" ]; then
    echo "Overclocking disabled"
    echo "Removing boot/config.txt"
    rm -fv "${FAKEROOT}/boot/config.txt"
fi

exit 0

