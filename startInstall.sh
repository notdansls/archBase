#! /usr/bin/bash
#set -e
#set -u
function confirmProcedure {
	clear
	echo
	echo "|"
	echo "| ! !                   W A R N I N G                   ! ! "
	echo "|"
	echo "| ! !     D I S K   E R A S U R E   I M M I N E N T     ! ! "
	echo "|"
	read -p '| To proceed, please type proceed: ' procedureConfirmed
	if [ $procedureConfirmed != "proceed" ]
	then
		exit 22
		
	fi
}

function getInputs {
	clear
	echo
	echo "|"
	echo "| To ensure that this process runs smoothly, we want to "
	echo "| gather some information now to ensure effecient processing"
	echo "|"
	echo "| This will ensure no further prompts after this"
	echo "|"
	read -p  '| User Name: ' userID
	read -sp '| Password:  ' userPW
	echo "|"
	read -p	 '| hostname:  ' hostName
}

function writeOutputs {
	echo "stdUserID=$userID" > ~/archBase.conf
	echo "stdUserPW=$userPW" >> ~/archBase.conf
	echo "aHostname=$hostName" >> ~/archBase.conf
	echo "Username, Password, and hostname  written to file..."
	unset userID
	unset userPW
	unset hostName
}

function prepareDisk {
	storage="/dev/$(lsblk | grep disk | head -n 1 | cut -c1-3)"
	sleep 1		#	Sleep the script for a second, fdisk keeps failing if executed quickly
	(&>/dev/null . ~/archBase/diskLayout.sh &)
	partition=$storage"2"
	mkfs.ext4 $partition -F
	mount $partition /mnt
	read -p "Waiting here to allow review of possible errors..."
}

function prepareEnvironment {
	timedatectl set-ntp true
	pacstrap /mnt base linux linux-firmware base-devel git vim networkmanager openssh grub sudo wget
#	pacstrap /mnt base linux linux-firmware vim networkmanager grub sudo
	genfstab -U /mnt >> /mnt/etc/fstab
	checkPublicKey
	cp ~/archBase.conf /mnt/root/
	cp -r /root/archBase /mnt/root/
	echo ". ~/archBase/firstLogin.sh" >> /mnt/root/.bashrc
	arch-chroot /mnt
}

function checkPublicKey {
	publicKey=~/base
	if test -f "$publicKey"; then
		cp publicKey /mnt/root/base
		publicKeyDone=/mnt/root/base
		if test -f "$publicKeyDone"; then
			echo "|-> Public key copied"
		else
			echo "|-X Public key was NOT copied!"
			sleep 5
		fi
	fi
}

function cleanup {
	clear
	umount -R /mnt
	echo "|"
	echo "| The configuration is now complete, rebooting now..."
	echo "|"
	sleep 5s
	reboot
}

confirmProcedure	# Confirm procedure will run to ensure the user wants to 
			# erase the disk before continuing the process. if any
			# input other than proceed is received it will bail,
			# nothing else will run.
getInputs		# Get the inputs from the user
writeOutputs		# write the inputs gathered to the archBase.conf file
prepareDisk		# prepare the disk for pacstrap
prepareEnvironment	# Get the environemnt ready for first boot
cleanup			# Unmount everything and reboot everything
