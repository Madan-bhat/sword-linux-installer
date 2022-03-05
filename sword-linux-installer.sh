#!/bin/bash

echo -ne "
-------------------------------------------------------------------------
███████╗██╗    ██╗ ██████╗ ██████╗ ██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔════╝██║    ██║██╔═══██╗██╔══██╗██╔══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
███████╗██║ █╗ ██║██║   ██║██████╔╝██║  ██║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
╚════██║██║███╗██║██║   ██║██╔══██╗██║  ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
███████║╚███╔███╔╝╚██████╔╝██║  ██║██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                                                                                     
-------------------------------------------------------------------------
"


# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts
CONFIGS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/configs
set +a
echo -ne "
-------------------------------------------------------------------------
SWORD LINUX
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Scripts are in directory named sword linux
"
    ( bash $SCRIPT_DIR/scripts/startup.sh )|& tee startup.log
      source $CONFIGS_DIR/setup.conf
    ( bash $SCRIPT_DIR/scripts/0-preinstall.sh )|& tee 0-preinstall.log
    ( arch-chroot /mnt $HOME/sword-linux-installer/scripts/1-setup.sh )|& tee 1-setup.log
    if [[ ! $DESKTOP_ENV == server ]]; then
      ( arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/sword-linux-installer/scripts/2-user.sh )|& tee 2-user.log
    fi
    ( arch-chroot /mnt $HOME/sword-linux-installer/scripts/3-post-setup.sh )|& tee 3-post-setup.log
    cp -v *.log /mnt/home/$USERNAME

echo -ne "
-------------------------------------------------------------------------
███████╗██╗    ██╗ ██████╗ ██████╗ ██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔════╝██║    ██║██╔═══██╗██╔══██╗██╔══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
███████╗██║ █╗ ██║██║   ██║██████╔╝██║  ██║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
╚════██║██║███╗██║██║   ██║██╔══██╗██║  ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
███████║╚███╔███╔╝╚██████╔╝██║  ██║██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                                                                                     
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Done - Please Eject Install Media and Reboot
"
