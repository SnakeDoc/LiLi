#!/bin/bash

# Network

set -e
set -u

echo "Installing network"
# make it so, number 1!
mkdir -pv "${FAKEROOT}/etc/rc.d/{start,stop,init.d}"

cat > "${FAKEROOT}/etc/rc.d/init.d/network" << "EOF"
#!/bin/ash
#
# Networking

. /etc/rc.d/init.d/functions

PIDFILE=/var/run/network.pid

case "$1" in
start)
        if [ -r "$PIDFILE" ]; then
                echo "Service network already running."
        else
                echo "Starting network: "
                echo "Setting up interface eth0: "
                ifconfig eth0 up
                check_status
                echo -n "Obtaining IP address: "
                udhcpc eth0
                check_status
        fi
        ;;
stop)
        if [ -r "$PIDFILE" ]; then
                echo -n "Stopping network: "
                kill `cat "$PIDFILE"`
                check_status
        else
                echo "Service network not running."
        fi
        ;;
restart)
        $0 stop
        $0 start
        ;;
status)
        if [ -r "$PIDFILE" ]; then
                echo "Service network running (PID $(cat "$PIDFILE"))."
        else
                echo "Service network not running."
        fi
        ;;
*)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
esac
EOF

chmod +x "${FAKEROOT}/etc/rc.d/init.d/network"

ln -svf ../init.d/network "${FAKEROOT}/etc/rc.d/start/S01network"
ln -svf ../init.d/network "${FAKEROOT}/etc/rc.d/stop/K999network"

mkdir -pv "${FAKEROOT}/etc/network/if-{post-{up,down},pre-{up,down},up,down}.d"
mkdir -pv "${FAKEROOT}/usr/share/udhcpc"

cat > "${FAKEROOT}/etc/network/interfaces" << "EOF"
auto eth0
iface eth0 inet dhcp
EOF

cat > "${FAKEROOT}/usr/share/udhcpc/default.script" << "EOF"
#!/bin/sh
# udhcpc Interface Configuration
# Based on http://lists.debian.org/debian-boot/2002/11/msg00500.html
# udhcpc script edited by Tim Riker <Tim@Rikers.org>

[ -z "$1" ] && echo "Error: should be called from udhcpc" && exit 1

RESOLV_CONF="/etc/resolv.conf"
[ -n "$broadcast" ] && BROADCAST="broadcast $broadcast"
[ -n "$subnet" ] && NETMASK="netmask $subnet"

case "$1" in
        deconfig)
                /sbin/ifconfig $interface 0.0.0.0
                ;;

        renew|bound)
                /sbin/ifconfig $interface $ip $BROADCAST $NETMASK

                if [ -n "$router" ] ; then
                        while route del default gw 0.0.0.0 dev $interface ; do
                                true
                        done

                        for i in $router ; do
                                route add default gw $i dev $interface
                        done
                fi

                echo -n > $RESOLV_CONF
                [ -n "$domain" ] && echo search $domain >> $RESOLV_CONF
                for i in $dns ; do
                        echo nameserver $i >> $RESOLV_CONF
                done
                ;;
esac

exit 0
EOF

chmod +x "${FAKEROOT}/usr/share/udhcpc/default.script"

exit 0

