##!/bin/bash
# vim:tb=2
# lib: Using to install Limux Mint 21.2 Victoria
# made by: Engells
# date: Dec 7, 2023
# content: 

cfgDir="$HOME/ktws/scripts" #cfgDir="$HOME/mnt/dump3/scripts"

_mnt_dirs()
{
  for DIR in bak buf cache doc dump1 dump2 dump3 dump4 iso scripts ramfs tmpfs working xdg
  do
    [[ -d $HOME/mnt/$DIR ]] || mkdir -p $HOME/mnt/$DIR
  done
  sudo chown -R engells:engells $HOME/mnt

  [[ -d $HOME/.config/zz_dot_files ]] || mkdir -p $HOME/.config/zz_dot_files
  [[ -d $HOME/.config/wireplumber ]] || mkdir -p $HOME/.config/wireplumber
  [[ -d $HOME/.local/state ]] || mkdir -p $HOME/.local/state
  [[ -d $HOME/.local/share/themes ]] || mkdir -p $HOME/.local/share/themes
  [[ -d $HOME/.local/share/icons ]] || mkdir -p $HOME/.local/share/icons 

  [[ -d $HOME/downloads ]] && rm -rv $HOME/downloads && ln -sf /tmp/z_downloads $HOME/downloads

  [[ -d $HOME/.cache ]] && mv $HOME/.cache $HOME/cache
  ln -sf /tmp/z_cache $HOME/.cache && mv $HOME/cache/* $HOME/.cache && rm -rv $HOME/cache
}

_user_dirs()
{
  mv $HOME/.config/user-dirs.dirs $HOME/.config/user-dirs.dirs.old
  cp -v $cfgDir/confs_sys/gdm_user_dirs_dirs $HOME/.config/user-dirs.dirs

  for DIR in Desktop Documents Downloads Music Pictures Public Templates Videos
  do
    [[ -d $HOME/$DIR ]] && rmdir $HOME/$DIR
    [[ -d $HOME/mnt/xdg/$DIR ]] || mkdir -p $HOME/mnt/xdg/$DIR
  done
}

_bash_conf()
{
  [[ -d $HOME/.config/bash ]] || mkdir -p $HOME/.config/bash
  for dotFile in profile bashrc bash_logout bash_history
  do
    [[ -f $cfgDir/confs_sys/shell_$dotFile ]] && cp -v $cfgDir/confs_sys/shell_$dotFile $HOME/.config/bash/$dotFile
    [[ -f $HOME/.$dotFile ]] && mv $HOME/.$dotFile $HOME/.config/bash/$dotFile.old
    [[ -f $HOME/.config/bash/$dotFile ]] && ln -sf $HOME/.config/bash/$dotFile $HOME/.$dotFile
  done

  [[ -d $HOME/.config/zz_my_confs ]] || mkdir -p $HOME/.config/zz_my_confs
  cp -v $cfgDir/confs_sys/shell_alias $HOME/.config/zz_my_confs/shell_alias
  cp -v $cfgDir/confs_sys/shell_basic $HOME/.config/zz_my_confs/shell_basic
   #. $HOME/.bashrc
}

_zsh_conf()
{
  [[ -d $HOME/.local/share/oh_my_zsh ]] || mkdir -p $HOME/.local/share/oh_my_zsh
  git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.local/share/oh_my_zsh

  [[ -d $HOME/.config/zsh ]] || mkdir -p $HOME/.config/zsh
  cp -v $cfgDir/confs_sys/shell_zshenv $HOME/.zshenv
  cp -v $cfgDir/confs_sys/shell_zshrc  $HOME/.config/zsh/.zshrc
  sudo chsh -s $(which zsh) $(whoami)
}

_tmux_conf()
{
  [[ -d $HOME/.config/zz_my_confs ]] || mkdir -p $HOME/.config/zz_my_confs
  [[ -d $HOME/.config/tmux/ ]] || mkdir -p $HOME/.config/tmux/

  tDir="$HOME/.config/zz_my_confs"
  cp -v $cfgDir/confs_sys/shell_tmux_conf $HOME/.tmux.conf
  cp -v $cfgDir/confs_sys/shell_tmux_conf_panel     $tDir/tmux_conf_panel
  cp -v $cfgDir/confs_sys/shell_tmux_conf_window    $tDir/tmux_conf_window
  cp -v $cfgDir/confs_sys/shell_tmux_conf_z_others  $tDir/tmux_conf_z_others
  cp -v $cfgDir/confs_sys/shell_tmux_conf_apperance $tDir/tmux_conf_apperance

  #git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
}

_chg_aptsur()
{
  sudo mv /etc/apt/sources.list /etc/apt/sources.old
  sudo cp -v $cfgDir/confs_sys/apt_sources_list /etc/apt/sources.list
  sudo chown root:root /etc/apt/sources.list
  sudo chmod 644 /etc/apt/sources.list
}

_set_fstab()
{
  sudo mv /etc/fstab /etc/fstab.old
  sudo cp -v $cfgDir/confs_sys/init_fstab /etc/fstab
}

_set_grub()
{
  sudo sed -i '/GRUB_TIMEOUT_STYLE/s/hidden/menu/'           /etc/default/grub
  sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/s/quiet splash//' /etc/default/grub
  sudo sed -i '/GRUB_TIMEOUT/s/0/10/'                        /etc/default/grub
  sudo update-grub
}

_nautilus_scripts()
{
  tDir="$HOME/.local/share/nautilus/scripts"
  [[ -d $tDir ]] || mkdir -p $tDir

  sDir="$HOME/ktws/scripts/nautilus_scripts"
  for iFile in $(ls $sDir)
  do
    [[ -f $sDir/$iFile ]] && ln -sf $sDir/$iFile $HOME/.local/share/nautilus/scripts
  done
}

_ebable_sysrq()
{
  sudo sed -i '$a kernel.sysrq = 1'          /etc/sysctl.d/10-console-messages.conf
  sudo sed -i '/kernel.sysrq = 176/s/176/1/' /etc/sysctl.d/10-magic-sysrq.conf
  sudo sed -i '/kernel.sysrq=438/s/#//'      /etc/sysctl.conf
  sudo sed -i '/kernel.sysrq=438/s/438/1/'   /etc/sysctl.conf
  # echo 1 > /proc/sys/kernel/sysrq  # enable sysrq right now
  # sysctl -w kernel.sysrq=1 && echo b > /proc/sysrq-trigger # enable sysrq permanently and reboot right now
}

_set_crontab()
{
  crontab -e
  crontab -l
  #sudo cp -v $cfgDir/confs_sys/cron_engells /var/spool/cron/crontabs/engells
  #sudo chown engells:crontab /var/spool/cron/crontabs/engells
  #sudo chmod a+w /var/spool/cron/crontabs/engells
}

_disable_reclog()
{
  sudo chattr +i $HOME/.local/share/recently-used.xbel  # the file can't edited /immutable => no write, delete, link and so on
}

_set_lxc()
{
  for DIR in distrobox dosbox flatpak lxcd lxcu podman sandbox share storage virt
  do
    [[ -d /zvir/$DIR ]] || sudo mkdir -p /zvir/$DIR
    sudo chown -R engells:engells /zvir/$DIR
  done

  for DIR in discs disks blk_disks blk_parts
  do
    [[ -d /zvir/storage/$DIR ]] || sudo mkdir -p /zvir/storage/$DIR
    sudo chown -R engells:engells /zvir/storage/$DIR
  done

  [[ -d "/var/lib/lxc" ]] && sudo rm -R /var/lib/lxc
  sudo ln -sf /zvir/lxcd /var/lib/lxc

  [[ -d "$HOME/.local/share/lxc" ]] && rm -R $HOME/.local/share/lxc
  ln -sf /zvir/lxcu $HOME/.local/share/lxc

  [[ -f "/etc/default/lxc-net" ]] && sudo mv /etc/default/lxc-net /etc/default/lxc-net.old
  sudo cp -v $cfgDir/confs_sys/lxc_net  /etc/lxc/lxc-net

  [[ -f "/etc/lxc/lxc-usernet" ]] && sudo mv /etc/lxc/lxc-usernet /etc/lxc/lxc-usernet.old
  sudo cp -v $cfgDir/confs_sys/lxc_usernet /etc/lxc/lxc-usernet

  [[ -d "$HOME/.config/lxc" ]] || mkdir -p $HOME/.config/lxc
  [[ -f "$HOME/.config/lxc/default.conf" ]] && mv $HOME/.config/lxc/default.conf $HOME/.config/lxc/default.conf.old
  cp -v $cfgDir/confs_sys/lxc_default_conf $HOME/.config/lxc/default.conf

  chmod a+x $HOME/.local
  chmod a+x $HOME/.local/share
  chmod a+x /zvir/lxcu
}

_set_podman()
{
  for DIR in podman
  do
    [[ -d /zvir/$DIR ]] || sudo mkdir -p /zvir/$DIR
    sudo chown -R engells:engells /zvir/$DIR
  done

  [[ -d "$HOME/.local/share/containers" ]] && sudo rm -R $HOME/.local/share/containers
  ln -sf /zvir/podman $HOME/.local/share/containers

  [[ -d "$HOME/.config/containers" ]] && sudo mkdir -p $HOME/.config/containers
}

_set_flatpak()
{
  for DIR in flatpak/app flatpak/opt flatpak/mnt
  do
    [[ -d /zvir/$DIR ]] || sudo mkdir -p /zvir/$DIR
    sudo chown -R engells:engells /zvir/flatpak
  done

  if [ -d "$HOME/.local/share/flatpak" ]
  then
    cd $HOME/.local/share/flatpak && \
    sudo rsync -avAHX . /zvir/flatpak/opt && \
    cd $HOME && \
    sudo rm -R $HOME/.local/share/flatpak
  fi
  ln -sf /zvir/flatpak/opt $HOME/.local/share/flatpak

  [[ -d "$HOME/.var/app" ]] && sudo rm -R $HOME/.var/app
  ln -sf /zvir/flatpak/app $HOME/.var/app
}

_join_libvirt_group()
{
  sudo adduser $(whoami) kvm
  sudo adduser $(whoami) libvirt
  sudo adduser $(whoami) libvirt-qemu
}

_set_firewall()
{
  [[ -d "/opt/security/iptables" ]] || sudo mkdir -p /opt/security/iptables
  sudo cp -v $cfgDir/confs_sys/secure_iptables_rule  /opt/security/iptables/iptables.rule
  sudo cp -v $cfgDir/confs_sys/secure_iptables_allow /opt/security/iptables/iptables.allow
  sudo cp -v $cfgDir/confs_sys/secure_iptables_deny  /opt/security/iptables/iptables.deny
  sudo chmod a+x /opt/security/iptables/iptables.*

  [[ -f "/lib/systemd/system/rc.local.service" ]] && sudo mv /lib/systemd/system/rc.local.service /lib/systemd/system/rc.local.service.old
  sudo cp -v $cfgDir/confs_sys/init_rc_local_service /lib/systemd/system/rc.local.service

  [[ -f "/etc/rc.local" ]] && sudo mv /etc/rc.local /etc/rc.local.old
  sudo cp -v $cfgDir/confs_sys/init_rc_local /etc/rc.local
  sudo chmod +x /etc/rc.local
  sudo systemctl enable rc.local.service
}

_bak_tmpfs_dir()
{
  [[ -d "/opt/engells" ]] || sudo mkdir -p /opt/engells
  sudo cp -v $cfgDir/confs_sys/z_my_save_sh /opt/engells/zz_mysave.sh
  sudo cp -v $cfgDir/confs_sys/z_my_load_sh /opt/engells/zz_myload.sh
  sudo chmod +x /opt/engells/zz_my*

  [[ -f "/lib/systemd/system/z_my_load_service" ]] || sudo cp -v $cfgDir/confs_sys/z_my_load_service /lib/systemd/system/zz_myload.service
  sudo systemctl enable zz_myload.service

  [[ -f "/lib/systemd/system/z_my_save_service" ]] || sudo cp -v $cfgDir/confs_sys/z_my_save_service /lib/systemd/system/zz_mysave.service
  sudo systemctl enable zz_mysave.service

  [[ -d "/var/backups/log" ]] || sudo mkdir -p /var/backups/log
}

_set_netplan()
{
  [[ -f /etc/netplan/01-network-manager-all.yaml ]] && sudo mv /etc/netplan/01-network-manager-all.yaml \
     /etc/netplan/01-network-manager-all.yaml.old
  sudo cp -v $cfgDir/confs_sys/device_01_network_manager_all_yaml /etc/netplan/01-network-manager-all.yaml
  sudo netplan apply
  #sudo systemctl restart NetworkManager
}

_set_gedit()
{
  gsettings set org.gnome.gedit.preferences.editor use-default-font false
  gsettings set org.gnome.gedit.preferences.editor editor-font 'Monaco Regular 16'
  gsettings set org.gnome.gedit.plugins.externaltools use-system-font false
  gsettings set org.gnome.gedit.plugins.externaltools font 'Monaco Regular 16'
  gsettings set org.gnome.gedit.plugins.pythonconsole use-system-font false
  gsettings set org.gnome.gedit.plugins.pythonconsole font 'Monaco Regular 16'

  gsettings set org.gnome.gedit.preferences.editor scheme 'Solarized Dark'
  gsettings set org.gnome.gedit.preferences.editor insert-spaces true
  gsettings set org.gnome.gedit.preferences.editor tabs-size 2
  gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8','BIG5','GBK','GB18030','GB2312','CURRENT','UTF-16']"
  #gsettings set org.gnome.gedit.plugins active-plugins \
  #  "['filebrowser', 'quickhighlight', 'modelines', 'sort', 'externaltools', 'openlinks', 'docinfo', 'pythonconsole',

  #url: https://github.com/samwhelp/note-about-ubuntu/blob/gh-pages/_demo/adjustment/tool/gedit/config-install.sh
}

_set_fontconfig()
{
 [[ -d $HOME/.config/fontconfig ]] || mkdir -p $HOME/.config/fontconfig
 [[ -f $HOME/.config/fontconfig/fonts.conf ]] && sudo mv $HOME/.config/fontconfig/fonts.conf $HOME/.config/fontconfig/fonts.conf.old
 [[ -f $cfgDir/confs_sys/font_fonts.conf ]] && cp -v $cfgDir/confs_sys/font_fonts.conf $HOME/.config/fontconfig/fonts.conf
}


#==== Back for Ubuntu ==== 

_remove_snap()
{
  sudo snap remove --purge snap-store
  sudo snap remove --purge gtk-common-themes
  sudo snap remove --purge gnome-3-38-2004
  sudo snap remove --purge core20
  sudo snap remove --purge bare 
  sudo snap remove --purge snapd
  sudo apt remove --autoremove snapd
  sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd

  [[ -f /etc/apt/preferences.d/nosnap.pref ]] || sudo touch /etc/apt/preferences.d/nosnap.pref
  echo '## Disable snap' > /etc/apt/preferences.d/nosnap.pref
  sudo sed -i '$a Package: snapd'    /etc/apt/preferences.d/nosnap.pref
  sudo sed -i '$a Pin: release a=*'  /etc/apt/preferences.d/nosnap.pref
  sudo sed -i '$a Pin-Priority: -10' /etc/apt/preferences.d/nosnap.pref
}

_set_locale()
{
  sudo mv /var/lib/locales/supported.d/local   /var/lib/locales/supported.d/local.old
  sudo cp -v $cfgDir/confs_sys/locale_local    /var/lib/locales/supported.d/local
  sudo mv /var/lib/locales/supported.d/en      /var/lib/locales/supported.d/en.old
  sudo mv /var/lib/locales/supported.d/zh-hant /var/lib/locales/supported.d/zh-hant.old
  #sudo locale -a
  #sudo locale-gen zh_TW.UTF-8
  sudo locale-gen --purge
  #sudo dpkg-reconfigure locales
}

_vim_conf()
{
  [[ -d $HOME/.vim/confs ]] || mkdir -p $HOME/.vim/confs && cp -v $cfgDir/confs_vim/exrc* $HOME/.vim/confs
  [[ -f $HOME/.vimrc ]] ||  mv $HOME/.vimrc $HOME/.vimrc.old &&   ln -sf $HOME/.vim/confs/exrc_vim $HOME/.vim/vimrc
  [[ -f $HOME/.gvimrc ]] || mv $HOME/.gvimrc $HOME/.gvimrc.old && ln -sf $HOME/.vim/confs/exrc_gvim $HOME/.vim/gvimrc

  [[ -d $HOME/.vim/autoload ]] || mkdir -p $HOME/.vim/autoload
  [[ -d $HOME/.vim/pack ]] || mkdir -p $HOME/.vim/pack && mkdir -p $HOME/.vim//pack/{start,opt}

  #cd $HOME/.vim/autoload/ && curl -O https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

_set_zhfonts()
{
  [[ -d $HOME/.config/fontconfig/conf.d ]] || mkdir -p $HOME/.config/fontconfig/conf.d
  [[ -d $HOME/.local/share/fonts ]] || mkdir -p $HOME/.local/share/fonts

  [[ -d "/usr/share/fonts/z_usr" ]] || sudo mkdir -p /usr/share/fonts/z_usr

  for  font_file in Heiti.ttf Monaco.ttf Consola.ttf
  do
    sudo cp -v $HOME/mnt/tmpfs/$font_file /usr/share/fonts/z_usr
  done

  sudo chmod 755 /usr/share/fonts/z_usr/*.ttf

  sudo fc-cache -f -v

  [[ -e "/etc/fonts/conf.avail/69-language-selector-zh-tw.conf" ]] || \
  sudo cp -v $cfgDir/confs_sys/font_69_language_selector_zh_tw_conf /etc/fonts/conf.avail/69-language-selector-zh-tw.conf

  #sudo ln -sf /etc/fonts/conf.avail/69-language-selector-zh-tw.conf /etc/fonts/conf.d/

  [[ -e "/etc/fonts/conf.avail/30-cjk-aliases.conf" ]] || \
  sudo cp -v $cfgDir/confs_sys/font_30_cjk_aliases_conf /etc/fonts/conf.avail/30-cjk-aliases.conf

  #sudo ln -sf /etc/fonts/conf.avail/30-cjk-aliases.conf /etc/fonts/conf.d/
}

_add_themes()
{
  [[ -d "/usr/share/icons" ]] || sudo mkdir -p /usr/share/icons
  sudo tar -xzvf $HOME/mnt/tmpfs/cursors.tar.gz -C /usr/share/icons

  [[ -d "$HOME/.themes" ]] || mkdir -p $HOME/.themes
  sudo tar -xzvf $HOME/mnt/tmpfs/themes.tar.gz -C $HOME/.themes

  [[ -d "$HOME/.icons" ]] || mkdir -p $HOME/.icons
  sudo tar -xzvf $HOME/mnt/tmpfs/icons.tar.gz -C $HOME/.icons

  [[ -d /usr/share/gnome-shell/theme/ubuntu.css ]] && \
     sudo cp -v /usr/share/gnome-shell/theme/ubuntu.css /usr/share/gnome-shell/theme/ubuntu.css.old
  sudo cp -v $sDir/gdm_ubuntu_css /usr/share/gnome-shell/theme/ubuntu.css
  # /etc/alternatives/default.plymouth
}

_disable_automount()
{
  sudo gsettings set org.gnome.desktop.media-handling automount false
  sudo gsettings set org.gnome.desktop.media-handling automount-open false
  # sudo gsettings set org.gnome.desktop.media-handlingautomount true
  # sudo gsettings set org.gnome.desktop.media-handling automount-open true

}

_shortcut_utils()
{
  sudo ln -sf $cfgDir/avails/kthcrypt_dir.sh  /usr/local/bin/kthd
  sudo ln -sf $cfgDir/avails/kthcrypt_part.sh /usr/local/bin/kthp
  sudo ln -sf $cfgDir/avails/kthcrypt_bak.sh  /usr/local/bin/kthb
  sudo ln -sf $cfgDir/avails/virt_module.sh   /usr/local/bin/virtm
  sudo ln -sf $cfgDir/avails/virt_net.sh      /usr/local/bin/virtn
}

_cp_files()
{
  tDir="$HOME/mnt/tmpfs"

  sDir="$HOME/ktws/0_sur_fonts"
  cp -v $sDir/Apple/Heiti-SC-Medium-6.1-d23.ttf $tDir/Heiti.ttf
  cp -v $sDir/Apple/Monaco.ttf $tDir/Monaco.ttf
  cp -v $sDir/Apple/Monaco_Linux_Powerline $tDir/Monaco_Linux_Powerline
  cp -v $sDir/Microsoft/consola.ttf $tDir/Consola.ttf
  #cp -v $sDir/TW_Gov/TW-Kai-98.1.ttf $tDir/TW-Kai.ttf
  #cp -v $sDir/TW_Gov/TW-Sung-98.1.ttf $tDir/TW-Sung.ttf
}


