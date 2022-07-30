#!/bin/bash

echo "UEFI Is Required, are you on UEFI? [y/n]"
read UEFICHECK
if [ $UEFICHECK = n ]
	then
		echo "You Must use UEFI to Continue."
		clear
		exit
fi

clear

echo "Have you connected to Internet? [y/n]"
read INTERNETCONNECT
if [ $INTERNETCONNECT = n ]
	then
		echo "You must be connected to the Internet to Continue"
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
parted /dev/$DRIVETYPE mkpart "EFI system partition" fat32 1MiB 301MiB
parted /dev/$DRIVETYPE set 1 esp on
