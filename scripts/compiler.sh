#!/bin/bash

. settings/config
. scripts/utils/utils.sh

build_toolchain() {
    while IFS=',' read -ra ADDR; do
        for subpkg in "${ADDR[@]}"; do
            pkg_dir="$(find ${PACKAGES}/ -type d -name ${subpkg})"

            echo "Processing package ${subpkg} from location ${pkg_dir}"
            . "${pkg_dir}/package.mk"
            echo "building package: ${PKG_NAME}"
            build_package "${PKG_NAME}"

        done
    done <<< "${1}"
}

function error() {
    echo "Error building ${1}: failed on ${2}"
    echo "Error Code: ${3}"
    echo -n "Build Toolchain: "
    show_status "${FAIL}"
    exit "${3}"
}

execute_script() {
    if [ ! "$(${COMPILER_SCRIPTS}/${2})" ]; then
        error "${1}" "${2}" "${?}"
    fi
}

build_package() {
    local RETURN_VAL="0"
    case "${1}" in
        gcc)
            declare -a scripts=(\
                 "linux_headers.sh" \
                 "binutils.sh" \
                 "gcc-static.sh" \
                 "musl-libc.sh" \
                 "gcc.sh" \
                 "musl-libc.sh" \
                 "zlib.sh" \
                 )

            for SCRIPT_NAME in "${scripts[@]}"; do
                execute_script "${1}" "${SCRIPT_NAME}"
                echo ""
                echo -n "${SCRIPT_NAME}"
                show_status "${OK}"
                echo ""
            done
            echo ""
            echo -n "Build Toolchain: "
            show_status "${OK}"
            ;;
        *)
            echo "${1} is not supported!"
            exit 1
    esac
}

# create base directory
mkdir -pv "${CLFS}"
# Make source dir
mkdir -pv "${CLFS_SOURCES}"
# create sysroot directory
mkdir -pv "${CLFS_TOOLS}/${CLFS_TARGET}"
ln -sfv . "${CLFS_TOOLS}/${CLFS_TARGET}/usr"

# toolchain
. "${TOOLCHAIN_DEPS}/package.mk"

build_toolchain "${PKG_DEPENDS}"

# test toolchain
echo ""
echo "Testing toolchain..."
"${COMPILER_SCRIPTS}/test_compiler.sh"
error_on_fail "${?}"

# finish script
echo ""
echo -n "Toolchain Build Complete and Tested: "
show_status "${OK}"
echo ""

