#!/bin/bash

# iana-etc

. settings/functions
. settings/config
. settings/toolchain

pkg_dir=$(locate_package "iana-etc")

. ${pkg_dir}/package.mk

pkg_error() {
    error "Error on package ${PKG_NAME}" "iana-etc.sh" $1
}

cd ${CLFS_SOURCES}/
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]
then
    wget --read-timeout=20 ${PKG_URL}
fi

cd ${CLFS_SOURCES}/
# cleanup
if [ -d ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION} ]
then
    rm -rf ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}
fi

# business time
cd ${CLFS_SOURCES}/
tar -xvjf ${PKG_NAME}-${PKG_VERSION}.tar.bz2

cd ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/

# patch source
patch -Np1 -i ${SOURCES}/${PKG_NAME}-${PKG_VERSION}.patch
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

make get
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

make STRIP=yes
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

# cleanup
cd ${CLFS_SOURCES}/
rm -rf ${PKG_NAME}-${PKG_VERSION}

exit ${RESPONSE}

