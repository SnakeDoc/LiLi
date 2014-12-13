# Makefile for LiLi

ROTATE_LOG:=$(shell bash ./scripts/utils/rotate_log.sh)

all: clean-all compiler system unpack

compiler: clean-compiler
	./scripts/compiler.sh

system: clean-system
	./scripts/system.sh

unpack:
	./scripts/utils/unpack.sh

image: clean-packages clean-system system
	./scripts/utils/mkimage.sh

clean-sources:
	./scripts/utils/clean_sources.sh

clean-compiler:
	./scripts/utils/clean_compiler.sh

clean-system:
	./scripts/utils/clean_system.sh

clean-packages:
	./scripts/utils/clean_packages.sh

clean-all:
	./scripts/utils/clean_all.sh
