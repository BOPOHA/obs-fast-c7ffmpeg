#!/bin/bash
set -e
LANG=en_US.UTF-8

sed -i 's/selinux/kvm-intel.nested=1 intel_pstate=0 iommu=off intel_iommu=off  intel_idle.max_cstate=0 processor.max_cstate=0 idle=poll selinux/' /etc/default/grub
chmod +x /etc/rc.d/rc.local
echo 'for cpunum in $(cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | grep -o "[0-9]*$"| sort -un ); do
        echo 0 > /sys/devices/system/cpu/cpu$cpunum/online
done ' >>  /etc/rc.d/rc.local
echo 'sysctl -w vm.swappiness=1
sysctl -w vm.vfs_cache_pressure=10' >> /etc/rc.d/rc.local
grub2-mkconfig -o /boot/grub2/grub.cfg
yum update -y
yum install vim wget net-tools atop -y
cd /etc/yum.repos.d/ && wget http://download.opensuse.org/repositories/openSUSE:Tools/CentOS_7/openSUSE:Tools.repo
yum install qemu-kvm libvirt virt-install bridge-utils libguestfs-tools -y
yum install osc git -y
cat > ~/.oscrc << EOF
[general]
apiurl = https://linux

[https://linux]
user = Admin
pass = opensuse
EOF

systemctl start libvirtd
systemctl enable libvirtd
shutdown -r now


