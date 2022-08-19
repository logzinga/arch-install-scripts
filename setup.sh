#!/bin/bash

clear
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
ntpd -qg
hwclock -w


fdisk -l

sleep 1

echo "What type of drive are you using? [ sda/vda/nvme0n1 ]" # add more drive types if possible
read DRIVETYPE

clear

echo "Partitioning..."

sleep 1

parted /dev/$DRIVETYPE mklabel gpt
parted /dev/$DRIVETYPE mkpart "EFI" fat32 1MiB 301MiB
parted /dev/$DRIVETYPE set 1 esp on

clear
echo "How much Swap Space do you want? Example: 2GiB, 512MiB"
read SWAPAMOUNT
parted /dev/$DRIVETYPE mkpart "swap" linux-swap 301MiB $SWAPAMOUNT

parted /dev/$DRIVETYPE mkpart "root" ext4 $SWAPAMOUNT 100%

clear
echo "Formatting Partitions..." 
sleep 2
if [ $DRIVETYPE = vda ]
	then
		mkfs.ext4 /dev/vda3
        mkswap /dev/vda2
        mkfs.fat -F 32 /dev/vda1

        mount /dev/vda3 /mnt 
        mount --mkdir /dev/vda1 /mnt/boot
        swapon /dev/vda2
fi
if [ $DRIVETYPE = sda ]
	then
		mkfs.ext4 /dev/sda3
        mkswap /dev/sda2
        mkfs.fat -F 32 /dev/sda1

        mount /dev/sda3 /mnt 
        mount --mkdir /dev/sda1 /mnt/boot
        swapon /dev/sda2
fi
if [ $DRIVETYPE = nvme0n1 ]
	then
		mkfs.ext4 /dev/nvme0n1p3
        mkswap /dev/nvme0n1p2
        mkfs.fat -F 32 /dev/nvme0n1p1

        mount /dev/nvme0n1p3 /mnt 
        mount --mkdir /dev/nvme0n1p1 /mnt/boot
        swapon /dev/nvme0n1p2
fi

clear
echo "Installing Arch Packages..."
pacman -Sy archlinux-keyring --noconfirm
sleep 1
pacstrap /mnt base linux linux-firmware nano dkms

clear
echo "Generating fstab..."
sleep 1
genfstab -U /mnt >> /mnt/etc/fstab

clear
echo "Installing Git..."
sleep 1
pacstrap /mnt git

clear
echo "Installing NetworkManager..."
sleep 1
pacstrap /mnt networkmanager


clear
echo "You are now booting into the Chroot environment."
sleep 3
echo "When ready, type 'git clone https://github.com/logzinga/arch-install-scripts.git' "
echo "then type 'cd arch-install-scripts'"
echo "then type './setup2.sh'"
arch-chroot /mnt




