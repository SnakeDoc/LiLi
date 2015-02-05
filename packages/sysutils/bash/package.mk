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

PKG_NAME="bash"
PKG_VERSION="4.3.30"
PKG_URL_TYPE="https"
PKG_URL="http://ftp.gnu.org/gnu/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS=""
PKG_SECTION="sysutils"

PKG_CONFIGURE_OPTS=(--build="${CLFS_HOST}"
                    --host="${CLFS_TARGET}"
                    --enable-readline
                    --enable-alias
                    --enable-brace-expansion
                    --enable-command-timing
                    --enable-cond-command
                    --enable-history
                    --enable-select
                    --enable-job-control
                    --without-bash-malloc
                    --disable-nls
                    --prefix=/)

