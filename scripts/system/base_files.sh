#!/bin/bash

# Install Base System Files

#. settings/functions
#. settings/config
#. settings/toolchain

pkg_error() {
    error "Error on package base_files" "base_files.sh" "$1"
}

fail_on_error() {
    if [ "$1" -ne 0 ]
    then
        pkg_error "$1"
        exit "$1"
    fi
}

echo "Installing base system files"

########## mtab ##########
echo "Installing /etc/mtab"
ln -svf ../proc/mounts "${FAKEROOT}/etc/mtab"
fail_on_error $?

########## passwd ##########
echo "Installing /etc/passwd"
cat > "${FAKEROOT}/etc/passwd" << "EOF"
root::0:0:root:/root:/bin/ash
bin:x:1:1:bin:/bin:/bin/false
daemon:x:2:6:daemon:/sbin:/bin/false
adm:x:3:16:adm:/var/adm:/bin/false
lp:x:10:9:lp:/var/spool/lp:/bin/false
mail:x:30:30:mail:/var/mail:/bin/false
news:x:31:31:news:/var/spool/news:/bin/false
uucp:x:32:32:uucp:/var/spool/uucp:/bin/false
operator:x:50:0:operator:/root:/bin/ash
postmaster:x:51:30:postmaster:/var/spool/mail:/bin/false
nobody:x:65534:65534:nobody:/:/bin/false
EOF
fail_on_error $?

########## group ##########
echo "Installing /etc/group"
cat > ${FAKEROOT}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:root,adm,daemon
console:x:17:
cdrw:x:18:
mail:x:30:mail
news:x:31:news
uucp:x:32:uucp
users:x:100:
nogroup:x:65533:
nobody:x:65534:
EOF
fail_on_error $?

########## logs ##########
echo "Installing logs"
touch ${FAKEROOT}/var/run/utmp ${FAKEROOT}/var/log/{btmp,lastlog,wtmp}
fail_on_error $?
chmod -v 664 ${FAKEROOT}/var/run/utmp ${FAKEROOT}/var/log/lastlog
fail_on_error $?

########## fstab ##########
echo "Installing /etc/fstab"
cat > ${FAKEROOT}/etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options          dump  fsck
#                                                         order

/dev/mmcblk0p1 /boot        vfat   noauto,noatime   0     0
/dev/mmcblk0p2 /            ext4   noatime          0     0
#/dev/mmcblk0p3 swap         swap   pri=1            0     0
proc           /proc        proc   defaults         0     0
sysfs          /sys         sysfs  defaults         0     0
devpts         /dev/pts     devpts gid=4,mode=620   0     0
shm            /dev/shm     tmpfs  defaults         0     0
# End /etc/fstab
EOF
fail_on_error $?

########## issue file ##########
echo "Installing /etc/issue"
clear > ${FAKEROOT}/etc/issue
# note: don't use quotes on EOF to allow
#    variables to be parsed
cat >> ${FAKEROOT}/etc/issue << EOF
${OS_NAME} release ${VERSION}

Kernel \r on an \m

EOF
fail_on_error $?

########## mdev ##########
echo "Installing /etc/mdev.conf"
cat > ${FAKEROOT}/etc/mdev.conf << "EOF"
# /etc/mdev/conf

# Devices:
# Syntax: %s %d:%d %s
# devices user:group mode

# null does already exist; therefore ownership has to be changed with command
null    root:root 0666  @chmod 666 $MDEV
zero    root:root 0666
grsec   root:root 0660
full    root:root 0666

random  root:root 0666
urandom root:root 0444
hwrandom root:root 0660

# console does already exist; therefore ownership has to be changed with command
#console        root:tty 0600   @chmod 600 $MDEV && mkdir -p vc && ln -sf ../$MDEV vc/0
console root:tty 0600 @mkdir -pm 755 fd && cd fd && for x in 0 1 2 3 ; do ln -sf /proc/self/fd/$x $x; done

fd0     root:floppy 0660
kmem    root:root 0640
mem     root:root 0640
port    root:root 0640
ptmx    root:tty 0666

# ram.*
ram([0-9]*)     root:disk 0660 >rd/%1
loop([0-9]+)    root:disk 0660 >loop/%1
sd[a-z].*       root:disk 0660 */lib/mdev/usbdisk_link
hd[a-z][0-9]*   root:disk 0660 */lib/mdev/ide_links
md[0-9]         root:disk 0660

tty             root:tty 0666
tty[0-9]        root:root 0600
tty[0-9][0-9]   root:tty 0660
ttyS[0-9]*      root:tty 0660
pty.*           root:tty 0660
vcs[0-9]*       root:tty 0660
vcsa[0-9]*      root:tty 0660

