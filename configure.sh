#!/bin/bash

# Configure script to check host requirements

. settings/config
. scripts/utils/utils.sh

# Return Status Code
#   (normal exit is zero)
RETURN=0

#####################
# Required versions #
#####################
BASH_VER="4.0"
BINUTILS_VER="2.20"
BZIP2_VER="1.0.5"
COREUTILS_VER="8.1"
DIFF_VER="3.0"
FIND_VER="4.4.0"
GAWK_VER="3.1.0"
GCC_VER="4.4.0"
CPP_VER="4.4.0"
GLIBC_VER="2.11"
GREP_VER="2.6"
GZIP_VER="1.3"
MAKE_VER="3.81"
PATCH_VER="2.6.0"
SED_VER="4.2.1"
SUDO_VER="1.7.4"
TAR_VER="1.23"
MAKEINFO_VER="4.13"
BC_VER="1.00.00"
WGET_VER="1.0"
GIT_VER="1.8.0"

#yum groupinstall "Development tools" -y
#yum install gcc-c++ -y
#yum install texinfo bc patch -y

echo ""
echo "Verifying host requirements..."
echo ""

#########################
# BC Version
echo -n "bc version: "
TMP=$(bc --version | head -n1 | cut -d " " -f 2)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${BC_VER} | cut -d "." -f 1)
BTMP2=$(echo ${BC_VER} | cut -d "." -f 2)
BTMP3=$(echo ${BC_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: bc"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Bash Version
echo -n "bash version: "
TMP=$(bash --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
TMP=$(echo ${TMP} | cut -d "." -f 1-2)
if [ "$(bc <<< "${TMP} >= ${BASH_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: bash"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Binutils Version
echo -n "binutils version: "
TMP=$(ld --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
TMP=$(echo ${TMP} | cut -d "." -f 1-2)
if [ "$(bc <<< "${TMP} >= ${BINUTILS_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: binutils"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# BZip2 Version
echo -n "bzip2 version: "
TMP=$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d " " -f 8 | cut -d "," -f 1)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${BZIP2_VER} | cut -d "." -f 1)
BTMP2=$(echo ${BZIP2_VER} | cut -d "." -f 2)
BTMP3=$(echo ${BZIP2_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: bzip2"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Coreutils Version
echo -n "coreutils version: "
TMP=$(chown --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${COREUTILS_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: coreutils"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Diff Version
echo -n "diff version: "
TMP=$(diff --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${DIFF_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: diff"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Find Version
echo -n "find version: "
TMP=$(find --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${FIND_VER} | cut -d "." -f 1)
BTMP2=$(echo ${FIND_VER} | cut -d "." -f 2)
BTMP3=$(echo ${FIND_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif  [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: find"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Gawk Version
echo -n "gawk version: "
TMP=$(gawk --version | head -n1 | cut -d " " -f 3 | cut -d "," -f 1)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${GAWK_VER} | cut -d "." -f 1)
BTMP2=$(echo ${GAWK_VER} | cut -d "." -f 2)
BTMP3=$(echo ${GAWK_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: gawk"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# GCC Version
echo -n "gcc version: "
TMP=$(gcc -dumpversion)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${GCC_VER} | cut -d "." -f 1)
BTMP2=$(echo ${GCC_VER} | cut -d "." -f 2)
BTMP3=$(echo ${GCC_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: gcc"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# G++ Version
echo -n "g++ version: "
TMP=$(g++ -dumpversion)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${CPP_VER} | cut -d "." -f 1)
BTMP2=$(echo ${CPP_VER} | cut -d "." -f 2)
BTMP3=$(echo ${CPP_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: g++"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Glibc Version
echo -n "glibc version: "
TMP=$(ldd $(which ${SHELL}) | grep libc.so | cut -d ' ' -f 3 | \
                ${SHELL} | head -n 1 | cut -d ' ' -f 9 | cut -d ',' -f 1)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${GLIBC_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: glibc"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Grep Version
#  Note: grep's versions are weird
#   2.6 is < 2.18 (current version)
echo -n "grep version: "
TMP=$(grep --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
BTMP1=$(echo ${GREP_VER} | cut -d "." -f 1)
BTMP2=$(echo ${GREP_VER} | cut -d "." -f 2)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: grep"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# GZip Version
echo -n "gzip version: "
TMP=$(gzip --version | head -n1 | cut -d " " -f 2)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${GZIP_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: gzip"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Make Version
echo -n "make version: "
TMP=$(make --version | head -n1 | cut -d " " -f 3)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${MAKE_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: make"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Patch Version
echo -n "patch version: "
TMP=$(patch --version | head -n1 | cut -d " " -f 3)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${PATCH_VER} | cut -d "." -f 1)
BTMP2=$(echo ${PATCH_VER} | cut -d "." -f 2)
BTMP3=$(echo ${PATCH_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: patch"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Sed Version
echo -n "sed version: "
TMP=$(sed --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${SED_VER} | cut -d "." -f 1)
BTMP2=$(echo ${SED_VER} | cut -d "." -f 2)
BTMP3=$(echo ${SED_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: sed"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Sudo Version
echo -n "sudo version: "
TMP=$(sudo -V | head -n1 | cut -d " " -f 3)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${SUDO_VER} | cut -d "." -f 1)
BTMP2=$(echo ${SUDO_VER} | cut -d "." -f 2)
BTMP3=$(echo ${SUDO_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: sudo"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Tar Version
echo -n "tar version: "
TMP=$(tar --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${TAR_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: tar"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Makeinfo Version
echo -n "makeinfo version: "
TMP=$(makeinfo --version | head -n1 | cut -d " " -f 4)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${MAKEINFO_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: makeinfo"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Wget Version
echo -n "wget version: "
TMP=$(wget --version | head -n1 | cut -d " " -f 3)
echo -n ${TMP}
if [ "$(bc <<< "${TMP} >= ${WGET_VER}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: wget"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

#########################
# Git Version
echo -n "git version: "
TMP=$(git --version | cut -d " " -f 3)
echo -n ${TMP}
TMP1=$(echo ${TMP} | cut -d "." -f 1)
TMP2=$(echo ${TMP} | cut -d "." -f 2)
TMP3=$(echo ${TMP} | cut -d "." -f 3)
BTMP1=$(echo ${GIT_VER} | cut -d "." -f 1)
BTMP2=$(echo ${GIT_VER} | cut -d "." -f 2)
BTMP3=$(echo ${GIT_VER} | cut -d "." -f 3)
if [ "$(bc <<< "${TMP1} >= ${BTMP1}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP2} >= ${BTMP2}")" = 1 ]
then
    show_status ${OK}
elif [ "$(bc <<< "${TMP3} >= ${BTMP3}")" = 1 ]
then
    show_status ${OK}
else
    show_status ${FAIL}
    echo ""
    echo "Please install package: git"
    echo ""
    RETURN=1
    exit ${RETURN}
fi
#########################

echo ""
echo -n "Host requirements... "
show_status ${OK}
echo ""

exit ${RETURN}
