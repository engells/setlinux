# vim:ts=4
# lib: Using to install Ubuntu 12.04
# made by: Engells
# date: June 05, 2012
# content: 

cfgDir="/home/engells/ktws/scripts/configs"

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

	for DIR in bak buf cache doc dump1 dump2 dump3 iso scripts ramfs tmpfs
	do
		[ -d /home/engells/mnt/$DIR ] || mkdir -p /home/engells/mnt/$DIR
	done

	[ -d /home/engells/virtual ] || mkdir /home/engells/virtual

	for DIR in shared vir_discs vir_disks vir_machines
	do
		[ -d /home/engells/virtual/$DIR ] || mkdir -p /home/engells/virtual/$DIR
	done

	[ -d /home/engells/downloads ] || mkdir /home/engells/downloads

	sudo chown -R engells:engells /home/engells/mnt
	sudo chown -R engells:engells /home/engells/virtual
	sudo chown -R engells:engells /home/engells/downloads
}

_user_dirs()
{
	mv /home/engells/.config/user-dirs.dirs /home/engells/.config/user-dirs.dirs.bak
	cp $cfgDir/user-dirs.dirs /home/engells/.config/

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

	#cp $sDir/editor/madedit-0.2.9.1-luna.deb $tDir/madedit.deb
	#cp $sDir/virtual/VirtualBox-4.2.16-86992-precise-amd64.deb $tDir/vb.deb
	#cp $sDir/security_monitor/truecrypt-7.1a-setup-x64 $tDir/truecrypt.sh
	cp $sDir/themes/Theme-Elementary-Gtk-3.x.tar.gz $tDir/themes.tar.gz
	cp $sDir/themes/Cursor-Mac-Lion-Gtk-3.x.tar.gz $tDir/cursors.tar.gz
	cp $sDir/themes/Icon-Mac-Lion-Gtk-3.x.tar.gz $tDir/icons.tar.gz

	sDir="/home/engells/ktws/0_sur_fonts"
	cp $sDir/Apple_OSX/Heiti-SC-Medium-6.1-d23.ttf $tDir/Heiti.ttf
	cp $sDir/Apple_OSX/Monaco.ttf $tDir/Monaco.ttf
	cp $sDir/TW_Gov/TW-Kai-98.1.ttf $tDir/TW-Kai.ttf
	cp $sDir/TW_Gov/TW-Sung-98.1.ttf $tDir/TW-Sung.ttf
	cp $sDir/MS_Win8/consola.ttf $tDir/Consola.ttf
}

_install_dropbox()
{
	cp /home/engells/ktws/0_sur_linux/dropbox-1.6.10.tar.gz /home/engells/dropbox.tar.gz
	tar zxvf /home/engells/dropbox.tar.gz
	rm /home/engells/dropbox.tar.gz
	#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	#~/.dropbox-dist/dropboxd
	#依提示的連結，丟到瀏覽器裡，輸入 dropbox 帳號密碼，登入成功後，就把 daemon 跟這個帳號連結在一起
}

_add_themes()
{
	[ -d "/usr/share/icons" ] || sudo mkdir /usr/share/icons
	sudo tar -xzvf /home/engells/mnt/tmpfs/cursors.tar.gz -C /usr/share/icons

	[ -d "/home/engells/.themes" ] || mkdir /home/engells/.themes
	tar -xzvf /home/engells/mnt/tmpfs/themes.tar.gz -C /home/engells/.themes

	[ -d "/home/engells/.icons" ] || mkdir /home/engells/.icons
	tar -xzvf /home/engells/mnt/tmpfs/icons.tar.gz -C /home/engells/.icons
}

