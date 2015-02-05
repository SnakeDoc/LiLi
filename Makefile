# Makefile for LiLi system

all: release

release: image
	./scripts/utils/archive.sh

system: clean-system
	./scripts/system.sh

unpack:
	./scripts/utils/unpack.sh

image: system
	./scripts/utils/mkimage.sh

clean-sources:
	./scripts/utils/clean_sources.sh

clean-system:
	./scripts/utils/clean_system.sh

clean-packages:
	./scripts/utils/clean_packages.sh

clean-all:
	./scripts/utils/clean_all.sh
