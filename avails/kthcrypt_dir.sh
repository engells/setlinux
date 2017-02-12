#!/bin/bash
# vim:ts=4
# program: To creat crypted directory
# made by: Engells
# date: Feb 22, 2013
# content:利用 Linux的 AES 加密目錄，k-at-r-p-t-9-3-。

#-建立變數--------------
user_name=$(whoami)
dir_real="/home/$user_name/ktws/kth"
dir_mnt="/home/$user_name/mnt/crypt_dir"

#-確認處理方式------------
if [ -z $1 ]; then
	Des="請輸入處理方式:"; printf "%s\n" "$Des"
	Des="m: 掛載加密目錄"; printf "%s\n" "$Des"
	Des="u: 卸載加密目錄"; printf "%s\n" "$Des"
	read way
	if [ -z "$way" ]; then echo '未選擇處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi
else
	way=$1
fi

#-實際作業--------------
case $way in
	m)
		[ -d $dir_mnt ] || sudo mkdir -p $dir_mnt
		sudo mount -t ecryptfs $dir_real $dir_mnt
		sudo chown -R $user_name:$user_name $dir_mnt ;;
	u)
		sudo umount -t ecryptfs $dir_mnt
		sudo rmdir $dir_mnt ;;
	*)
		echo '錯誤 未定義之處理方式' ;;
esac

unset way; unset user_name; unset dir_real; unset dir_mnt

