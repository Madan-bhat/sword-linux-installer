#!/usr/bin/env bash
echo -ne "
--------------------------------------------------------------------------------------------------------
███████╗██╗    ██╗ ██████╗ ██████╗ ██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔════╝██║    ██║██╔═══██╗██╔══██╗██╔══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
███████╗██║ █╗ ██║██║   ██║██████╔╝██║  ██║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
╚════██║██║███╗██║██║   ██║██╔══██╗██║  ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
███████║╚███╔███╔╝╚██████╔╝██║  ██║██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                                                                                     
--------------------------------------------------------------------------------------------------------
                    Automated Arch Linux Installer
                        SCRIPTHOME: sword linux
--------------------------------------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/sword-linux-installer/configs/setup.conf

  cd ~
  mkdir "/home/$USERNAME/.cache"
  touch "/home/$USERNAME/.cache/zshhistory"
  git clone "https://github.com/ChrisTitusTech/zsh"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  ln -s "~/zsh/.zshrc" ~/.zshrc

sed -n '/'$INSTALL_TYPE'/q;p' ~/sword-linux-installer/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]
  then
    # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
    continue
  fi
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed ${line}
done


if [[ ! $AUR_HELPER == none ]]; then
  cd ~
  git clone "https://aur.archlinux.org/$AUR_HELPER.git"
  cd ~/$AUR_HELPER
  makepkg -si --noconfirm
  # sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
  # stop the script and move on, not installing any more packages below that line
  sed -n '/'$INSTALL_TYPE'/q;p' ~/sword-linux-installer/pkg-files/aur-pkgs.txt | while read line
  do
    if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
      # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
      continue
    fi
    echo "INSTALLING: ${line}"
    $AUR_HELPER -S --noconfirm --needed polybar ${line}
  done
fi

export PATH=$PATH:~/.local/bin

# Theming DE if user chose FULL installation
if [[ $INSTALL_TYPE == "FULL" ]]; then
  if [[ $DESKTOP_ENV == "kde" ]]; then
    cp -r ~/sword-linux-installer/configs/.config/* ~/.config/
    pip install konsave
    konsave -i ~/sword-linux-installer/configs/kde.knsv
    sleep 1
    konsave -a kde

  elif [[ $DESKTOP_ENV == "xmonad" ]];then 
  $AUR_HELPER -S --no-confirm ttf-dejavu ttf-liberation nerd-fonts-jetbrains-mono
  cd ~
  pacman -S base-devel
  git clone https://github.com/Madan-bhat/sword-linux-xmonad.git
  cd sword-linux-xmonad
  makepkg -si 
  cp -r /etc/skel/.xmonad  /home/$USERNAME/.xmonad 

  elif [[ $DESKTOP_ENV == "openbox" ]]; then
    cd ~
    git clone https://github.com/stojshic/dotfiles-openbox
    ./dotfiles-openbox/install-titus.sh
  fi
fi

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit
