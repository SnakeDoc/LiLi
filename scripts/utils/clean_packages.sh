#!/bin/bash

set -e
set -u

. settings/config

# Clean packages directory

rm -rf "${FAKEROOT_PKGDIR}"

exit 0

