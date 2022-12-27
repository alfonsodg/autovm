# AutoVM


Script that allows creating virtual machines integrating cloud-config in libvirt/kvm environments quickly and easily


## Scenario

AutoVM is intended to create virtual machines that have two network interfaces (one public and one private) ideally where you have a bare metal server.
Although the script was ported on Ubuntu Server 22.04 it should be agnostic for any Linux distribution that uses libvirt/kvm.


## Explanation

AutoVM creates the virtual machine assuming that the location of the libvirt directory is in /var/lib/libvirt/images/ and that the base image is saved in /var/lib/libvirt/images/base/ , which has been previously saved in said location and renamed the same as the OS variant, as required by virt-install, to help the user below this README is the current list of variants as of December 2022 according to libvirt 8.0.

With all this in mind, the script creates a directory where both the disk drive, the cloud-config files and the iso generated for the boot with the required configurations are stored.
By default, 2 users are created, one with password access (just in case there is a problem) and another that can only be accessed through ssh keys, which in this case is the user: ubuntu, it is recommended to disable access after configuring the VMs ssh for passwords.
As part of the cloud-config, some packages and services are installed by default, in this case docker and nfs, but it can be adjusted to any need, you just need to modify the script or the right files to achieve it.

As final **warning** : when a VM is created, their IP is removed from the **public_ip.txt** and **private_ip.txt** files and you will have the assigned ips to the VM in the **$HOSTNAME-VM.txt** file created in the directory.


## Configuration

Modify each .txt included in the project according to your needs

> **defaultuser.txt** : default user

> **defaultpasswd.txt** : plain password for default user 

> **linuxbase.txt** : os variant, it is important that the base image is renamed exactly like the variant

> **gateway.txt** : gateway for public interface

> **gw-private.txt** : gateway for private interface

> **routing.txt** : routing for private interface (unused)

> **netmask-private.txt** : netmask for private interface

> **netmask-public.txt** : netmask for public interface

> **dns-private.txt** : dns for private interface

> **dns-public.txt** : dns for public interface

> **private_ip.txt** : private ips list

> **public_ip.txt** : public ips list

> **main-ssh-key.txt** : ssh key of main user

> **aux01-ssh-key.txt** : ssh key of aux user 01

> **aux02-ssh-key.txt** : ssh key of aux user 02

> **locale.txt** : set locale for VM

> **timezone.txt** : set timezone for VM

> **packages.txt** : desired packages for automatic install

> **runcmd.txt** : extra commands to run at first boot


## Usage

    create_vm.sh HOSTNAME DISK_SIZE(GB - INT) RAM_SIZE(MB - INT) CPU_SIZE(INT)
    
    Example: sh create_vm.sh rubicon 100 16384 8
    
    Note: you just need the HOSTNAME as mandatory, by default creates a VM with 100GB DISK, 8 GB RAM and 4 CORES


## Logging

	With each VM created a new file will be placed inside the directory with this format: $HOSTNAME-VM.txt, you can find the information about the new VM and also the commands used for their creation.
	We use this file not only for review the assigned IPs also for logging purpouses in case that any problem.


