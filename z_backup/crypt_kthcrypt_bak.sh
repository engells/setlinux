#!/bin/bash
# vim:ts=4
# program: To creat crypted directory
# made by: Engells
# date: Mar 12, 2013
# content: mount crypted dir and img at the same time, them dump data in dir to img. k-at-r-p-t-9-3-。

_beg_bakup()
{
	_mount_img
	_mount_dir
	cd $img_mnt && rm -R ./*
	cd $dir_mnt && cp -av . $img_mnt
	mkdir $img_mnt/temp && cd ~/ktws/temp && cp -av . $img_mnt/temp
}

_end_bakup()
{
	_umount_dir
	_umount_img
}

_mount_dir()
{
	[ -d $dir_mnt ] || sudo mkdir -p $dir_mnt
	opt="key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=32,ecryptfs_passthrough=n"
	opt="$opt,ecryptfs_enable_filename_crypto=y"
	sudo mount -t ecryptfs $dir_real $dir_mnt -o $opt
	sudo chown -R $user_name:$user_name $dir_mnt
}

_umount_dir()
{
	sudo umount -t ecryptfs $dir_mnt
	sudo rmdir $dir_mnt
}

_mount_img()
{
	sudo modprobe aes_generic
	sudo modprobe dm-crypt
	sudo losetup $dev_name $img_name
	sudo cryptsetup luksOpen $dev_name $crypt_name
	[ -d $img_mnt ] || sudo mkdir -p $img_mnt
	sudo mount /dev/mapper/$crypt_name $img_mnt
#	sudo chown -R $user_name:$user_name $img_mnt
}

_umount_img()
{
	sudo umount $img_mnt
	sudo cryptsetup luksClose $crypt_name
	sudo losetup -d $dev_name
	sudo rmdir $img_mnt
	sudo modprobe -r dm-crypt
	#sudo modprobe -r aes
}

#-建立變數--------------
user_name=$(whoami)
dev_name="/dev/loop0"
img_name="/home/$user_name/ktws/kthbak.img"
crypt_name='kthcrypt'
img_mnt="/home/$user_name/mnt/crypt_part"
dir_real="/home/$user_name/ktws/kth"
dir_mnt="/home/$user_name/mnt/crypt_dir"

#-確認作業方式------------
if [ -z $1 ]; then
	Des="請輸入作業方式:"; printf "%s\n" "$Des"
	Des="b: 備份加密資料"; printf "%s\n" "$Des"
	Des="d: 掛載或卸載加密目錄"; printf "%s\n" "$Des"
	Des="p: 掛載或卸載加密映像檔"; printf "%s\n" "$Des"
	read way1
	if [ -z "$way1" ]; then echo '未選擇作業方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi
else
	way1=$1
fi

#-確認處理方式------------
if [ -z $2 ]; then
	Des="請輸入處理方式:"; printf "%s\n" "$Des"
	Des="m: 掛載加密資料"; printf "%s\n" "$Des"
	Des="u: 卸載加密資料"; printf "%s\n" "$Des"
	read way2
	if [ -z "$way2" ]; then echo '未選擇處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi
else
	way2=$2
fi

#-實際作業--------------
case $way1 in
	b)
		case $way2 in
		m)
			_beg_bakup ;;
		u)
			_end_bakup ;;
		*)
			echo '錯誤 未定義之處理方式' ;;
		esac ;;
	d)
		case $way2 in
		m)
			_mount_dir ;;
		u)
			_umount_dir ;;
		*)
			echo '錯誤 未定義之處理方式' ;;
		esac ;;
	p)
		case $way2 in
		m)
			_mount_img ;;
		u)
			_umount_img ;;
		*)
			echo '錯誤 未定義之處理方式' ;;
		esac ;;
	*)
		echo '錯誤 未定義之作業方式' ;;
esac

#-清理變數--------------
unset way1; unset way2
unset dir_real; unset dir_mnt;
unset user_name; unset dev_name; unset img_name; unset crypt_name; unset img_mnt; unset opt

