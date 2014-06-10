# Makefile for LiLi

BUILD_DIR=target
LOG="runtime.log"

ROTATE_LOG:=$(shell bash settings/rotate_log.sh)

all: clean-all compiler system

compiler: clean-compiler
	time ./scripts/compiler.sh 2>&1 | tee ${LOG}

release-compiler: compiler
	

system: clean-system
	time ./scripts/system.sh 2>&1 | tee ${LOG}

clean-sources:
	time rm -rf ${BUILD_DIR}/sources/*

clean-compiler:
	time rm -rf ${BUILD_DIR}/cross-tools/*

clean-system:
	time rm -rf ${BUILD_DIR}/targetfs/*

clean-all:
	time rm -rf ${BUILD_DIR}/*