ttyLTM[0-9]     root:dialout 0660 @ln -sf $MDEV modem
ttySHSF[0-9]    root:dialout 0660 @ln -sf $MDEV modem
slamr           root:dialout 0660 @ln -sf $MDEV slamr0
slusb           root:dialout 0660 @ln -sf $MDEV slusb0
fuse            root:root  0666

# dri device
card[0-9]       root:video 0660 =dri/

# alsa sound devices and audio stuff
pcm.*           root:audio 0660 =snd/
control.*       root:audio 0660 =snd/
midi.*          root:audio 0660 =snd/
seq             root:audio 0660 =snd/
timer           root:audio 0660 =snd/

adsp            root:audio 0660 >sound/
audio           root:audio 0660 >sound/
dsp             root:audio 0660 >sound/
mixer           root:audio 0660 >sound/
sequencer.*     root:audio 0660 >sound/

# misc stuff
agpgart         root:root 0660  >misc/
psaux           root:root 0660  >misc/
rtc             root:root 0664  >misc/

# input stuff
event[0-9]+     root:root 0640 =input/
mice            root:root 0640 =input/
mouse[0-9]      root:root 0640 =input/
ts[0-9]         root:root 0600 =input/

# v4l stuff
vbi[0-9]        root:video 0660 >v4l/
video[0-9]      root:video 0660 >v4l/

# dvb stuff
dvb.*           root:video 0660 */lib/mdev/dvbdev

# load drivers for usb devices
usbdev[0-9].[0-9]       root:root 0660 */lib/mdev/usbdev
usbdev[0-9].[0-9]_.*    root:root 0660

# net devices
tun[0-9]*       root:root 0600 =net/
tap[0-9]*       root:root 0600 =net/

# zaptel devices
zap(.*)         root:dialout 0660 =zap/%1
dahdi!(.*)      root:dialout 0660 =dahdi/%1

# raid controllers
cciss!(.*)      root:disk 0660 =cciss/%1
ida!(.*)        root:disk 0660 =ida/%1
rd!(.*)         root:disk 0660 =rd/%1

sr[0-9]         root:cdrom 0660 @ln -sf $MDEV cdrom

# hpilo
hpilo!(.*)      root:root 0660 =hpilo/%1

# xen stuff
xvd[a-z]        root:root 0660 */lib/mdev/xvd_links
EOF
fail_on_error $?

########## profile ##########
echo "Installing /etc/profile"
cat > ${FAKEROOT}/etc/profile<< "EOF"
# /etc/profile

# Set the initial path
export PATH=/bin:/usr/bin

if [ `id -u` -eq 0 ] ; then
        PATH=/bin:/sbin:/usr/bin:/usr/sbin
        unset HISTFILE
fi

# Setup some environment variables.
export USER=`id -un`
export LOGNAME=$USER
export HOSTNAME=`/bin/hostname`
export HISTSIZE=1000
export HISTFILESIZE=1000
export PAGER='/bin/more '
export EDITOR='/bin/vi'

# End /etc/profile
EOF
fail_on_error $?

########## inittab ##########
echo "Installing /etc/inittab"
cat > ${FAKEROOT}/etc/inittab << "EOF"
# /etc/inittab

::sysinit:/etc/rc.d/startup

tty1::respawn:/sbin/getty 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3
tty4::respawn:/sbin/getty 38400 tty4
tty5::respawn:/sbin/getty 38400 tty5
tty6::respawn:/sbin/getty 38400 tty6

# Put a getty on the serial line (for a terminal)
# uncomment this line if your using a serial console
#::respawn:/sbin/getty -L ttyS0 115200 vt100

::shutdown:/etc/rc.d/shutdown
::ctrlaltdel:/sbin/reboot
EOF
fail_on_error $?

########## shells ##########
echo "Installing /etc/shells"
cat > ${FAKEROOT}/etc/shells << "EOF"
/bin/sh
/bin/ash
EOF
fail_on_error $?

########## release ##########
echo "Installing /etc/${OS_NAME,,}-release"
# note: don't use quotes around EOF to
#    allow variables to be parsed
cat > ${FAKEROOT}/etc/${OS_NAME,,}-release << EOF
${OS_NAME} release ${VERSION}
EOF
fail_on_error $?

########## hostname ##########
echo "Installing /etc/HOSTNAME"
echo "${OS_NAME,,}" > ${FAKEROOT}/etc/HOSTNAME
fail_on_error $?

########## hosts ##########
echo "Installing /etc/hosts"
# note: don't use quotes around EOF to allow
#    variables to be parsed
cat > ${FAKEROOT}/etc/hosts << EOF
# Begin /etc/hosts

127.0.0.1 ${OS_NAME,,}.local ${OS_NAME,,} localhost

# End /etc/hosts
EOF
fail_on_error $?

exit 0 # OK

