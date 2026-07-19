#!/bin/bash
# vim:ts=2
# program: Using to build up environemt for a lxc container 
# made by: Engells
# date: Jul 4, 2022
# content: 

# add a stand user for virtual machine, and add authorition of sudo to user
sudo adduser --home /home/admit admit
sudo sed -i '/ubuntu/s/^/#/'                      etc/sudoers.d/90-lxd
sudo sed -i '$a admit ALL=(ALL:ALL) NOPASSWD:ALL' etc/sudoers.d/90-lxd


# add tmpfs folders in container
mkdir {/mnt/share,/mnt/tmpfs,/home/admit/.cache,/home/admit/downloads}


# install packages
sudo apt update && sudo apt install vim-nox openssh-server && \
  sudo apt autoremove ; sudo apt autoclean ; sudo apt clean


# set X forwarding file
touch /home/admit/.Xauthority && sudo chown admit:admit /home/admit/.Xauthority


# set ssh connection environment
sudo sed -i '$a PermitRootLogin no' /etc/ssh/sshd_config
sudo sed -i '$a AllowUsers admit' /etc/ssh/sshd_config
sudo sed -i '$a AllowGroups admit' /etc/ssh/sshd_config
sudo sed -i '$a PermitEmptyPasswords no' /etc/ssh/sshd_config
sudo sed -i '$a Protocol 2' /etc/ssh/sshd_config
sudo sed -i '$a X11UseLocalhost no' /etc/ssh/sshd_config


# set a static ip to lxc container
[[ -f /etc/netplan/10-lxc.yaml ]] && mv /etc/netplan/10-lxc.yaml /etc/netplan/10-lxc.yaml.old
[[ -f /etc/netplan/10-lxc.yaml ]] touch /etc/netplan/10-lxc.yaml

sudo sed -i '$a \network:' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \  version: 2' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \  ethernets:' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \    eth0:' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \      addresses: [172.25.3.10/24]' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \      gateway4: 172.25.3.1' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \      dhcp4: no' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \      dhcp6: no' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \      optional: true' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \      nameservers:' /etc/netplan/10-lxc.yaml
sudo sed -i '$a \        addresses: [8.8.8.8, 8.8.4.4]' /etc/netplan/10-lxc.yaml


# build cjk environment
[[ -f /var/lib/locales/supported.d/local ]] || sudo touch /var/lib/locales/supported.d/local
sudo echo '#' > /var/lib/locales/supported.d/local
sudo sed -i '$a en_US.UTF-8 UTF-8' /var/lib/locales/supported.d/local
sudo sed -i '$a zh_TW.UTF-8 UTF-8' /var/lib/locales/supported.d/local

sudo apt update && apt install fontconfig	localepurge language-pack-zh-hans fonts-noto-cjk && \
  sudo apt autoremove ; sudo apt autoclean ; sudo apt clean
sudo locale-gen --purge
sudo dpkg-reconfigure localepurge
sudo fc-cache -f -v

for iFile in $(ls $HOME/downloads)
do
  oFile=$(basename $sFile | sed '/^font/s/font_//' | sed '/_conf/s/_conf/\.conf/')
  if [ ${iFile##*\_} = "conf" ]; then sudo cp -v $HOME/downloads/$iFile /etc/fonts/conf.avail/$oFile && \
    sudo ln -sf /etc/fonts/conf.avail/$oFile /etc/fonts/conf.d/ ; fi
done
# fc-list


# download chrome brower
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
[[ -f /etc/apt/sources.list.d/google-chrome.list ]] || sudo touch /etc/apt/sources.list.d/google-chrome.list
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

echo "alias cbn='google-chrome 1>/dev/null 2>/dev/null &'" >> /home/admit/.bashrc
echo "PS1='\033[01;32m\]\u@\h \033[01;34m\]\W\033[0m\]\$ '" >> /home/admit/.bashrc


# exit container and do the following commands in host
# ssh-copy-id -p 62 -i $HOME/.ssh/id_rsa.pub admit@172.25.3.1x
# scp $HOME/.config/zsh/.zsh admit@172.25.3.1x:/home/admit/


