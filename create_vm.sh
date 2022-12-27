#!/usr/bin/env bash

if [ $# -gt 0 ]; then
    PRIVATE_IP=$(head -n 1 private_ip.txt)
    sed -i '1d' private_ip.txt
    PUBLIC_IP=$(head -n 1 public_ip.txt)
    sed -i '1d' public_ip.txt
    export NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
    export HOSTNAME="$1"
    export IP_ADDR1="$PRIVATE_IP"
    export IP_ADDR2="$PUBLIC_IP"
    export GW=$(head -n 1 gateway.txt)
    export GW_PRIVATE=$(head -n 1 gw-private.txt)
    export NMPR=$(head -n 1 netmask-private.txt)
    export NMPU=$(head -n 1 netmask-public.txt)
    export DNSPR=$(head -n 1 dns-private.txt)
    export DNSPU=$(head -n 1 dns-public.txt)
    export MAC_ADDR1=$(od -An -N6 -tx1 /dev/urandom | sed -e 's/^  *//' -e 's/  */:/g' -e 's/:$//' -e 's/^\(.\)[13579bdf]/\10/')
    export MAC_ADDR2=$(od -An -N6 -tx1 /dev/urandom | sed -e 's/^  *//' -e 's/  */:/g' -e 's/:$//' -e 's/^\(.\)[13579bdf]/\10/')
    export CLOUDIMG=$(head -n 1 linuxbase.txt)
    export ROUTING=$(cat routing.txt)
    export DEFUSER=$(head -n 1 defaultuser.txt)
    export DEFPWD=$(head -n 1 defaultpasswd.txt)
    export PUB_KEY=$(cat main-ssh-key.txt)
    export PUB_KEY_1=$(cat aux01-ssh-key.txt)
    export PUB_KEY_2=$(cat aux02-ssh-key.txt)
    export PKGS=$(cat packages.txt)
    export RUNCMD=$(cat runcmd.txt)
    export TIMEZONE=$(cat timezone.txt)
    export LOCALE=$(cat locale.txt)
    export VMDIR=/var/lib/libvirt/images/$HOSTNAME
    export VMDISK=$HOSTNAME.qcow2


    if [ -z "$2" ]
    then
        export VMSIZE="100G"
    else
        export VMSIZE="$2G"
    fi
    if [ -z "$3" ]
    then
        export RAM="8192"
    else
        export RAM="$3"
    fi
    if [ -z "$4" ]
    then
        export CPU="4"
    else
        export CPU="$4"
    fi
    
    
# Creating the VM directory 
   
    mkdir $VMDIR

# Generating configuration files for cloud-init

    echo "local-hostname: $HOSTNAME" > $VMDIR/meta-data.yaml
    
    echo "\
#cloud-config
system_info:
  default_user:
    name: $DEFUSER
    home: /home/$DEFUSER
    groups: sudo,docker
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']

password: $DEFPWD
chpasswd: { expire: False }
hostname: $HOSTNAME

ssh_pwauth: True
disable_root: True

timezone: $TIMEZONE
locale: $LOCALE
users:
  - default
  - name: ubuntu
    groups: sudo,docker
    sudo: 'ALL=(ALL) NOPASSWD:ALL'
    groups: sudo,docker
    shell: /bin/bash
    ssh-authorized-keys:
      - $PUB_KEY
      - $PUB_KEY_1
      - $PUB_KEY_2

package_update: true
package_upgrade: true
package_reboot_if_required: true
#manage-resolv-conf: true
#resolv_conf:
#  nameservers:
#    - '1.1.1.1'
#    - '8.8.8.8'
packages:
    - apt-transport-https
    - ca-certificates
    - curl
    - software-properties-common
    - nfs-common
    - gnupg-agent
$PKGS
runcmd:
  - echo 'AllowUsers ubuntu apuadmin' >> /etc/ssh/sshd_config
  - echo 'ClientAliveInterval 60' >> /etc/ssh/sshd_config
  - restart ssh
  - sed -i 's/ExecStart=\/lib\/systemd\/systemd-networkd-wait-online/ExecStart=\/lib\/systemd\/systemd-networkd-wait-online --any/' /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service 
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  - add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"
  - apt update -y
  - apt install -y docker-ce docker-ce-cli containerd.io
$RUNCMD
" > $VMDIR/user-data.yaml

    echo "\
version: 2
ethernets:
  enp1s0:
    match:
        macaddress: \"$MAC_ADDR1\"
    addresses:
    - $IP_ADDR1/$NMPR
    nameservers:
        addresses: $DNSPR
    routes:
        - to: 10.0.0.0/8
          via: $GW_PRIVATE
        - to: 161.26.0.0/16
          via: $GW_PRIVATE
        - to: 166.8.0.0/14
          via: $GW_PRIVATE

  enp2s0:
     match:
         macaddress: \"$MAC_ADDR2\"
     addresses:
     - $IP_ADDR2/$NMPU
     routes: 
         - to: default
           via: $GW
     nameservers:
        addresses: $DNSPU
" > $VMDIR/network-config-v2.yaml

# Integration and installation for VMs

	echo "VM image creation"
	sleep 4
	qemu-img convert -f qcow2 -O qcow2 /var/lib/libvirt/images/base/$CLOUDIMG.qcow2 $VMDIR/$VMDISK
    qemu-img resize $VMDIR/$VMDISK $VMSIZE

	echo "Generate cloud-init"
	sleep 4
    cloud-localds -v --network-config=$VMDIR/network-config-v2.yaml \
    $VMDIR/$HOSTNAME-cidata.iso $VMDIR/user-data.yaml $VMDIR/meta-data.yaml

	echo "VM installation"
	sleep 4
    virt-install --connect qemu:///system --virt-type kvm --name $HOSTNAME --ram $RAM --vcpus=$CPU \
    --os-variant $CLOUDIMG --disk path=$VMDIR/$VMDISK,format=qcow2 \
    --disk $VMDIR/$HOSTNAME-cidata.iso,device=cdrom \
    --import --network network=private-bridge,model=virtio,mac=$MAC_ADDR1 \
    --network network=public-bridge,model=virtio,mac=$MAC_ADDR2 --noautoconsole --keymap=es
    
    virsh autostart $HOSTNAME
    
# Logging

    echo "Logging..."
    sleep 4

    echo "\
    HOSTNAME = $HOSTNAME
    IP PRIVATE = $IP_ADDR1
    IP PUBLIC =  $IP_ADDR2\
    
    qemu-img convert -f qcow2 -O qcow2 /var/lib/libvirt/images/base/$CLOUDIMG.qcow2 $VMDIR/$VMDISK
    qemu-img resize $VMDIR/$VMDISK $VMSIZE
    
    cloud-localds -v --network-config=$VMDIR/network-config-v2.yaml \
    $VMDIR/$HOSTNAME-cidata.iso $VMDIR/user-data.yaml $VMDIR/meta-data.yaml

    virt-install --connect qemu:///system --virt-type kvm --name $HOSTNAME --ram $RAM --vcpus=$CPU \
    --os-variant $CLOUDIMG --disk path=$VMDIR/$VMDISK,format=qcow2 \
    --disk $VMDIR/$HOSTNAME-cidata.iso,device=cdrom \
    --import --network network=private-bridge,model=virtio,mac=$MAC_ADDR1 \
    --network network=public-bridge,model=virtio,mac=$MAC_ADDR2 --noautoconsole --keymap=es

    " > $HOSTNAME-VM.txt

else
    echo "Usage: create_vm.sh HOSTNAME DISK_SIZE(GB - INT) RAM_SIZE(MB -INT) CPU_SIZE(INT)"
    echo "Example: sh create_vm.sh rubicon 100 16384 8"
fi
