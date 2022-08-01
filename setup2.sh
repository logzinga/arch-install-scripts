#!/bin/bash

clear
echo "Do you need to connect to wifi? [ y/n ]"
read WIFICHECK
if [ $WIFICHECK = y ]
        then
            echo "Entering NetworkManager Interface..."
            sleep 1
            nmtui
fi

clear
echo "What country are you in?"
read COUNTRY
sleep 2

clear
echo "What city is your timezone set to?"
read CITY
sleep 2


clear
echo "Setting Timezone..."
sleep 1
ln -sf /usr/share/zoneinfo/$COUNTRY/$CITY /etc/localtime

hwclock --systohc

clear
echo "Would you like to enter your locales manually or have it set to default? [ m/d ]"
read LOCALEMD
    if [ $LOCALEMD = m ]
     then
        nano /etc/locale.gen
        locale-gen
        echo "Now set the LANG variable accordingly."
        nano /etc/locale.conf
fi
if [ $LOCALEMD = d ]
     then
        rm /etc/locale.gen
        cp files/locale.gen /etc/
        cp files/locale.conf /etc/
fi

clear
echo "In the NANO program that should appear, enter what you want to call your Computer."
sleep 5
nano /etc/hostname

clear
echo "Running mkinitcpio..."
sleep 5
mkinitcpio -P

clear
echo "Would you like to have a Root Account? [ y/n ]"
read $ROOTACC
    if [ $ROOTACC = y ]
        then
            echo "Creating Root Account..."
            sleep 1
            passwd
            echo "Account Created!"
fi

clear
echo "Do you have NVIDIA Graphics? [ y/n ]"
read NVIDIAGPU
    if [ $NVIDIAGPU = y ]
        then
            clear
            echo "Do you have a newer NVIDIA Graphics Card? [ y/n ]" # this line doesnt include the minimum nvidia graphics card to support the nvidia package... FIXME
            read NVIDIAGPUNEW
                if [ $NVIDIAGPUNEW = y ]
                    then
                        pacman -Syu nvidia nvidia-settings nvidia-utils nvidia-prime --noconfirm 
                fi 
                if [ $NVIDIAGPUNEW = n ]
                    then
                        clear
                                        # this if statement contains nothing, it should contain older NVIDIA driver choices. FIXME
                    fi   

    fi

clear
echo "Installing GRUB..."
sleep 2
pacman -Syu grub efibootmgr intel-ucode amd-ucode
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

clear
echo "Would you like to have KDE or No Desktop Enviornment (more coming soon) [ kde / gnome / none ]"
read DESKTOPENVIRONMENT
 if [ $DESKTOPENVIRONMENT = kde ]
    then
        clear
        echo "Installing KDE..."
        pacman -Syu plasma plasma-wayland-session sddm --noconfirm
        clear
        echo "Installing KDE Applications..."
        pacman -Syu kde-applications --noconfirm
        pacman -R konqueror --noconfirm
        echo "Enabling SDDM..."
        sleep 2
        systemctl enable sddm
fi
 if [ $DESKTOPENVIRONMENT = gnome ] # GNOME needs to be worked apon, UPDATE
    then
        clear
        echo "Installing GNOME..."
        pacman -Syu gnome gdm --noconfirm # yes i do know gdm has issues with NVIDIA graphics on laptops, FIXME
        clear
        echo "Emabiing GDM..."
        sleep 2
        systemctl enable gdm
fi

clear
echo "Would you like to add a user account? [ y/n ]"
read USERACC
    if [ $USERACC = y ]
        then 
            clear
            echo "What would you like to name the User?"
            read USERACCNAME
            echo "Would you like the User to be a Superuser? [ y/n ]"
            read SUPERUSERACC
                if [ $SUPERUSERACC = y ]
                    then
                        clear
                        useradd -m -G wheel $USERACCNAME
                        echo "Passsword for Superuser Account:"
                        passwd $USERACCNAME
                fi
                if [ $SUPERUSERACC = n ]
                    then
                        clear
                        useradd -m $USERACCNAME
                        echo "Password for User Account:"
                        passwd $USERACCNAME
                fi
    fi
clear
echo "Installing Sudo..."
sleep 5
cp files/sudoers /etc/sudoers
pacman -Syu sudo --noconfirm

clear
echo "Would you like to download Firefox or Chromium? [ firefox/chromium ]"
read BROWSER
    if [ $BROWSER = firefox ]
        then
            pacman -Syu firefox --noconfirm
    fi
    if [ $BROWSER = chromium ]
        then
            pacman -Syu chromium --noconfirm
    fi

clear
echo "Configuring Pacman..."
sleep 3
rm /etc/pacman.conf
cp files/pacman.conf /etc/pacman.conf

if [ $NVIDIAGPUNEW = y ]
                    then
                        clear
                        echo "Installing NVIDIA Drivers..."             # it would be better if i named it something along 32-bit, whatever
                        pacman -Syu lib32-nvidia-utils --noconfirm 
                fi 

clear
echo "You have finished your install of Arch Linux!"
echo "When you are ready you can restart your computer."
echo "If you want to leave the install, do exit then reboot."


