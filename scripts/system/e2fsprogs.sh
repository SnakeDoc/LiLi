#!/bin/bash

# Install e2fsprogs

. ${SETTINGS}/toolchain
. ${SETTINGS}/functions

pkg_dir=$(locate_package "e2fsprogs")

. ${pkg_dir}/package.mk

pkg_error() {
    error "Error on package ${PKG_NAME}" "e2fsprogs.sh" $1
}

cd ${CLFS_SOURCES}/
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.gz" ]
then
    wget --read-timeout=20 ${PKG_URL}
fi

cd ${CLFS_SOURCES}/
# cleanup
if [ -d ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION} ]
then
    rm -rf ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}
fi

if [ -d ${CLFS_SOURCES}/${PKG_NAME}-build ]
then
    rm -rf ${CLFS_SOURCES}/${PKG_NAME}-build
fi

# business time
cd ${CLFS_SOURCES}/
tar -zxvf ${PKG_NAME}-${PKG_VERSION}.tar.gz

cd ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/

# patch source
patch -Np1 -i ${SOURCES}/${PKG_NAME}-${PKG_VERSION}.patch
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

# setup build
mkdir -v ${CLFS_SOURCES}/${PKG_NAME}-build
cd ${CLFS_SOURCES}/${PKG_NAME}-build/

CC="${CC} -Os" ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/configure ${PKG_CONFIGURE_OPTS}
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

make
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

make DESTDIR=${FAKEROOT} install
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

make DESTDIR=${FAKEROOT} install-libs
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

# cleanup
cd ${CLFS_SOURCES}/
rm -rf ${PKG_NAME}-${PKG_VERSION}
rm -rf ${PKG_NAME}-build

exit ${RESPONSE}

