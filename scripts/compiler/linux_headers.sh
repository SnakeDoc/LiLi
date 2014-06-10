#!/bin/bash

# Linux Headers

. settings/functions
. settings/config

pkg_dir=$(locate_package "linux")

. ${pkg_dir}/package.mk

pkg_error() {
    error "Error on package ${PKG_NAME}" "linux_headers.sh" $1
}

cd ${CLFS_SOURCES}/
if [ ! -d ${CLFS_SOURCES}/${PKG_NAME} ]
then
    git clone --depth 1 ${PKG_URL} --progress
fi

cd ${CLFS_SOURCES}/${PKG_NAME}/

# make sure source is clean
make mrproper
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

# ensure we have the latest source and correct version
git fetch
cur_branch=$(git symbolic-ref --short -q HEAD)
if [ ${cur_branch} != "rpi-${KERNEL_VERSION}.y" ]
then
    git reset --hard origin/${cur_branch}
    git checkout rpi-${KERNEL_VERSION}.y
fi
git reset --hard origin/rpi-${KERNEL_VERSION}.y

# make sure source is clean
make mrproper
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

# start headers build
make ARCH=${CLFS_ARCH} headers_check
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

# install the headers
make ARCH=${CLFS_ARCH} INSTALL_HDR_PATH=${CLFS_TOOLS}/${CLFS_TARGET} headers_install
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

exit ${RESPONSE}
