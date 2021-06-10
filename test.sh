echo "Test is sucessful!"
echo "since you where able to clone this repository, we'll assume you have a stable internet connection"
timedatectl set-ntp true
echo "lets get the hdd, and dump it into a variable"
STORAGE="/dev/$(lsblk | grep disk | cut -c1-3)"
echo "Warning, this process will wipe the disk! HAHA"
echo "Grabbing the HDD device..."
echo "Targeting " $STORAGE
(&>/dev/null . ~/archBase/diskLayout.sh &)
PARTNO=2
PARTITION="$STORAGE$PARTNO"
# echo $PARTITION
mkfs.ext4 $PARTITION -F
mount $PARTITION /mnt
# Now we're doing the interesting stuff, we're going to pacstrap the installation.
# Packages at present - base linux linux-firmware base-devel git vim NetworkManager openssh grub
#pacstrap /mnt base linux linux-firmware base-devel git vim networkmanager openssh grub
# short version just to get up and running quickly...
pacstrap /mnt base linux linux-firmware
# Next we'll generate the fstab file
genfstab -U /mnt >> /mnt/etc/fstab
# Copy archBase to /mnt/root/...
cp -r /root/archBase /mnt/root/
# Now we want to change root into the new environment
arch-chroot /mnt
# From where, I don't quite now how we'll automate it, but I'll work it out. come back for more soon...
