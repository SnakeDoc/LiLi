#!/bin/bash

# Finalize root filesystem

. settings/functions
. settings/config
. settings/toolchain

pkg_error() {
    error "Error on package finalize" "finalize.sh" $1
}

fail_on_error() {
    if [ $1 -ne 0 ]
    then
        pkg_error $1
        exit $1
    fi
}

echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~          WARNING !!           ~"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "This script requires sudo access!"
echo ""

echo "Changing ownership of filesystem to root"
chown -Rv root:root ${CLFS_TARGETFS}
fail_on_error $?

echo "Chaning group of utmp and lastlog log files"
chgrp -v 13 ${CLFS_TARGETFS}/var/run/utmp
fail_on_error $?
chgrp -v 13 ${CLFS_TARGETFS}/var/log/lastlog
fail_on_error $?

exit 0 # normal exit