## OS variant list


	almalinux9
	almalinux8
	alpinelinux3.17
	alpinelinux3.16
	alpinelinux3.15
	alpinelinux3.14
	alpinelinux3.13
	alpinelinux3.12
	alpinelinux3.11
	alpinelinux3.10
	alpinelinux3.9
	alpinelinux3.8
	alpinelinux3.7
	alpinelinux3.6
	alpinelinux3.5
	alt10.0
	alt9.2
	alt9.1
	alt9.0
	alt8.2
	alt8.1
	alt8.0
	alt.p10
	alt.p9
	alt.p8
	alt.sisyphus
	altlinux7.0
	altlinux6.0
	altlinux5.0
	altlinux4.1
	altlinux4.0
	altlinux3.0
	altlinux2.4
	altlinux2.2
	altlinux2.0
	altlinux1.0
	android-x86-9.0
	android-x86-8.1
	archlinux
	asianux8.0
	asianux7.3
	asianux7.2
	asianux7.1
	asianux7.0
	asianux4.7
	asianux4.6
	asianux-unknown
	caasp3.0
	caasp2.0
	caasp1.0
	caasp-unknown
	centos8
	centos7, centos7.0
	centos6.10
	centos6.9
	centos6.8
	centos6.7
	centos6.6
	centos6.5
	centos6.4
	centos6.3
	centos6.2
	centos6.1
	centos6.0
	centos5.11
	centos5.10
	centos5.9
	centos5.8
	centos5.7
	centos5.6
	centos5.5
	centos5.4
	centos5.3
	centos5.2
	centos5.1
	centos5.0
	centos-stream9
	centos-stream8
	circle9-unknown
	circle9.0
	circle8-unknown
	circle8.5
	circle8.4
	circle-unknown
	cirros0.5.2
	cirros0.5.1
	cirros0.5.0
	cirros0.4.0
	cirros0.3.5
	cirros0.3.4
	cirros0.3.3
	cirros0.3.2
	cirros0.3.1
	cirros0.3.0
	clearlinux
	debian11, debianbullseye
	debian10, debianbuster
	debian9, debianstretch
	debian8, debianjessie
	debian7, debianwheezy
	debian6, debian6.0, debiansqueeze
	debian5, debian5.0, debianlenny
	debian4, debian4.0, debianetch
	debian3, debian3.0, debianwoody
	debian3.1, debiansarge
	debian2.2, debianpotato
	debian2.1, debianslink
	debian2.0, debianhamm
	debian1.3, debianbo
	debian1.2, debianrex
	debian1.1, debianbuzz
	debiantesting
	dragonflybsd5.6
	dragonflybsd5.4.3
	dragonflybsd5.4.2
	dragonflybsd5.4.1
	dragonflybsd5.4.0
	dragonflybsd5.2.2
	dragonflybsd5.2.1
	dragonflybsd5.2.0
	dragonflybsd5.0.2
	dragonflybsd5.0.1
	dragonflybsd5.0.0
	dragonflybsd4.8.1
	dragonflybsd4.8.0
	dragonflybsd4.6.2
	dragonflybsd4.6.1
	dragonflybsd4.6.0
	dragonflybsd4.4.3
	dragonflybsd4.4.2
	dragonflybsd4.4.1
	dragonflybsd4.2.4
	dragonflybsd4.2.3
	dragonflybsd4.2.1
	dragonflybsd4.2.0
	dragonflybsd4.0.1
	dragonflybsd4.0.0
	dragonflybsd3.8.2
	dragonflybsd3.8.1
	dragonflybsd3.8.0
	dragonflybsd3.6.2
	dragonflybsd3.6.1
	dragonflybsd3.6.0
	dragonflybsd3.4.3
	dragonflybsd3.4.2
	dragonflybsd3.4.1
	dragonflybsd3.2.1
	dragonflybsd3.0.1
	dragonflybsd2.10.1
	dragonflybsd2.8.2
	dragonflybsd2.6.3
	dragonflybsd2.6.2
	dragonflybsd2.6.1
	dragonflybsd2.4.1
	dragonflybsd2.4.0
	dragonflybsd2.2.1
	dragonflybsd2.2.0
	dragonflybsd2.0.1
	dragonflybsd2.0.0
	dragonflybsd1.12.2
	dragonflybsd1.12.1
	dragonflybsd1.12.0
	dragonflybsd1.10.1
	dragonflybsd1.10.0
	dragonflybsd1.8.1
	dragonflybsd1.8.0
	dragonflybsd1.6.0
	dragonflybsd1.4.4
	dragonflybsd1.4.0
	dragonflybsd1.2.6
	dragonflybsd1.2.5
	dragonflybsd1.2.4
	dragonflybsd1.2.3
	dragonflybsd1.2.2
	dragonflybsd1.2.1
	dragonflybsd1.2.0
	dragonflybsd1.0
	dragonflybsd1.0A
	elementary5.0
	eos4.0
	eos3.10
	eos3.9
	eos3.8
	eos3.7
	eos3.6
	eos3.5
	eos3.4
	eos3.3
	eos3.2
	eos3.1
	fedora37
	fedora36
	fedora35
	fedora34
	fedora33
	fedora32
	fedora31
	fedora30
	fedora29
	fedora28
	fedora27
	fedora26
	fedora25
	fedora24
	fedora23
	fedora22
	fedora21
	fedora20
	fedora19
	fedora18
	fedora17
	fedora16
	fedora15
	fedora14
	fedora13
	fedora12
	fedora11
	fedora10
	fedora9
	fedora8
	fedora7
	fedora6
	fedora5
	fedora4
	fedora3
	fedora2
	fedora1
	fedora-coreos-next
	fedora-coreos-stable
	fedora-coreos-testing
	fedora-eln
	fedora-rawhide
	fedora-unknown
	freebsd13.1
	freebsd13.0
	freebsd12.3
	freebsd12.2
	freebsd12.1
	freebsd12.0
	freebsd11.4
	freebsd11.3
	freebsd11.2
	freebsd11.1
	freebsd11.0
	freebsd10.4
	freebsd10.3
	freebsd10.2
	freebsd10.1
	freebsd10.0
	freebsd9.3
	freebsd9.2
	freebsd9.1
	freebsd9.0
	freebsd8.4
	freebsd8.3
	freebsd8.2
	freebsd8.1
	freebsd8.0
	freebsd7.4
	freebsd7.3
	freebsd7.2
	freebsd7.1
	freebsd7.0
	freebsd6.4
	freebsd6.3
	freebsd6.2
	freebsd6.1
	freebsd6.0
	freebsd5.5
	freebsd5.4
	freebsd5.3
	freebsd5.2
	freebsd5.2.1
	freebsd5.1
	freebsd5.0
	freebsd4.11
	freebsd4.10
	freebsd4.9
	freebsd4.8
	freebsd4.7
	freebsd4.6
	freebsd4.5
	freebsd4.4
	freebsd4.3
	freebsd4.2
	freebsd4.1
	freebsd4.0
	freebsd3.2
	freebsd3.0
	freebsd2.2.9
	freebsd2.2.8
	freebsd2.0
	freebsd2.0.5
	freebsd1.0
	freedos1.2
	freenix14.2
	generic
	gentoo
	gnome3.8
	gnome3.6
	gnome-continuous-3.14
	gnome-continuous-3.12
	gnome-continuous-3.10
	guix-1.3
	guix-1.1
	guix-hurd-latest
	guix-latest
	haikunightly
	haikur1alpha4.1
	haikur1alpha3
	haikur1alpha2
	haikur1alpha1
	haikur1beta3
	haikur1beta2
	haikur1beta1
	hyperbola03
	linux2022
	linux2020
	linux2018
	linux2016
	macosx10.7
	macosx10.6
	macosx10.5
	macosx10.4
	macosx10.3
	macosx10.2
	macosx10.1
	macosx10.0
	mageia8
	mageia7
	mageia6
	mageia5
	mageia4
	mageia3
	mageia2
	mageia1
	mandrake10.2
	mandrake10.1
	mandrake10.0
	mandrake9.2
	mandrake9.1
	mandrake9.0
	mandrake8.2
	mandrake8.1
	mandrake8.0
	mandrake7.2
	mandrake7.1
	mandrake7.0
	mandrake6.1
	mandrake6.0
	mandrake5.3
	mandrake5.2
	mandrake5.1
	mandriva2011
	mandriva2010.2
	mandriva2010.1
	mandriva2010.0
	mandriva2009.1
	mandriva2009.0
	mandriva2008.1
	mandriva2008.0
	mandriva2007
	mandriva2007.1
	mandriva2006.0
	manjaro
	mbs1.0
	mes5
	mes5.1
	miraclelinux9-unknown
	miraclelinux9.0
	miraclelinux8.4
	msdos6.22
	netbsd9.0
	netbsd8.2
	netbsd8.1
	netbsd8.0
	netbsd7.2
	netbsd7.1
	netbsd7.1.2
	netbsd7.1.1
	netbsd7.0
	netbsd6.1
	netbsd6.0
	netbsd5.1
	netbsd5.0
	netbsd4.0
	netbsd3.0
	netbsd2.0
	netbsd1.6
	netbsd1.5
	netbsd1.4
	netbsd1.3
	netbsd1.2
	netbsd1.1
	netbsd1.0
	netbsd0.9
	netbsd0.8
	netware6
	netware5
	netware4
	nixos-22.05
	nixos-21.11
	nixos-21.05
	nixos-20.09
	nixos-20.03
	nixos-unknown
	nixos-unstable
	oel5.4
	oel5.3
	oel5.2
	oel5.1
	oel5.0
	oel4.9
	oel4.8
	oel4.7
	oel4.6
	oel4.5
	oel4.4
	ol8.5
	ol8.4
	ol8.3
	ol8.2
	ol8.1
	ol8.0
	ol7.9
	ol7.8
	ol7.7
	ol7.6
	ol7.5
	ol7.4
	ol7.3
	ol7.2
	ol7.1
	ol7.0
	ol6.10
	ol6.9
	ol6.8
	ol6.7
	ol6.6
	ol6.5
	ol6.4
	ol6.3
	ol6.2
	ol6.1
	ol6.0
	ol5.11
	ol5.10
	ol5.9
	ol5.8
	ol5.7
	ol5.6
	ol5.5
	openbsd7.0
	openbsd6.9
	openbsd6.8
	openbsd6.7
	openbsd6.6
	openbsd6.5
	openbsd6.4
	openbsd6.3
	openbsd6.2
	openbsd6.1
	openbsd6.0
	openbsd5.9
	openbsd5.8
	openbsd5.7
	openbsd5.6
	openbsd5.5
	openbsd5.4
	openbsd5.3
	openbsd5.2
	openbsd5.1
	openbsd5.0
	openbsd4.9
	openbsd4.8
	openbsd4.5
	openbsd4.4
	openbsd4.3
	openbsd4.2
	opensolaris2009.06
	opensuse42.3
	opensuse42.2
	opensuse42.1
	opensuse15.4
	opensuse15.3
	opensuse15.2
	opensuse15.1
	opensuse15.0
	opensuse13.2
	opensuse13.1
	opensuse12.3
	opensuse12.2
	opensuse12.1
	opensuse11.4
	opensuse11.3
	opensuse11.2
	opensuse11.1
	opensuse11.0
	opensuse10.3
	opensuse10.2
	opensuse-factory
	opensuse-unknown
	opensusetumbleweed
	popos20.10
	popos20.04
	popos19.10
	popos19.04
	popos18.10
	popos18.04
	popos17.10
	pureos10
	pureos9
	pureos8
	rhel9-unknown
	rhel9.1
	rhel9.0
	rhel8-unknown
	rhel8.7
	rhel8.6
	rhel8.5
	rhel8.4
	rhel8.3
	rhel8.2
	rhel8.1
	rhel8.0
	rhel7-unknown
	rhel7.9
	rhel7.8
	rhel7.7
	rhel7.6
	rhel7.5
	rhel7.4
	rhel7.3
	rhel7.2
	rhel7.1
	rhel7.0
	rhel6-unknown
	rhel6.10
	rhel6.9
	rhel6.8
	rhel6.7
	rhel6.6
	rhel6.5
	rhel6.4
	rhel6.3
	rhel6.2
	rhel6.1
	rhel6.0
	rhel5.11
	rhel5.10
	rhel5.9
	rhel5.8
	rhel5.7
	rhel5.6
	rhel5.5
	rhel5.4
	rhel5.3
	rhel5.2
	rhel5.1
	rhel5.0
	rhel4.9
	rhel4.8
	rhel4.7
	rhel4.6
	rhel4.5
	rhel4.4
	rhel4.3
	rhel4.2
	rhel4.1
	rhel4.0
	rhel3
	rhel3.9
	rhel3.8
	rhel3.7
	rhel3.6
	rhel3.5
	rhel3.4
	rhel3.3
	rhel3.2
	rhel3.1
	rhel2.1
	rhel2.1.7
	rhel2.1.6
	rhel2.1.5
	rhel2.1.4
	rhel2.1.3
	rhel2.1.2
	rhel2.1.1
	rhel-atomic-7.4
	rhel-atomic-7.3
	rhel-atomic-7.2
	rhel-atomic-7.1
	rhel-atomic-7.0
	rhel-unknown
	rhl9
	rhl8.0
	rhl7
	rhl7.3
	rhl7.2
	rhl7.1
	rhl6.2
	rhl6.1
	rhl6.0
	rhl5.2
	rhl5.1
	rhl5.0
	rhl4.2
	rhl4.1
	rhl4.0
	rhl3.0.3
	rhl2.1
	rhl2.0
	rhl1.1
	rhl1.0
	rocky9
	rocky9-unknown
	rocky9.0
	rocky8
	rocky8-unknown
	rocky8.6
	rocky8.5
	rocky8.4
	rocky-unknown
	scientificlinux7-unknown
	scientificlinux7.6
	scientificlinux7.5
	scientificlinux7.4
	scientificlinux7.3
	scientificlinux7.2
	scientificlinux7.1
	scientificlinux7.0
	scientificlinux6.10
	scientificlinux6.9
	scientificlinux6.8
	scientificlinux6.7
	scientificlinux6.6
	scientificlinux6.5
	scientificlinux6.4
	scientificlinux6.3
	scientificlinux6.2
	scientificlinux6.1
	scientificlinux6.0
	scientificlinux5.11
	scientificlinux5.10
	scientificlinux5.9
	scientificlinux5.8
	scientificlinux5.7
	scientificlinux5.6
	scientificlinux5.5
	scientificlinux5.4
	scientificlinux5.3
	scientificlinux5.2
	scientificlinux5.1
	scientificlinux5.0
	silverblue37
	silverblue36
	silverblue35
	silverblue34
	silverblue33
	silverblue32
	silverblue31
	silverblue30
	silverblue29
	silverblue28
	silverblue-rawhide
	silverblue-unknown
	slackware14.2
	slackware-current
	sle15
	sle15-unknown
	sle15sp4
	sle15sp3
	sle15sp2
	sle15sp1
	sle-unknown
	sled12
	sled12-unknown
	sled12sp5
	sled12sp4
	sled12sp3
	sled12sp2
	sled12sp1
	sled11
	sled11sp4
	sled11sp3
	sled11sp2
	sled11sp1
	sled10
	sled10sp4
	sled10sp3
	sled10sp2
	sled10sp1
	sled9
	slem5.2
	slem5.1
	slem5.0
	sles12
	sles12-unknown
	sles12sp5
	sles12sp4
	sles12sp3
	sles12sp2
	sles12sp1
	sles11
	sles11sp4
	sles11sp3
	sles11sp2
	sles11sp1
	sles10
	sles10sp4
	sles10sp3
	sles10sp2
	sles10sp1
	sles9
	solaris11
	solaris10
	solaris9
	trisquel9
	ubuntu22.10, ubuntukinetic
	ubuntu-lts-latest, ubuntu-stable-latest, ubuntu22.04, ubuntujammy
	ubuntu21.10, ubuntuimpish
	ubuntu21.04, ubuntuhirsute
	ubuntu20.10, ubuntugroovy
	ubuntu20.04, ubuntufocal
	ubuntu19.10, ubuntueoan
	ubuntu19.04, ubuntudisco
	ubuntu18.10, ubuntucosmic
	ubuntu18.04, ubuntubionic
	ubuntu17.10, ubuntuartful
	ubuntu17.04, ubuntutzesty
	ubuntu16.10, ubuntutyakkety
	ubuntu16.04, ubuntutxenial
	ubuntu15.10, ubuntutwily
	ubuntu15.04, ubuntutvivid
	ubuntu14.10, ubuntututopic
	ubuntu14.04, ubuntutrusty
	ubuntu13.10, ubuntusaucy
	ubuntu13.04, ubunturaring
	ubuntu12.10, ubuntuquantal
	ubuntu12.04, ubuntuprecise
	ubuntu11.10, ubuntuoneiric
	ubuntu11.04, ubuntunatty
	ubuntu10.10, ubuntumaverick
	ubuntu10.04, ubuntulucid
	ubuntu9.10, ubuntukarmic
	ubuntu9.04, ubuntujaunty
	ubuntu8.10, ubuntuintrepid
	ubuntu8.04, ubuntuhardy
	ubuntu7.10, ubuntugutsy
	ubuntu7.04, ubuntufeisty
	ubuntu6.10, ubuntuedgy
	ubuntu6.06, ubuntudapper
	ubuntu5.10, ubuntubreezy
	ubuntu5.04, ubuntuhoary
	ubuntu4.10, ubuntuwarty
	ucs5.0
	ucs4.4
	ucs4.3
	ucs4.2
	ucs4.1
	ucs4.0
	unknown
	voidlinux
	win98
	win95
	win11
	win10
	win8
	win8.1
	win7
	win3.1
	win2.1
	win2.0
	win2k
	win2k22
	win2k19
	win2k16
	win2k12
	win2k12r2
	win2k8
	win2k8r2
	win2k3
	win2k3r2
	win1.0
	winme
	winnt4.0
	winnt3.51
	winnt3.5
	winnt3.1
	winvista
	winxp


## Additional notes

I have been using this script since **ubuntu** 18, although I had not made it as variable as this version in such a way that anyone could use it.

That being said, I have always preferred **ubuntu** as the main distro and in previous versions I have not had problems with the VMs, although in this case I noticed that the nodes were slow to restart, so after some research I found that the service **systemd-networkd-wait-online.service** took up to 2 minutes and therefore a simple reboot was a tedious process. To solve the problem, I had to add an **any** parameter to the service in question through the **runcmd** using a sed command, maybe not the ideal solution but I don't need to wait time to be sure that the network works although if something happens in your case you should comment that line and do the respective debug.


## Reference: installing libvirt/KVM inside ubuntu

As a reference, i wrote a document explaining howto install and configure libvirt inside **ubuntu** 22.04, you can review it [here](https://github.com/alfonsodg/autovm/blob/main/LIBVIRT-UBUNTU.md)


## Contributors ✨

Alfonso de la Guarda [github](https://github.com/alfonsodg).


## License

AutoVM is licensed under the GNU General Public License, Version 2. View a copy of the [License file](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
