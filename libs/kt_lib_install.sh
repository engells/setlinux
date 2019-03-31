# vim:ts=4
# lib: Using to install Ubuntu 18.04
# made by: Engells
# date: Mar 25, 2019
# content: 

cfgDir="/home/engells/ktws/scripts/confs_sys"

_chg_aptsur()
{
	sudo mv /etc/apt/sources.list /etc/apt/sources.bak
	sudo cp $cfgDir/sources.list /etc/apt/sources.list
	sudo chown root:root /etc/apt/sources.list
	sudo chmod 644 /etc/apt/sources.list
}

_set_grub()
{
	sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/s/quiet splash//' /etc/default/grub
	sudo update-grub
}

_mnt_dirs()
{
	[ -d /home/engells/mnt ] || mkdir -p /home/engells/mnt

	for DIR in bak buf cache doc dump1 dump2 dump3 dump4 iso scripts ramfs tmpfs
	do
		[ -d /home/engells/mnt/$DIR ] || mkdir -p /home/engells/mnt/$DIR
	done

	sudo chown -R engells:engells /home/engells/mnt

	for DIR in dosbox lxcd lxcu virt
	do
		[ -d /home/$DIR ] || sudo mkdir -p /home/$DIR
		sudo chown -R engells:engells /home/$DIR
	done

	for DIR in discs disks share
	do
		[ -d /home/virt/$DIR ] || sudo mkdir -p /home/virt/$DIR
		sudo chown -R engells:engells /home/virt/$DIR
	done

	[ -d /home/engells/downloads ] || mkdir /home/engells/downloads

	sudo chown -R engells:engells /home/engells/downloads
}

_user_dirs()
{
	mv /home/engells/.config/user-dirs.dirs /home/engells/.config/user-dirs.dirs.bak
	cp $cfgDir/xdg_user_dirs_dirs /home/engells/.config/user-dirs.dirs

	for DIR in Documents Downloads Music Pictures Public Templates Videos
	do
		[ -d /home/engells/$DIR ] && rmdir /home/engells/$DIR
		[ -d /home/engells/mnt/xdg/$DIR ] || mkdir -p /home/engells/mnt/xdg/$DIR
	done

	mv /home/engells/Desktop /home/engells/desktop
}

_cp_files()
{
	tDir="/home/engells/mnt/tmpfs"

	sDir="/home/engells/ktws/0_sur_linux"
	#cp $sDir/themes/Theme-Elementary-Gtk-3.x.tar.gz $tDir/themes.tar.gz

	sDir="/home/engells/ktws/0_sur_fonts"
	cp $sDir/Apple/Heiti-SC-Medium-6.1-d23.ttf $tDir/Heiti.ttf
	cp $sDir/Apple/Monaco.ttf $tDir/Monaco.ttf
	cp $sDir/TW_Gov/TW-Kai-98.1.ttf $tDir/TW-Kai.ttf
	cp $sDir/TW_Gov/TW-Sung-98.1.ttf $tDir/TW-Sung.ttf
	cp $sDir/Microsoft/consola.ttf $tDir/Consola.ttf
}

_add_themes()
{
	[ -d "/usr/share/icons" ] || sudo mkdir /usr/share/icons
	sudo tar -xzvf /home/engells/mnt/tmpfs/cursors.tar.gz -C /usr/share/icons

	[ -d "/home/engells/.themes" ] || mkdir /home/engells/.themes
	tar -xzvf /home/engells/mnt/tmpfs/themes.tar.gz -C /home/engells/.themes

	[ -d "/home/engells/.icons" ] || mkdir /home/engells/.icons
	tar -xzvf /home/engells/mnt/tmpfs/icons.tar.gz -C /home/engells/.icons

	[ -d /usr/share/gnome-shell/theme/ubuntu.css] && \
		sudo cp /usr/share/gnome-shell/theme/ubuntu.css /usr/share/gnome-shell/theme/ubuntu.css.bak
	sudo cp $sDir/gdm_ubuntu_css /usr/share/gnome-shell/theme/ubuntu.css
	# /etc/alternatives/default.plymouth
}

