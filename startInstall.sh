#!/usr/bin/bash
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
	read -p	 '| hostname:  ' hostName
}

function writeOutputs {
	echo "stdUserID=$userID" >> ~/archBase.conf
	echo "stdUserPW=$userPW" >> ~/archBase.conf
	echo "aHostname=$hostName" >> ~/archBase.conf
	echo "Username, Password, and hostname  written to file..."
	unset userID
	unset userPW
	unset hostName
}

function prepareEnvironment {
	timedatectl set-ntp true
	storage="/dev/$(lsblk | grep disk | heand -n 1 | cut -c1-3)"
	(&>/dev/null . ~/archBase/diskLayout.sh &)
	partition=$storage"2"
	mkfs.ext4 $partition -F
	mount $partition /mnt
#	pacstrap /mnt base linux linux-firmware base-devel git vim networkmanager openssh grub sudo
	pacstrap /mnt base linux linux-firmware vim networkmanager grub sudo
	genfstap -U /mnt >> /mnt/etc/fstab
	cp -r /root/archBase /mnt/root/
	echo ". ~/archBase/firstLogin.sh" >> /mnt/root/.bashrc
	arch-chroot /mnt
}

function readConfig {
	arbid=$(cat ~/archBase.conf | grep stdUserID | cut -c 11-32)
	arbpw=$(cat ~/archBase.conf | grep stdUserPW | cut -c 11-32)
	echo "We have read the user '$arbid' from the config file."
}

function cleanup {
	clean
	umount -R /mnt
	echo "|"
	echo "| The configuration is now complete, rebooting now..."
	echo "|"
	reboot
}

confirmProcedure	# Confirm procedure will run to ensure the user wants to 
			# erase the disk before continuing the process. if any
			# input other than proceed is received it will bail,
			# nothing else will run.
getInputs		# Get the inputs from the user
writeOutputs		# write the inputs gathered to the archBase.conf file
prepareEnvironment	# Get the environemnt ready for first boot
cleanup			# Unmount everything and reboot everything
