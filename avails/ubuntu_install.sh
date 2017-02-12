#!/bin/bash
# vim:ts=4
# program: To estabilish mine standard Ubinti environment.
# made by: Engells
# date: Jan 28, 2012
# content: 事先定義套件資料在 pkgs.list 檔案，依序移除不需要之套件，再安裝需要之套件。安裝之套件依需要性分成二階段安裝
#			Don't exercise this script with sudo

shDir="/home/engells/ktws/scripts"

if [ -z $1 ]; then
	Des='請輸入處理方式 第一參數 a:移除套件及更新套件來源 b:安裝套件 c:設定系統 '
	printf "%s\n" "$Des"

elif [ X$1 = X"a" ]; then

	sudo apt-get purge -y $(cat $shDir/install/pkgs.list | grep '^remove' | awk '{ print $2 }')	# 依照清單移除套件

	. $shDir/libs/kt_lib_install.sh
	_chg_aptsur	# 更換 apt 套件來源
	_set_grub	# 顯示開機詳細資訊
	_mnt_dirs	# 建立 ~/mnt 的目錄架構
	_user_dirs	# 自訂使用者目錄
	_cp_files	# 複製必要檔案

	#sudo apt-get install python-software-properties	# 確定 add-apt-repository 可運作
	#sudo add-apt-repository $(cat pkgs.list | grep '^add_repo' | awk '{ print $2 }')	# 依照清單新增 apt 套件來源

	sudo apt-get update; sudo apt-get dist-upgrade	# 升級系統

elif [ X$1 = X"b" ]; then

	#sudo apt-get update; sudo apt-get -f install	# check if need to run apt-get upgrade
	sudo apt-get install -y $(cat $shDir/install/pkgs.list | grep '^install_apt' | awk '{ print $2 }')	# 依照清單安裝套件

	#sudo dpkg -i $(cat $shDir/install/pkgs.list | grep '^install_dpkg' | awk '{ print $2 }')	# 安裝 madedit, VirtualBox

	#sudo bash $(cat $shDir/install/pkgs.list | grep '^install_bash' | awk '{ print $2 }')	# 安裝 truecrypt

	sudo apt-get autoremove --purge; sudo apt-get autoclean; sudo apt-get clean

	. $shDir/libs/kt_lib_install.sh
	_install_dropbox	# 安裝 DropBox
	

elif [ X$1 = X"c" ]; then

	. $shDir/libs/kt_lib_install.sh

	#_add_themes	# 增加佈景主題 elementary

	#_nautilus_scripts	# 複製 gnome scripts

	_bash_conf	# 複製 bash 設定檔

	_vim_conf	# 複製 vim 設定檔

	_enable_ibus	# 開機時啟用 iBus

	_set_locale	# 語系設定

	_set_zhfonts	# 中文字型設定

	_set_grub	# Grub設定

	_disable_utc	# 不使用 UTC

	_ebable_sysrq	# 啟用 Alt+sysrq+{reisub}

	_set_fstab	# 掛載 tmpfs 包括 /tmp , /var/log, ~/downloads

	_bak_tmpfs_dir	# 將 /var/log 及 ~/downloads 設定關機存儲硬碟，及開機重新載入 tmpfs

	_set_crontab	# 設定每半小時將 ~/downloads 的資料移至 ~/mnt/buf

	_set_firewall	# 設定防火牆

	_shortcut_utils	# 建立 /usr/local/bin/* 執行檔

	_android_utils	# 建立 adb 機制連接 Android 裝置

else
	echo '錯誤 未定義之處理方式'

fi
