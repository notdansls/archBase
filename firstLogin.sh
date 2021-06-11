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
passwd 
exit
