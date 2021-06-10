echo "Dunno if this will work but gotta be worth a try..."
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
# the next stage involves opening /etc/locale.gen and uncommenting en_GB.UTF8 UTF8 and running locale-gen.
