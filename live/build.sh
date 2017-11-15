#!/bin/sh

apt-get install -y squashfs-tools genisoimage
mkdir mnt
mount -o loop ./ubuntu-16.04.3-desktop-amd64.iso mnt
mkdir extract
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract
unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root edit
cp /etc/resolv.conf edit/etc/

mount --bind /dev/ edit/dev

cp -rL files/ edit/files/

# Run 
chroot edit /bin/bash /files/setup.sh

rm -rf edit/files

umount edit/dev


# Assemble ISO file

chmod +w extract/casper/filesystem.manifest
chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee extract/casper/filesystem.manifest
cp extract/casper/filesystem.manifest extract/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' extract/casper/filesystem.manifest-desktop
sed -i '/casper/d' extract/casper/filesystem.manifest-desktop
mksquashfs edit extract/casper/filesystem.squashfs -b 1048576
printf $(sudo du -sx --block-size=1 edit | cut -f1) | sudo tee extract/casper/filesystem.size

cd extract
rm md5sum.txt
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt
genisoimage -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../ubuntu-acm-icpc-2017-v0.9.iso .

