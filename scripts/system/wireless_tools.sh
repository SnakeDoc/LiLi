#!/bin/bash

# Install wireless tools

#. ${SETTINGS}/toolchain
#. ${SETTINGS}/functions

pkg_dir=$(locate_package "wireless_tools")

. ${pkg_dir}/package.mk

pkg_error() {
    error "Error on package ${PKG_NAME}" "wireless_tools.sh" $1
}

cd ${CLFS_SOURCES}/
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION}.tar.gz" ]
then
    wget --read-timeout=20 ${PKG_URL}
fi

cd ${CLFS_SOURCES}/
# cleanup
if [ -d ${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION} ]
then
    rm -rf ${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION}
fi

# business time
cd ${CLFS_SOURCES}/
tar -zxvf ${PKG_NAME}.${PKG_VERSION}.tar.gz

cd ${CLFS_SOURCES}/${PKG_NAME}.${PKG_VERSION}/

sed -i "s|gcc|${CC}|g" Makefile
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

sed -i "s|\ ar|\ ${AR}|g" Makefile
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

sed -i "s|\ ranlib|\ ${RANLIB}|g" Makefile
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

make PREFIX=${FAKEROOT}/usr
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

make install PREFIX=${FAKEROOT}/usr
RESPONSE=$?
if [ ${RESPONSE} -ne 0 ]
then
    pkg_error ${RESPONSE}
    exit ${RESPONSE}
fi

# cleanup
cd ${CLFS_SOURCES}/
rm -rf ${PKG_NAME}.${PKG_VERSION}

exit ${RESPONSE}

