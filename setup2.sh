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
echo "What timezone is your country in?"
read COUNTRY
sleep 2
                                        # i absolutely hate how im doing the timezone selection, FIXME
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
echo "What would you like to call your computer? (no spaces or special characters)"
read COMPUTERNAME
echo $COMPUTERNAME >> /etc/hostname 


clear
echo "Running mkinitcpio..."
sleep 5
mkinitcpio -P

clear
echo "Would you like to have a Root Account? [ y/n ]"
read ROOTACC
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
            echo "Do you have a newer NVIDIA Graphics Card? (GeForce GTX 745 or higher) [ y/n ]"
            read NVIDIAGPUNEW
                if [ $NVIDIAGPUNEW = y ]
                    then
                        pacman -Syu nvidia nvidia-settings nvidia-utils nvidia-prime --noconfirm 
                fi 
                if [ $NVIDIAGPUNEW = n ]
                    then
                        clear
                        echo "What NVIDIA driver version would you like? [ 470 / 390 / nouveau ]"   # not enough driver choices.
                        read OLDNVIDIADRIVER
                        if [ $OLDNVIDIADRIVER = 470 ]
                            then
                                clear
                                echo "Installing NVIDIA Driver 390..."
                                sleep 2
                                git clone https://aur.archlinux.org/nvidia-390xx-utils.git
                                cd nvidia-390xx-utils
                                makepkg -csi 
                                clear
                                echo "Cleaning Up..."
                                cd ..
                                rm -R nvidia-390xx-utils
                            fi
                            if [ $OLDNVIDIADRIVER = 390 ]
                            then
                                clear
                                echo "Installing NVIDIA Driver 470..."
                                sleep 2
                                git clone https://aur.archlinux.org/nvidia-470xx-utils.git
                                cd nvidia-470xx-utils
                                makepkg -csi 
                                clear
                                echo "Cleaning Up..."
                                cd ..
                                rm -R nvidia-470xx-utils
                            fi
                    fi   

    fi

clear
echo "Installing GRUB..."
sleep 2
pacman -Syu grub efibootmgr intel-ucode amd-ucode --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

clear
echo "Would you like to have a Desktop Enviornment (more coming soon) [ kde / gnome / xfce / none ]"
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
if [ $DESKTOPENVIRONMENT = xfce ]
    then 
        clear
        echo "Installing xfce..."
        pacman -Syu xfce4 sddm --noconfirm # i don't like xfce using sddm, FIXME
        clear
        echo "Enabling SDDM..."
        sleep 2
        systemctl enable sddm
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
echo "Would you like to download a GUI Browser? [ firefox / chromium / none ]"
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

if [ $NVIDIAGPU = y ]
                    then
                        clear
                        echo "Installing 32-Bit NVIDIA Drivers..."
                        pacman -Syu lib32-nvidia-utils --noconfirm 
                fi 

clear
echo "You have finished your install of Arch Linux!"
echo "When you are ready you can restart your computer."
echo "If you want to leave the install, do exit then reboot."


