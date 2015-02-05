#!/bin/bash

# iptables 

set -e
set -u

pkg_dir="$(locate_package 'iptables')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -xjvf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

patch -Np1 -i "${SOURCES}/${PKG_NAME}-musl-1.patch"
patch -Np1 -i "${SOURCES}/${PKG_NAME}-musl-2.patch"

./configure "${PKG_CONFIGURE_OPTS[@]}"
  
make

make install DESTDIR="${FAKEROOT}"

# fix some stuff up
ln -svf ../../sbin/xtables-multi "${FAKEROOT}/usr/bin/iptables-xml"
for file in ip4tc ip6tc ipq iptc xtables
do
   mv -v "${FAKEROOT}"/usr/lib/lib${file}.so.* "${FAKEROOT}/lib"
   ln -svf "../../lib/$(readlink ${FAKEROOT}/usr/lib/lib${file}.so)" \
      "${FAKEROOT}/usr/lib/lib${file}.so"
done
# clean files we don't want like static binaries
rm -f "${FAKEROOT}"/usr/lib/*.la
rm -rf "${FAKEROOT}/usr/lib/pkgconfig"

# install init script
mkdir -pv "${FAKEROOT}/etc/rc.d/start"
mkdir -pv "${FAKEROOT}/etc/rc.d/stop"
mkdir -pv "${FAKEROOT}/etc/rc.d/init.d"
cat > "${FAKEROOT}/etc/rc.d/init.d/iptables" << "EOF"
#!/bin/sh
#
# iptables

. /etc/rc.d/init.d/functions

IPTABLES=iptables
IPTABLES_DATA=/etc/sysconfig/$IPTABLES
IPTABLES_FALLBACK_DATA=${IPTABLES_DATA}.fallback

start() {
    # Do not start if there is no config file.
    [ ! -f "$IPTABLES_DATA" ] && return 6

    echo -n $"${IPTABLES}: Applying firewall rules: "

    $IPTABLES-restore $IPTABLES_DATA
    if [ $? -eq 0 ]; then
        echo -en "\\033[65G"
        echo -en "\\033[1;32mOK"
        echo -e "\\033[0;39m"
        echo
    else
        echo -en "\\033[65G"
        echo -en "\\033[1;31mFAIL"
        echo -e "\\033[0;39m"
        echo 
        if [ -f "$IPTABLES_FALLBACK_DATA" ]; then
            echo -n $"${IPTABLES}: Applying firewall fallback rules: "
            $IPTABLES-restore $IPTABLES_FALLBACK_DATA
            if [ $? -eq 0 ]; then
                echo -en "\\033[65G"
                echo -en "\\033[1;32mOK"
                echo -e "\\033[0;39m"
                echo
            else
                echo -en "\\033[65G"
                echo -en "\\033[1;31mFAIL"
                echo -e "\\033[0;39m"
                echo
                return 1
            fi
        else
            return 1
        fi
    fi

    return 0
}

clear() {
    echo -n "Clearing system iptables: "
    /sbin/iptables --policy INPUT   ACCEPT
    /sbin/iptables --policy OUTPUT  ACCEPT
    /sbin/iptables --policy FORWARD ACCEPT
    /sbin/iptables           --flush
    /sbin/iptables -t nat    --flush
    /sbin/iptables -t mangle --flush
    /sbin/iptables           --delete-chain
    /sbin/iptables -t nat    --delete-chain
    /sbin/iptables -t mangle --delete-chain
    check_status
    echo
}

stop() {
    clear
}

save() {
    ret=0
    TMP_FILE=$(/bin/mktemp -q $IPTABLES_DATA.XXXXXX) \
        && chmod 600 "$TMP_FILE" \
        && $IPTABLES-save > $TMP_FILE 2>/dev/null \
        && size=$(stat -c '%s' $TMP_FILE) && [ $size -gt 0 ] \
        || check_status && rm -f $TMP_FILE && exit 1
    if [ $ret -eq 0 ]; then
        if [ -e $IPTABLES_DATA ]; then
            cp -f $IPTABLES_DATA $IPTABLES_DATA.save \
                && chmod 600 $IPTABLES_DATA.save \
                || check_status && rm -f $TMP_FILE && exit 1
        fi
        if [ $ret -eq 0 ]; then
            mv -f $TMP_FILE $IPTABLES_DATA \
                && chmod 600 $IPTABLES_DATA \
                || check_status && rm -f $TMP_FILE && exit 1
        fi
    fi
    rm -f $TMP_FILE
    check_status
    echo
}

case "$1" in
    start)
        start
        ;;

    stop)
        stop
        ;;

    restart)
        stop
        sleep 3 # give time to sop
        start
        ;;

    save)
        save
        ;;

    lock)
        log_info_msg "Locking system iptables firewall..."
        /sbin/iptables --policy INPUT   DROP
        /sbin/iptables --policy OUTPUT  DROP
        /sbin/iptables --policy FORWARD DROP
        /sbin/iptables           --flush
        /sbin/iptables -t nat    --flush
        /sbin/iptables -t mangle --flush
        /sbin/iptables           --delete-chain
        /sbin/iptables -t nat    --delete-chain
        /sbin/iptables -t mangle --delete-chain
        /sbin/iptables -A INPUT  -i lo -j ACCEPT
        /sbin/iptables -A OUTPUT -o lo -j ACCEPT
        evaluate_retval
        ;;

    clear)
        clear
        ;;

    status)
        /sbin/iptables           --numeric --list
        /sbin/iptables -t nat    --numeric --list
        /sbin/iptables -t mangle --numeric --list
        ;;

    *)
        echo "Usage: $0 {start|stop|restart|save|clear|lock|status}"
        exit 1
        ;;
esac

# End /etc/rc.d/init.d/iptables
EOF
chmod +x "${FAKEROOT}/etc/rc.d/init.d/iptables"

ln -svf ../init.d/iptables "${FAKEROOT}/etc/rc.d/start/S19iptables"
ln -svf ../init.d/iptables "${FAKEROOT}/etc/rc.d/stop/K19iptables"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0

