#!/bin/bash

# Build the LiLi System

. settings/functions
. settings/config

build_system() {
    while IFS=',' read -ra ADDR; do
        for subpkg in "${ADDR[@]}"; do
            pkg_dir=`find ${PACKAGES}/ -type d -name ${subpkg}`

            echo "Processing package ${subpkg} from location ${pkg_dir}"
            . ${pkg_dir}/package.mk
            echo "Building package: ${PKG_NAME}"
            build_package ${PKG_NAME}
        done
    done <<< $1
}

error() {
    echo "Error building $1: failed on $2"
    echo "Error Code: $3"
    echo -n "Building System: "
    show_status ${FAIL}
    exit $3
}

execute_script() {
    echo "Executing script: $2"
    ${SYSTEM_SCRIPTS}/$2
    RETURN=$?
    if [ ${RETURN} -ne ${OK} ]
    then
        error $1 $2 ${RETURN}
    fi
}

build_package() {
    local RETURN=0
    case "$1" in
        system)
            declare -a scripts=(\
                "rootfs.sh" \
                "base_files.sh" \
                "busybox.sh" \
                "iana-etc.sh" \
                "kernel.sh" \
                "firmware.sh" \
                "bootscripts.sh" \
                "network.sh" \
                "dropbear.sh" \
                "wireless_tools.sh" \
                "e2fsprogs.sh" \
                "shared_libs.sh" \
                "finalize.sh" \
                "archive.sh"
            )

            for SCRIPT_NAME in "${scripts[@]}"; do
                execute_script $1 ${SCRIPT_NAME}
                echo ""
                echo -n "${SCRIPT_NAME}"
                show_status ${OK}
                echo ""
            done
            # TODO package system into tarball
            echo ""
            echo -n "Build System: "
            show_status ${OK}
            ;;
        *)
            echo "$1 is not supported!"
            exit 1
    esac
}

# system package
. ${SYSTEM_DEPS}/package.mk

build_system ${PKG_DEPENDS}

# finish script
echo ""
echo -n "System Build Complete: "
show_status ${OK}
echo ""

