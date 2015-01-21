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

PKG_NAME="binutils"
PKG_VERSION="2.25"
PKG_URL_TYPE="http"
PKG_URL="http://ftp.gnu.org/gnu/binutils/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS=""
PKG_SECTION="devel"

PKG_CONFIGURE_OPTS=(--prefix="${CLFS_TOOLS}"
                    --target="${CLFS_TARGET}"
                    --with-sysroot="${CLFS_TOOLS}/${CLFS_TARGET}"
                    --disable-nls
                    --disable-multilib
                    --disable-werror)
