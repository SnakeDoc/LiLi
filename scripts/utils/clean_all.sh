#!/bin/bash

set -e
set -u

. settings/config

# Clean all directories

${SCRIPTS}/utils/clean_sources.sh
${SCRIPTS}/utils/clean_compiler.sh
${SCRIPTS}/utils/clean_system.sh
${SCRIPTS}/utils/clean_packages.sh

exit 0

