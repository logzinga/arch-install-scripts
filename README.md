# log's arch linux install scripts
personal install scripts, just to make life easier for me

apologies if this repo is really bad. i am not good at this stuff

# How To Use

* Install git (pacman -S git)

* Clone Repo (git clone https://github.com/logzinga/arch-install-scripts.git)

* Go into folder (cd arch-install-scripts)

* give setup.sh permissions (chmod +777 setup.sh)

* Open setup.sh (./setup.sh)

# Plans
* Have a WiFi dialogue for Inital Setup

* Wiki page for issues

## Disclaimer

i don't have a huge amount of hardware to test this script on, things might not work as planned.

# Issues

### When installing git you could run into an issue with PGP Signatures.

This can be Solved by doing the command "pacman -Sy archlinux-keyring".

If that didn't work, sync your clock with "hwclock -w"

If that didn't work, remove /etc/pacman.d/gnupg (rm /etc/pacman.d/gnupg) and then run "pacman-key --init" then run "pacman-key --populate"

More Information: https://wiki.archlinux.org/title/Pacman/Package_signing#Upgrade_system_regularly
