#!/usr/bin/bash
function configureTimeZone {
	ln -sf /user/share/zoneinfo/Europe/London /etc/localtime
	hwclock --systohc
}

function configureRegion {
	loadkeys uk
	sed -i.bak '/en_GB/s/^#//g' /etc/locale.gen
	locale-gen
	echo "LANG=en_GB.UTF-8" > /etc/locale.conf
	echo "KEYMAP=uk" >> /etc/vconsole.conf
}

function configureNetworking {
	echo $arbhn >> /etc/hostname
	printf "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$arbhn.localdomain $arbhn\n" >> /etc/hosts
}

function readConfig {
	arbid=$(cat ~/archBase.conf | grep stdUserID | cut -c 11-32)
	arbpw=$(cat ~/archBase.conf | grep stdUserPW | cut -c 11-32)
	arbhn=$(cat ~/archBase.conf | grep aHostname | cut -c 11-32)
	echo "We have read the user '$arbid' from the config file."
}

function createStdUser {
	useradd -G wheel -m $arbid
	echo -e "$arbpw\n$arbpw" | sudo passwd $arbid
	sed -i.bak '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers
}

function resetRoot {
	rootPW=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
	echo root:$rootPW | chpasswd
}

function installBootloader {
	disk="/dev/$(lsblk | grep disk | grep G | head -n 1 | cut -c1-3)"
	grub-install --target=i386-pc $disk
	sed -i.bak 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
}

function enableServices {
	systemctl enable NetworkManager
}

function cleanupChroot {
	sed -i.bak '/firstLogin/d' ~/.bashrc
	exit
}

readConfig		# Read the inputs from the previous scripts
configureRegion		# Function does exactly as it sounds
configureNetworking	# Function does exactly as it sounds
createStdUser		# Creates new user within the new environment, give it sudo prives.
resetRoot		# Resets root password to a random unknown string. Root will not be used again.
installBootloader	# install the bootloader of choice
enableServices		# enable any services that are required
cleanupChroot
