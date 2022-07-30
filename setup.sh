#!/bin/bash

echo "Have you connected to Internet? [y/n]"
read INTERNETCONNECT
if [ $INTERNETCONNECT = n ]
	then
		echo "You must be connected to the Internet to Continue"
		clear
		exit
fi

timedatectl set-ntp true


fdisk -l

echo "What type of drive are you using? [ sda/vda/nvme0n1 ]"
read DRIVETYPE

fdisk /dev/$DRIVETYPE

g
n
1

+300M

t
1

n 
2

+16G

t 
2
19

n 
3



w 

