#!/bin/bash
# vim:ts=4
# program: Using to creat crypted block device
# made by: Engells
# date: Feb 22, 2013
# content:利用 Linux的 AES 加密 block device，k-at-r-p-t-9-3-。

_mount_crypt()
{
	sudo modprobe aes
	sudo modprobe dm-crypt
	sudo losetup $dev_name $img_name
	sudo cryptsetup luksOpen $dev_name $crypt_name
	[ -d $dir_mnt ] || sudo mkdir -p $dir_mnt
	sudo mount /dev/mapper/$crypt_name $dir_mnt
	sudo chown -R $user_name:$user_name $dir_mnt
}

_umount_crypt()
{
	sudo umount $dir_mnt
	sudo cryptsetup luksClose $crypt_name
	sudo losetup -d $dev_name
	sudo rmdir $dir_mnt
	sudo modprobe -r dm-crypt
	sudo modprobe -r aes
}

#-建立變數--------------
user_name=$(whoami)
dev_name="/dev/loop0"
img_name="/home/$user_name/ktws/kthbak.img"
crypt_name='kthcrypt'
dir_mnt="/home/$user_name/mnt/crypt_part"

#-安裝套件--------------
#if dpkg --get-selections | grep 'cryptsetup'; then
#	echo '' > /dev/null
#else
#	sudo apt-get install dmsetup cryptsetup
#fi

#-確認處理方式------------
if [ -z $1 ]; then
	Des="請輸入處理方式:"; printf "%s\n" "$Des"
	# Des="c: 建立加密映像檔"; printf "%s\n" "$Des"
	Des="m: 掛載映像檔"; printf "%s\n" "$Des"
	Des="u: 卸載映像檔"; printf "%s\n" "$Des"
	read way
	if [ -z "$way" ]; then echo '未選擇處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi
else
	way=$1
fi

#-實際作業--------------
case $way in
	m)
		_mount_crypt ;;
	u)
		_umount_crypt ;;
	*)
		echo '錯誤 未定義之處理方式' ;;
esac

#-清理變數--------------
unset way; unset user_name; unset dev_name; unset img_name; unset crypt_name; unset dir_mnt


