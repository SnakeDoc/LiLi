#!/bin/bash

. settings/config

# Clean system directory

rm -rf ${CLFS_TARGETFS}/*
chown -Rf ${USER}:${USER} ${CLFS_TARGETFS}

exit 0

