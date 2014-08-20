#!/bin/bash

# Finalize root filesystem

. ${SETTINGS}/toolchain
. ${SETTINGS}/functions

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
chown -Rv root:root ${FAKEROOT}
fail_on_error $?

echo "Chaning group of utmp and lastlog log files"
chgrp -v 13 ${FAKEROOT}/var/run/utmp
fail_on_error $?
chgrp -v 13 ${FAKEROOT}/var/log/lastlog
fail_on_error $?

exit 0 # normal exit

