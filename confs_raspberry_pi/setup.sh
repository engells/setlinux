#!/bin/bash

SOUR_DIR=$HOME/sur
sudo apt update

# 無線環境設定
sudo cp $SOUR_DIR/wap_supplocant.service /etc/systemd/system/
sudo cp $SOUR_DIR/unblock_wifi.service /etc/systemd/system/
sudo cp $SOUR_DIR/rc_local.service /etc/systemd/system/
sudo cp $SOUR_DIR/wifi.conf /etc/wpa_supplicant/
sudo cp $SOUR_DIR/01_default.yaml /etc/netplan/
sudo apt install rfkill wireless-tools wpasupplicant
sudo rfkill unblock wifi
sudo netplan --debug try
sudo netplan --debug generate
sudo systemctl daemon-reload
sudo netplan --debug apply
#sudo wpa_supplicant -B -c /etc/wpa_supplicant/wifi.conf -i wlan0
sudo systemctl enable wpa_supplicant.service unblock_wifi.service rc_local.service
sudo systemctl disable connman.service NetworkManager.service

# 移除 snap
sudo systemctl stop snapd
sudo apt purge snapd
rm -rvf ~/snap
sudo rm -rvf /snap /var/snap /var/lib/snap /var/cache/snap /usr/lib/snap
sudo cp $SOUR_DIR/no-snap.pref /etc/apt/preferences.d/

# clound-init
sudo apt purge cloud-init
sudo rm -Rf /etc/cloud

# 安裝 GUI
sudo apt install --no-install-recommends --no-install-suggests xserver-xorg-core
sudo apt install --no-install-recommends --no-install-suggests openbox
sudo apt-get install xinit x11-xserver-utils
sudo apt-get install slim

# 切換 Lubuntu GUI 與 CLI
sudo systemctl disable display-manager && sudo ln -s -f /dev/null /etc/systemd/system/display-manager.service

# 中文環境支援
sudo apt install language-pack-zh-hant language-pack-zh-hans ibus ibus-chewing
#sudo vim /etc/fonts/fonts.conf

# X-window 設置
[[ -d  $HOME/.config/i3 ]] || mkdir -p $HOME/.config/i3 && cp $SOUR_DIR/i3_conf.txt $HOME/.config/i3/config
[[ -d  $HOME/.config/i3status ]] || mkdir -p $HOME/.config/i3status && cp $SOUR_DIR/i3_status_conf.txt $HOME/.config/i3status/config
[[ -f  $HOME/.xinitrc ]]  && mv $HOME/.xinitrc $HOME/.xinitrc.bak
[[ -f  $HOME/.Xresources ]]  && mv $HOME/.xinitrc $HOME/.Xresources.bak
cp $SOUR_DIR/i3_xinitrc $HOME/.xinitrc
cp $SOUR_DIR/rxvt_Xresources.txt  $HOME/.Xresources

# 其他
sudo apt install libraspberrypi-bin


