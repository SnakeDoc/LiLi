#!/bin/bash

# Install shared libs

set -e
set -u

echo "Installing shared libraries"

cp -vP "${CLFS_TOOLS}/${CLFS_TARGET}/lib/*.so*" "${FAKEROOT}/lib/"

exit 0

