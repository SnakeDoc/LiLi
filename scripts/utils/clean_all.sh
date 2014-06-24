#!/bin/bash

. settings/config

# Clean all directories

${SCRIPTS}/clean_sources.sh
${SCRIPTS}/clean_compiler.sh
${SCRIPTS}/clean_system.sh

exit 0

