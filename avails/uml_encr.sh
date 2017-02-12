#!/bin/bash
# vim:ts=4
# program: To enter a customed chroot environment
# made by: Engells
# date: Nov 1, 2012
# content: This script includes three sub-functions to prepare, enter and clean chroot environment.

_pre_chroot()
{
[ -f /tmp/display ] && mv /tmp/display
xauth extract /tmp/display $DISPLAY
mount -t proc proc $sub_root/proc
mount --bind /dev/input $sub_root/dev/input
mount --bind /tmp $sub_root/tmp
}

_pst_chroot()
{
umount $sub_root/tmp
umount $sub_root/dev/input
umount $sub_root/proc
[ -f /tmp/display ] && rm /tmp/display
}

_ent_chroot()
{
chroot $sub_root env -i HOME=/root TERM=$TERM /bin/bash
}

if [ -z $1 ]; then
	sub_root="/mnt/uml_test"
else
	sub_root="/mnt/$1"
fi

echo '選擇處理方式 pre:配置chroot環境 ent:進入chroot環境 pst:移除chroot配置'

read way

if [ -z $way ]; then echo '未輸入處理方式,2秒後跳出程式' && sleep 2 && exit; fi

case $way in
	pe)
		_pre_chroot
		_ent_chroot
		;;
	pre)
		_pre_chroot
		;;
	ent)
		_ent_chroot
		;;
	pst)
		_pst_chroot
		;;
	*)
		echo '未定義之處理方式,2秒後跳出程式' && sleep 2
		;;
esac

unset sub_root; unset way

