#!/bin/bash
set -e
LANG=en_US.UTF-8
GITREPO='https://github.com/BOPOHA/'
REPONAME='obs-fast-c7ffmpeg'
VMPATH='/home/libvirt_images'

mkdir -p $VMPATH
rm -rf /var/lib/libvirt/images
ln -s $VMPATH /var/lib/libvirt/images
rm -rf ~/$REPONAME
cd ~ && git clone $GITREPO$REPONAME

rm -rf $VMPATH/*
cd $VMPATH

wget http://download.opensuse.org/repositories/OBS:/Server:/2.6/images/obs-server.x86_64.qcow2
qemu-img create -f raw -o size=128G obs-server_os.raw

virt-resize --expand /dev/sda1        obs-server.x86_64.qcow2 obs-server_os.raw
losetup /dev/loop0  obs-server_os.raw
kpartx -a /dev/loop0
mount /dev/mapper/loop0p1 /mnt
#echo "/dev/vdb1 none swap defaults 0 0" >> /mnt/etc/fstab
echo "rcsshd start
swapon /dev/vdb1
sleep 360 && screen -dmS upgraderepos bash -x /root/upgrade.repos.bash &
#                " >> /mnt/etc/init.d/boot.local
mkdir /mnt/root/.ssh
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub > /mnt/root/.ssh/authorized_keys
cat ~/$REPONAME/___env/upgrade.repos.bash >> /mnt/root/upgrade.repos.bash
chmod -R 700 /mnt/root/.ssh
umount /mnt/
kpartx -d /dev/loop0
losetup -d /dev/loop0


qemu-img create -f raw -o size=128G obs-server_lvm.raw
losetup /dev/loop0 obs-server_lvm.raw
parted -s /dev/loop0 mklabel msdos
parted -s /dev/loop0 mkpart primary 0.00GB 8GB
parted -s /dev/loop0 mkpart primary 8GB 128GB
parted -s /dev/loop0 set 2 lvm on
kpartx -a /dev/loop0
sleep 2
mkswap /dev/mapper/loop0p1
pvcreate /dev/mapper/loop0p2 -ff -y
vgcreate "OBS" /dev/mapper/loop0p2
lvcreate -L 32G -n "server" /dev/OBS
vgscan
mkfs.ext4 /dev/OBS/server
vgchange -an OBS
kpartx -d /dev/loop0
losetup -d /dev/loop0

sync

virt-install \
   --name OBS_server \
   --ram 7168 --vcpus 4 \
   --disk path=/home/libvirt_images/obs-server_os.raw  \
   --disk path=/home/libvirt_images/obs-server_lvm.raw \
   --graphics spice \
   --os-variant sles11 \
   --boot=hd &
sleep 180 && virsh reboot OBS_server
sleep 60
VPS_MAC=`virsh dumpxml OBS_server  | grep -o  '..:..:..:..:..:..'`
VPS_IP=`arp -an | grep $VPS_MAC | sed  's|^.*(\(.*\)).*$|\1|'`
set +e
touch /etc/hosts /root/.ssh/known_hosts
sed -i "/linux/d; /$VPS_IP/d;" /etc/hosts /root/.ssh/known_hosts
set -e
echo "$VPS_IP linux" >> /etc/hosts
sleep 60
ssh  linux -oStrictHostKeyChecking=no uptime



