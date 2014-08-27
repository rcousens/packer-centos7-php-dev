#!/bin/bash -eux

CLEANUP_PAUSE=${CLEANUP_PAUSE:-0}
echo "==> Pausing for ${CLEANUP_PAUSE} seconds..."
sleep ${CLEANUP_PAUSE}

yum -y clean all

# # Remove Virtualbox specific files
rm -rf /usr/src/vboxguest*

# # Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# # remove under tmp directory
rm -rf /tmp/*

# # remove log files
rm -rf /var/log/vagrant/*

echo "==> Cleaning up temporary network addresses"
rm -rf /dev/.udev/

if [ -f /etc/sysconfig/network-scripts/ifcfg-enp0s3 ] ; then
    sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-enp0s3
    sed -i "/^UUID/d" /etc/sysconfig/network-scripts/ifcfg-enp0s3
fi

echo "==> Cleaning up empty space"
# # zero out remaining space
dd if=/dev/zero of=/EMPTY bs=1M
rm -rf /EMPTY

sync