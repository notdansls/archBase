echo "Dunno if this will work but gotta be worth a try..."
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
# the next stage involves opening /etc/locale.gen and uncommenting en_GB.UTF8 UTF8 and running locale-gen.
# Uncomment en_GB and confirm...
echo "| Configuring Languages..."
sed -i.bak '/en_GB/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "| Configuring Networking..."
echo "archbase" > /etc/hostname
printf "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarchbase.localdomain archbase\n" >> /etc/hosts
echo "| You'll need to set a root password here."
echo "| you will need the password once we have restarted."
passwd
# need to do grub here...
echo "| Configuring GRUB Bootloader..."
DISK="/dev/$(lsblk | grep disk | grep G | cut -c1-3)"
grub-install --target=i386-pc $DISK
grub-mkconfig -o /boot/grub/grub.cfg
# need to remove line from .bashrc to prevent reload
sed -i.bak '/firstLogin/d' ~/.bashrc
echo "I think we're done..."
echo "                     ...for now..."
exit
