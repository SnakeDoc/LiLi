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

PKG_NAME="libnftnl"
PKG_VERSION="1.0.3"
PKG_URL_TYPE="http"
PKG_URL="http://www.netfilter.org/projects/${PKG_NAME}/files/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS=""
PKG_SECTION="network"

PKG_CONFIGURE_OPTS=(--build="${CLFS_HOST}"
                    --host="${CLFS_TARGET}"
                    --prefix=/
                    --datarootdir=/usr/share)

