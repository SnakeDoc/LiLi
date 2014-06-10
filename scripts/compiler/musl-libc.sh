#!/bin/bash

# musl-libc

. settings/functions
. settings/config

pkg_dir=$(locate_package "musl-libc")

. ${pkg_dir}/package.mk

pkg_error() {
    error "Error on package ${PKG_NAME}" "musl-libc.sh" $1
}

cd ${CLFS_SOURCES}/
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.gz" ]
then
    wget --read-timeout=20 ${PKG_URL}
fi

cd ${CLFS_SOURCES}/
# make sure things are clean
if [ -d ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION} ]
then
    rm -rf ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}
fi

# business time
cd ${CLFS_SOURCES}/
tar -zxvf ${PKG_NAME}-${PKG_VERSION}.tar.gz

cd ${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/

CC=${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc ./configure ${PKG_CONFIGURE_OPTS}
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi
  
CC=${CLFS_ENV_PATH}/${CLFS_TARGET}-gcc make
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

DESTDIR=${CLFS_TOOLS}/${CLFS_TARGET} make install
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
