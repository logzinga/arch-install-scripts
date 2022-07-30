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
echo "The next part will need user input in NANO, we are now setting locales, if you don't know what locales you need, only uncomment [ en_US.UTF-8 UTF-8 ]"
sleep 10
nano /etc/locale.gen

clear

