#!/bin/bash

set -e
set -u

. settings/config

# Clean system directory

rm -rf ${CLFS_TARGETFS}/*
chown -Rf ${USER}:${USER} ${CLFS_TARGETFS}

rm -rf ${FAKEROOT}/*

exit 0

