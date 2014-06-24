#!/bin/bash

. settings/config

# Clean all directories

${SCRIPTS}/utils/clean_sources.sh
${SCRIPTS}/utils/clean_compiler.sh
${SCRIPTS}/utils/clean_system.sh

exit 0

