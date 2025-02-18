# archBase
Welcome to archBase, the purpose of this repo is to create a basic ArchLinux installation. It has a very basic application suite. The configuration has been taylored to my own uses and is designed to I can quickly create VM's

Please see the arch wiki for the official installation guide for ArchLinux. The guide will cover in detail not only in the recommended settings but also how to troubleshoot any issues that may occur. 

Testing push
### Applications
This is the current list of packages that are installed as part of the script.
* base-devel
* git
* grub
* networkmanager
* openssh
* sudo
* vim

### Configurations
The configurations that have taken place that are;
* pending... :)

### Process
_Draft_
**Note**: It's important to move along quickly as some devices will time out which will cause issues.

Boot to Arch PE

enter `loadkeys uk`

Check that'@' and '"' are on the correct keys

Before we can do anything, we need to connect the wifi.

In this instance I am using WiFi

I run `iwctl` to get into the wireless config

Then at the _[iwd]_ prompt run device list to find the wireless card. Mine is **`wlan0`** so I will use this going forward

Next, lets scan for SSID's that you can connect to. I am looking for an visable SSID so don't need to worry about hidden SSID's

Enter `station wlan0 get-networks`

Find the network you want and then enter `station wlan0 connect SSID`, replacing SSID with the relevent SSID. You can tab complete (thankfully)

Enter the passphrase. There will be no confirmation, only an error if the passphrase is wrong.
Enter `exit` to close the wireless config.

Next test the network is working by pinging something on the internet. I'll use archlinux.org

enter `ping archlinux.org`

For me Sucess!


We want to clone this repository locally, we will need git to clone.

Enter `pacman -Syy` to refresh the repository

install git by running `pacman -S git`

Move to the temp folder

`cd /tmp`

Clone the repository within the temp folder
- `git clone https://github.com/notdansls/archBase`

Move into the repository
- `cd archBase`

Start the process by running startInstall.sh
- `./startInstall.sh`