_nautilus_scripts()
{
	ln -s /home/engells/ktws/scripts/nautilus_scripts/* /home/engells/.local/share/nautilus/scripts
}

_bash_conf()
{
	cp $cfgDir/0_bash_profile /home/engells/.bash_profile
	cp $cfgDir/0_bashrc /home/engells/.bashrc
	. /home/engells/.bashrc
}

_zsh_conf()
{
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cp $cfgDir/0_zshrc ~/.zshrc
	sudo chsh -s $(which zsh) $(whoami)
}

_tmux_conf()
{
	git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
	cp $cfgDir/0_tmux_conf ~/.tmux.conf
}

_vim_conf()
{
	[ -d /home/engells/.vim/conf ] || mkdir -p /home/engells/.vim/conf
	cp $cfgDir/exrc* /home/engells/.vim/conf/
	ln -s /home/engells/.vim/conf/exrc_vim /home/engells/.vimrc
	ln -s /home/engells/.vim/conf/exrc_gvim /home/engells/.gvimrc

	mkdir /home/engells/.vim/{autoload,bundle}
	curl -Sso /home/engells/.vim/autoload/pathogen.vim \
		https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
	cd /home/engells/.vim/bundle
	git clone https://github.com/scrooloose/nerdtree.git
	git clone git://github.com/Lokaltog/vim-powerline.git
	git clone https://github.com/sukima/xmledit.git
}

_set_locale()
{
	sudo mv /var/lib/locales/supported.d/local /var/lib/locales/supported.d/local.bak
	sudo cp $cfgDir/local /var/lib/locales/supported.d
	sudo mv /var/lib/locales/supported.d/en /var/lib/locales/supported.d/en.bak
	sudo mv /var/lib/locales/supported.d/zh-hant /var/lib/locales/supported.d/zh-hant.bak
	#sudo locale -a
	#sudo locale-gen zh_TW.UTF-8
	sudo locale-gen --purge
	#sudo dpkg-reconfigure locales
}

_set_zhfonts()
{
	[ -d "/usr/share/fonts/engells" ] || sudo mkdir /usr/share/fonts/engells

	for  font_file in Heiti.ttf Monaco.ttf TW-Kai.ttf TW-Sung.ttf Consola.ttf
	do
		sudo cp /home/engells/mnt/tmpfs/$font_file /usr/share/fonts/engells/
	done

	sudo chmod 755 /usr/share/fonts/engells/*.ttf

	sudo fc-cache -f -v

	[ -e "/etc/fonts/conf.avail/69-language-selector-zh-tw.conf" ] || \
	sudo cp $cfgDir/font_69_language_selector_zh_tw.conf /etc/fonts/conf.avail/69-language-selector-zh-tw.conf

	#sudo ln -s /etc/fonts/conf.avail/69-language-selector-zh-tw.conf /etc/fonts/conf.d/

	[ -e "/etc/fonts/conf.avail/30-cjk-aliases.conf" ] || \
	sudo cp $cfgDir/font_30_cjk_aliases.conf /etc/fonts/conf.avail/30-cjk-aliases.conf

	#sudo ln -s /etc/fonts/conf.avail/30-cjk-aliases.conf /etc/fonts/conf.d/
}

_ebable_sysrq()
{
	sudo sed -i '$a kernel.sysrq = 1' /etc/sysctl.d/10-console-messages.conf
	#sudo sed -i '$a kernel.sysrq = 1' /etc/sysctl.conf
	#sudo sed -i '$a kernel.sysrq = 1' /etc/sysctl.d/10-magic-sysrq.conf. # for 12.10 and later
}

_disable_automount()
{
	sudo gsettings set org.gnome.desktop.media-handling automount false
	sudo gsettings set org.gnome.desktop.media-handling automount-open false
	# sudo gsettings set org.gnome.desktop.media-handlingautomount true
	# sudo gsettings set org.gnome.desktop.media-handling automount-open true

}

_set_fstab()
{
	sudo mv /etc/fstab /etc/fstab.bak
	sudo cp $cfgDir/init_fstab /etc/fstab
}

_set_crontab()
{
	sudo cp $cfgDir/cron_engells /var/spool/cron/crontabs/engells
	sudo chown engells:crontab /var/spool/cron/crontabs/engells
	sudo chmod a+w /var/spool/cron/crontabs/engells
}

_disable_reclog()
{
	sudo chattr +i ~/.local/share/recently-used.xbel
}

_bak_tmpfs_dir()
{
	[ -d "/opt/engells"] || sudo mkdir -p /opt/engells
	sudo cp $cfgDir/z_mysave.sh /opt/engells
	sudo cp $cfgDir/z_myload.sh /opt/engells
	sudo chmod +x /opt/engells/z_my*

	[ -f "/lib/systemd/system/z.mysave.service" ] || sudo cp $cfgDir/z_mysave_service /lib/systemd/system/z.mysave.service
	sudo systemctl enable z.mysave.service

	[ -d "/var/backups/log"] || sudo mkdir -p /var/backups/log
}

_set_firewall()
{
	[ -d "/opt/security/iptables" ] || sudo mkdir -p /opt/security/iptables
	sudo cp $cfgDir/secre_iptables.rule /opt/security/iptables/iptables.rule
	sudo cp $cfgDir/secre_iptables.allow /opt/security/iptables/iptables.allow
	sudo cp $cfgDir/secre_iptables.deny /opt/security/iptables/iptables.deny
	sudo chmod a+x /opt/security/iptables/iptables.*

	[ -f "/lib/systemd/system/rc.local.service" ] && sudo mv /lib/systemd/system/rc.local.service /lib/systemd/system/rc.local.service.bak
	sudo cp $cfgDir/init_rc_local_service /lib/systemd/system/rc.local.service

	[ -f "/etc/rc.local" ] && sudo mv /etc/rc.local /etc/rc.local.bak
	sudo cp $cfgDir/init_rc_local /etc/rc.local
	sudo chmod +x /etc/rc.local
	sudo systemctl enable rc.local.service
}

_shortcut_utils()
{
	sudo ln -s /home/engells/ktws/scripts/avails/kthcrypt_dir.sh /usr/local/bin/kthd
	sudo ln -s /home/engells/ktws/scripts/avails/kthcrypt_part.sh /usr/local/bin/kthp
	sudo ln -s /home/ktws/scripts/avails/kthcrypt_bak.sh /usr/local/bin/kthb
	sudo ln -s /home/ktws/scripts/avails/virt_module.sh /usr/local/bin/virtm
	sudo ln -s /home/ktws/scripts/avails/virt_net.sh /usr/local/bin/virtn
}

_lxc_conf()
{
	[ -d "/var/lib/lxc" ] && sudo rm -R /var/lib/lxc
	sudo ln -s /home/lxcd /var/lib/lxc

	[ -d "/home/engells/.local/share/lxc" ] && rm -R /home/engells/.local/share/lxc
	ln -s /home/lxcu ~/.local/share/lxc

	[ -f "/etc/lxc/lxc-usernet" ] && sudo mv /etc/lxc/lxc-usernet /etc/lxc/lxc-usernet.bak
	sudo cp $cfgDir/lxc_usernet /etc/lxc/lxc-usernet

	[ -f "/home/engells/.config/lxc/default.conf" ] && mv ~/.config/lxc/default.conf ~/.config/lxc/default.conf.bak
	cp $cfgDir/lxc_default_conf ~/.config/lxc/default.conf

	chmod a+x ~/.local
	chmod a+x ~/.local/share
	chmod a+x /home/lxcu
}

