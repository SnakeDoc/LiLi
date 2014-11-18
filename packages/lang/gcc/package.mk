################################################################################
#   Copyright (c) 2014 Jason Sipula                                            #
#                                                                              #
#   Licensed under the Apache License, Version 2.0 (the "License");            #
#   you may not use this file except in compliance with the License.           #
#   You may obtain a copy of the License at                                    #
#                                                                              #
#       http://www.apache.org/licenses/LICENSE-2.0                             #
#                                                                              #
#   Unless required by applicable law or agreed to in writing, software        #
#   distributed under the License is distributed on an "AS IS" BASIS,          #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#   See the License for the specific language governing permissions and        #
#   limitations under the License.                                             #
################################################################################

PKG_NAME="gcc"
PKG_VERSION="4.8.2"
PKG_URL_TYPE="http"
PKG_URL="ftp://gcc.gnu.org/pub/gcc/releases/${PKG_NAME}-${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS="linux,binutils,gmp,mpfr,mpc,musl-libc"
PKG_SECTION="lang"

STATIC_CONFIGURE_OPTS=(--prefix="${CLFS_TOOLS}"
                       --build="${CLFS_HOST}"
                       --host="${CLFS_HOST}"
                       --target="${CLFS_TARGET}"
                       --with-sysroot="${CLFS_TOOLS}/${CLFS_TARGET}"
                       --disable-nls
                       --disable-shared
                       --without-headers
                       --with-newlib
                       --disable-decimal-float
                       --disable-libgomp
                       --disable-libmudflap
                       --disable-libssp
                       --disable-libatomic
                       --disable-libquadmath
                       --disable-threads
                       --enable-languages=c
                       --disable-multilib
                       --with-mpfr-include="${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/mpfr/src"
                       --with-mpfr-lib="${CLFS_SOURCES}/${PKG_NAME}-build/mpfr/src/.libs"
                       --with-arch="${CLFS_ARM_ARCH}"
                       --with-float="${CLFS_FLOAT}"
                       --with-fpu="${CLFS_FPU}"
                       --with-abi="${CLFS_ABI}"
                       --with-mode="${CLFS_ARCH}")

PKG_CONFIGURE_OPTS=(--prefix="${CLFS_TOOLS}"
                    --build="${CLFS_HOST}"
                    --target="${CLFS_TARGET}"
                    --host="${CLFS_HOST}"
                    --with-sysroot="${CLFS_TOOLS}/${CLFS_TARGET}"
                    --disable-nls
                    --enable-languages=c,c++
                    --enable-c99
                    --enable-long-long
                    --disable-libmudflap
                    --disable-multilib
                    --with-mpfr-include="${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/mpfr/src"
                    --with-mpfr-lib="${CLFS_SOURCES}/${PKG_NAME}-build/mpfr/src/.libs"
                    --with-arch="${CLFS_ARM_ARCH}"
                    --with-float="${CLFS_FLOAT}"
                    --with-fpu="${CLFS_FPU}"
                    --with-abi="${CLFS_ABI}"
                    --with-mode="${CLFS_ARCH}")

