# Makefile for LiLi

LOG="runtime.log"

ROTATE_LOG:=$(shell bash ./scripts/utils/rotate_log.sh)

all: clean-all compiler system

compiler: clean-compiler
	/bin/bash -c "time ./scripts/compiler.sh 2>&1 | tee ${LOG}"

system: clean-system
	/bin/bash -c "time ./scripts/system.sh 2>&1 | tee ${LOG}"

clean-sources:
	/bin/bash -c "time ./scripts/utils/clean_sources.sh"

clean-compiler:
	/bin/bash -c "time ./scripts/utils/clean_compiler.sh"

clean-system:
	/bin/bash -c "time ./scripts/utils/clean_system.sh"

clean-all:
	/bin/bash -c "time ./scripts/utils/clean_all.sh"
