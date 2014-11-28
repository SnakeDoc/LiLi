#!/bin/bash

# Install shared libs

pkg_error() {
    error "Error on package base_files" "shared_libs.sh" "${1}"
}

fail_on_error() {
    if [ "${1}" != "0" ];     then
        pkg_error "${1}"
        exit "${1}"
    fi
}

echo "Installing shared libraries"

cp -vP "${CLFS_TOOLS}/${CLFS_TARGET}/lib/*.so*" "${FAKEROOT}/lib/"
fail_on_error "${?}"

exit 0 # normal exit

