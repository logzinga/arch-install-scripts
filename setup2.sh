#!/bin/bash

clear
echo "Do you need to connect to wifi? [ y/n ]"
read WIFICHECK
if [ $WIFICHECK = y]
        then
            echo "Entering NetworkManager Interface..."
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
ln -sf /usr/share/zoneinfo/$COUNTRY/$CITY etc/localtime
hwclock --systohc

clear
echo "Would you like to enter your locales manually or have it set to default? [ m/d ]"
read LOCALEMD
    if []
nano /etc/locale.gen

clear

