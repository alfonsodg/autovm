# Libvirt installation and configuration in Ubuntu 22.04

## Installing dependencies

	apt -y install qemu-kvm libvirt-daemon-system libvirt-daemon virtinst bridge-utils libosinfo-bin vim cloud-image-utils cloud-init
	
## Adjusting netplan

Find the right **netplan** configuration file in your server, in this case we will use (as example): **/etc/netplan/01-netcfg.yaml**

Also, the following lines creates the bridges for libvirt/KVM but based in a bonding network configuration, you can replace the bonding for a single network interface:

    bridges:
		br0:
		  interfaces: [bond0]
		  dhcp4: false
		  addresses: [10.37.51.40/26]
		  nameservers:
			addresses:
			  - 10.0.80.11
			  - 10.0.80.12
		  routes:
			- to: 10.0.0.0/8
			  via: 10.37.51.1
			- to: 161.26.0.0/16
			  via: 10.37.51.1
			- to: 166.8.0.0/14
			  via: 10.37.51.1
		br1:
		  interfaces: [bond1]
		  dhcp4: false
		  addresses: [52.116.63.86/28]
		  gateway4: 52.116.63.81
		  nameservers:
			addresses:
			  - 10.0.80.11
			  - 10.0.80.12


## Configure the bridges for libvirt/KVM

You must create 2 single files in any place, each one refers to an bridge interface related to private/public networks:

	#private-bridge.xml 
	<network>
	  <name>private-bridge</name>
	  <forward mode="bridge"/>
	  <bridge name="br0"/>
	</network>

	#public-bridge.xml  
	<network>
	  <name>public-bridge</name>
	  <forward mode="bridge"/>
	  <bridge name="br1"/>
	</network>

Where you have those file, just need to run the following commands:

	virsh net-define private-bridge.xml
	virsh net-start private-bridge
	virsh net-autostart private-bridge
	virsh net-define public-bridge.xml
	virsh net-start public-bridge
	virsh net-autostart public-bridge

If everything works well you can check the networks for libvirt/KVM with this:

	virsh net-list --all

## Preparing the system for AutoVM

Create a directory for base images:

	mkdir /var/lib/libvirt/images/base

In this point you can download any cloudimg and after that move into **base** directory:

	wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img 

	sudo mv -i jammy-server-cloudimg-amd64.img /var/lib/libvirt/images/base/ubuntu22.04.qcow2

Obviously, you can use any distro but remember: maintain the name of the base image (before de qcow2) using the os-variant list.


## Final steps

At this point, you are ready for create any VM and you can do it simply using **AutoVM**