_nautilus_scripts()
{
	#ln -s /home/engells/ktws/scripts/nautilus_scripts/* /home/engells/.gnome2/nautilus-scripts/
	ln -s /home/engells/ktws/scripts/nautilus_scripts/* /home/engells/.local/share/nautilus/scripts
	sudo ln -s /home/engells/ktws/scripts/avails/kthcrypt_dir.sh /usr/local/bin/kthd
	sudo ln -s /home/engells/ktws/scripts/avails/kthcrypt_part.sh /usr/local/bin/kthp
}

_bash_conf()
{
	cp $cfgDir/0.bash_profile /home/engells/.bash_profile
	cp $cfgDir/0.bashrc /home/engells/.bashrc
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

_enable_ibus()
{
	sudo cp $cfgDir/ibus-daemon.desktop /etc/xdg/autostart/
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
	sudo cp $cfgDir/69_language_selector_zh_tw.conf /etc/fonts/conf.avail/69-language-selector-zh-tw.conf

	sudo ln -s /etc/fonts/conf.avail/69-language-selector-zh-tw.conf /etc/fonts/conf.d/

	[ -e "/etc/fonts/conf.avail/30-cjk-aliases.conf" ] || \
	sudo cp $cfgDir/30_cjk_aliases.conf /etc/fonts/conf.avail/30-cjk-aliases.conf

	sudo ln -s /etc/fonts/conf.avail/30-cjk-aliases.conf /etc/fonts/conf.d/
}

_disable_utc()
{
	sudo sed -i 's/UTC=yes/UTC=no/g' /etc/default/rcS
}

_ebable_sysrq()
{
	sudo sed -i '$a kernel.sysrq = 1' /etc/sysctl.d/10-console-messages.conf
	#sudo sed -i '$a kernel.sysrq = 1' /etc/sysctl.conf
	#sudo sed -i '$a kernel.sysrq = 1' /etc/sysctl.d/10-magic-sysrq.conf. # for 12.10 and later
}

_set_fstab()
{
	sudo mv /etc/fstab /etc/fstab.bak
	sudo cp $cfgDir/fstab /etc
}

_bak_tmpfs_dir()
{
	sudo cp $cfgDir/z.mysave.sh /etc/init.d/
	sudo cp $cfgDir/z.myload.sh /etc/init.d/
	sudo chmod +x /etc/init.d/z.my*
	sudo ln -s /etc/init.d/z.mysave.sh /etc/rc0.d/K10mysave.sh
	sudo ln -s /etc/init.d/z.mysave.sh /etc/rc6.d/K10mysave.sh
	cd /etc/init.d && sudo update-rc.d z.myload.sh defaults 
	sudo rm /etc/rc0.d/K*z.myload.sh
	sudo rm /etc/rc1.d/K*z.myload.sh
	sudo rm /etc/rc4.d/S*z.myload.sh
	sudo rm /etc/rc6.d/K*z.myload.sh
	sudo mv /etc/rc2.d/S20z.myload.sh /etc/rc2.d/S29myload.sh
	sudo mv /etc/rc3.d/S20z.myload.sh /etc/rc3.d/S29myload.sh
	sudo mv /etc/rc5.d/S20z.myload.sh /etc/rc5.d/S29myload.sh
	sudo cp /etc/rc2.d/S29myload.sh /etc/rc1.d/
}

_set_crontab()
{
	sudo cp $cfgDir/cron-engells /var/spool/cron/crontabs/engells
	sudo chown engells:engells /var/spool/cron/crontabs/engells
	sudo chmod a+w /var/spool/cron/crontabs/engells
}

_disable_reclog()
{
	sudo chattr +i ~/.local/share/recently-used.xbel
}

_set_firewall()
{
	[ -d "/opt/security/iptables" ] || sudo mkdir -p /opt/security/iptables
	sudo cp $cfgDir/iptables.* /opt/security/iptables/
	sudo chmod a+x /opt/security/iptables/iptables.*
	sudo sed -i '$a bash /opt/security/iptables/iptables.rule' /etc/init.d/rc.local
}

_shortcut_utils()
{
	sudo ln -s ~/ktws/scripts/avails/kthcrypt_bak.sh /usr/local/bin/kthb
	sudo ln -s ~/ktws/scripts/avails/virt_module.sh /usr/local/bin/virtm
	sudo ln -s ~/ktws/scripts/avails/virt_net.sh /usr/local/bin/virtn
}

_android_utils()
{
	#sudo apt-get install lib32ncurses5 lib32stdc++6	# included in pkgs.list
	strDev='SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="0c03", ATTR{product}=="ZP900S",'
	strDev="$strDev "'MODE="0666", SYMLINK+="9300plus", GROUP="plugdev"'
	echo $strDev | sudo tee /etc/udev/rules.d/71-android.rules 
	sudo service udev restart
}

_java_chi()
{
	sed -i '$a export _JAVA_OPTIONS="-Dfile.encoding=BIG5"' ~/.profile	# 修正 java 的中文顯示, 需重新登入
}

_java_upgrade()
{
	sudo apt-get install openjdk-7-jdk openjdk-7-jre	# 升級 java 版本
	sudo update-alternatives --config java			# 啟用新版 java
	#java -version						# 查詢運作之 java 版本
}

