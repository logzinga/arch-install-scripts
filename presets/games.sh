#!/bin/bash

# if [ $EUID -ne 0 ]
#        then
#               echo "This program must run as root to function." # depricated
#               exit 1
#fi

echo "Are you connected to the Internet? ( y / n )"
read INTERNETCHECK
if [ $INTERNETCHECK = n ]
    then
        echo "You require internet to use this script."
        sleep 2
        exit
fi

echo "This scipt will install (almost) everything you need for playing le funny video game on your computer."
sleep 2
echo "Do you want to continue? ( y / n )"
read CONTINUE 
if [ $CONTINUE = n ]
    then
        exit
fi

echo "Installing Wine..."
sudo pacman -Syu wine winetricks --noconfirm

echo "Installing Flatpak..."
sudo pacman -Syu flatpak --noconfirm

echo "Installing Steam..."
sudo pacman -Syu Steam --noconfirm

echo "Installing Lutris..."
sudo pacman -Syu lutris --noconfirm

echo "Installing Heroic..." 
cd /tmp
git clone https://aur.archlinux.org/heroic-games-launcher-bin.git
cd heroic-games-launcher-bin
makepkg -csi
cd ~

echo "Installing yay..." 
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -csi


echo "You should have a good amount of applications to help you play your games."
sleep 2
echo "If you would like anything added to this script, feel free to open an Issue on GitHub."
sleep 2

