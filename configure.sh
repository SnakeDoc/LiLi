#!/bin/bash

# Configure script to check host requirements

display_yes() {
    echo "yes"
}

display_no() {
    echo "no"
}

#####################
# Required Programs #
#####################
REQ_PROGS=("bash"
           "binutils"
           "bzip2"
           "coreutils"
           "diff"
           "find"
           "gawk"
           "gcc"
           "g++"
           "glibc"
           "grep"
           "gzip"
           "make"
           "patch"
           "sed"
           "sudo"
           "tar"
           "makeinfo"
           "bc"
           "wget"
           "git"
           "parted"
           "losetup"
           "mkfs.vfat"
           "mke2fs"
           "e2fsck"
           "uuidgen"
           "tune2fs")

echo ""
echo "Verifying host requirements..."
echo ""

for prog in "${REQ_PROGS[@]}"; do
    case "${prog}" in
        binutils)
            DISCARD="$(ld --version)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "0" ]; then
                display_no
                exit "${RESPONSE}"
            else
                display_yes
            fi
            ;;
        glibc)
            DISCARD="$(ldd $(which ${SHELL}) | grep libc.so)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "0" ]; then
                display_no
                exit "${RESPONSE}"
            else
                display_yes
            fi
            ;;
        coreutils)
            DISCARD="$(chown --version)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "0" ]; then
                display_no
                exit "${RESPONSE}"
            else
                display_yes
            fi
            ;;
        bzip2)
            DISCARD="$(${prog} --version 2>&1 < /dev/null)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "0" ]; then
                display_no
                exit -1
            else
                display_yes
            fi
            ;;
        tune2fs | mke2fs | mkfs.vfat)
            DISCARD="$(${prog} --version &> /dev/null)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "1" ]; then
                display_no
                exit -1
            else
                display_yes
            fi
            ;;
        e2fsck)
            DISCARD="$(${prog} --version &> /dev/null)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "16" ]; then
                display_no
                exit -1
            else
                display_yes
            fi
            ;;
        uuidgen | sudo | losetup)
            DISCARD="$(${prog} --version &> /dev/null)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "0" ] && [ "${RESPONSE}" != "1" ]; then
                display_no
                exit -1
            else
                display_yes
            fi
            ;;
        *)
            DISCARD="$(${prog} --version)"
            RESPONSE="${?}"
            echo -n "checking for ${prog}... "
            if [ "${RESPONSE}" != "0" ]; then
                display_no
                exit -1
            else
                display_yes
            fi
            ;;
    esac
done

echo ""
echo -n "Host requirements... "
echo "[  OK  ]"
echo ""

exit 0 # normal exit
