#!/bin/bash -eux

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    echo "==> Applying updates"
    yum -y update
    sed -i "s/^.*requiretty/# Defaults    requiretty/" /etc/sudoers
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
    # reboot
    echo "Rebooting the machine..."
    reboot
    sleep 60
fi