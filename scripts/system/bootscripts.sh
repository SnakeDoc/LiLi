#!/bin/bash

# Bootscripts

pkg_dir=$(locate_package "bootscripts")

. ${pkg_dir}/package.mk

pkg_error() {
    error "Error on package ${PKG_NAME}" "bootscripts.sh" $1
}

cd ${CLFS_SOURCES}/
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}.tar.gz" ]
then
    wget --read-timeout=20 -O ${PKG_NAME}.tar.gz "${PKG_URL}"
fi

cd ${CLFS_SOURCES}/
# cleanup
if [ -d ${CLFS_SOURCES}/${PKG_NAME} ]
then
    rm -rf ${CLFS_SOURCES}/${PKG_NAME}
fi

# now get started
cd ${CLFS_SOURCES}/
tar -zxvf ${PKG_NAME}.tar.gz

cd ${CLFS_SOURCES}/${PKG_NAME}/

make DESTDIR=${FAKEROOT} install-bootscripts
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

install -dv ${FAKEROOT}/etc/init.d
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

ln -svf ../rc.d/startup ${FAKEROOT}/etc/init.d/rcS
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

# cleanup
cd ${CLFS_SOURCES}/
rm -rf ${PKG_NAME}

exit ${RESPONSE}

