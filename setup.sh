#!/bin/bash

echo "UEFI Is Required, are you on UEFI? [y/n]"
read UEFICHECK
if [ $UEFICHECK = n ]
	then
		echo "You Must use UEFI to Continue"
        sleep 5
		clear
		exit
fi

clear

echo "Have you connected to Internet? [y/n]"
read INTERNETCONNECT
if [ $INTERNETCONNECT = n ]
	then
		echo "You must be connected to the Internet to Continue"
        sleep 5
		clear
		exit
fi

clear

timedatectl set-ntp true


fdisk -l

echo "What type of drive are you using? [ sda/vda/nvme0n1 ]"
read DRIVETYPE

clear

parted /dev/$DRIVETYPE mklabel gpt
parted /dev/$DRIVETYPE mkpart "EFI" fat32 1MiB 301MiB
parted /dev/$DRIVETYPE set 1 esp on

clear
echo "How much Swap Space do you want? Example: 2GiB, 512MiB"
read SWAPAMOUNT
parted /dev/$DRIVETYPE mkpart "swap" linux-swap 301MiB $SWAPAMOUNT

parted /dev/$DRIVETYPE mkpart "root" ext4 $SWAPAMOUNT 100%

mkfs.ext4 /dev/$DRIVETYPE3
