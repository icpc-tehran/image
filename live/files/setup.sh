#!/bin/sh

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

export HOME=/root
export LC_ALL=C
export LIVE_BUILD=live

dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

# Uncomment to drop to shell instead
#bash
cp /files/wallpaper.png /opt/
glib-compile-schemas /usr/share/glib-2.0/schemas

sh /files/install.sh

cp /files/C++.sublime-package /opt/sublime_text/Packages
mkdir -p /usr/share/dictd
cp /files/dicts/* /usr/share/dictd

apt-get autoremove -y && apt-get autoclean -y
apt-get clean
rm -rf /tmp/* ~/.bash_history
rm /var/lib/dbus/machine-id
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl
umount /proc || umount -lf /proc
umount /sys
umount /dev/pts
