#!/bin/bash

#if [ $EUID -ne 0 ]
#        then
#                echo "This program must run as root to function." # Depricated
#                exit 1
#fi

echo "these preset scripts are under construction, somethings may not work as intended. report any issues to GitHub."

sleep 2

clear

echo "This scipt will install some basic applications you might need for playing/editing audio."
sleep 2
echo "Do you want to continue? ( y / n )"
read CONTINUE 
if [ $CONTINUE = n ]
    then
        exit
fi

echo "Are you connected to the Internet? ( y / n )"
read INTERNETCHECK
if [ $INTERNETCHECK = n ]
    then
        echo "You require internet to use this script."
        sleep 2
        exit
fi

echo "Installing Audacity..."
sudo pacman -Syu audacity --noconfirm

echo "Installing Pulseaudio Volume Control..."
sudo pacman -Syu pavucontrol --noconfirm

echo "Installing VLC..."
sudo pacman -Syu vlc --noconfirm

echo "Installing Cider..."
cd /tmp
git clone https://aur.archlinux.org/cider.git
cd cider
makepkg -csi

echo "Installing Spotify..."
cd /tmp
git clone https://aur.archlinux.org/spotify.git
cd spotify
makepkg -csi

echo "These are the bare basics for music, feel free to suggest things i should add to this script via GitHub." # its so empty
sleep 2
