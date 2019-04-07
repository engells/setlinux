#! /bin/bash
# vim:ts=2
# program: Using to clean system and config trackball
# made by: Engells
# date: Dec 21, 2011
# content: 

if [ -z $1 ]; then 
	Des='請輸入處理方式 c:清除系統 h:清除bash歷史指令 m:設定羅技軌跡球 u:卸載 /dev/sdc'
	printf "%s\n" "$Des"

	read way
	if [ -z "$way" ]; then echo '未選擇處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi

else

	way=$1

fi

case $way in

	cs)

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		_clean_apt
		;;

	ch)

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		_clean_bash
		;;

	m)

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		_set_trackball
		;;

	um)

		for mnt_dir in $(ls /media/engells)
		do
				sudo umount $mnt_dir
		done
		;;

	dc1)

		echo '2 秒後開始將資料備份至外接式硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh

		dev_sur="kpl/ktws"
		dev_tar="/dev/sdc6"
		mnt_sur="/home/engells/ktws"
		mnt_tar="/home/engells/mnt/dump1"
		_bak_data_to_portable

		dev_sur="kpl/mmedia"
		dev_tar="/dev/sdc7"
		mnt_sur="/home/engells/mmedia"
		mnt_tar="/home/engells/mnt/dump2"
		_bak_data_to_portable ;;

	dc2)

		echo '2 秒後開始將資料備份至外接式硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh

		dev_sur="kpl/ktwsb"
		dev_tar="/dev/sdc8"
		mnt_sur="/home/engells/mnt/ktwsb"
		mnt_tar="/home/engells/mnt/dump3"
		_bak_data_to_portable

		dev_sur="kpl/mmediab"
		dev_tar="/dev/sdc9"
		mnt_sur="/home/engells/mnt/mmediab"
		mnt_tar="/home/engells/mnt/dump4"
		_bak_data_to_portable ;;

	dk1)

		echo '2 秒後開始將資料備份至本地硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh

		dev_sur="kpl/ktws"
		dev_tar="xpl/ktws"
		mnt_sur="/home/engells/ktws"
		mnt_tar="/home/engells/mnt/xktws"
		_bak_data_to_local

		dev_sur="kpl/mmedia"
		dev_tar="xpl/mmedia"
		mnt_sur="/home/engells/mmedia"
		mnt_tar="/home/engells/mnt/xmmedia"
		_bak_data_to_local ;;

	dk2)

		echo '2秒後開始將資料備份至本地硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh

		dev_sur="kpl/ktwsb"
		dev_tar="xpl/ktwsb"
		mnt_sur="/home/engells/mnt/ktwsb"
		mnt_tar="/home/engells/mnt/xktwsb"
		_bak_data_to_local

		dev_sur="kpl/mmediab"
		dev_tar="xpl/mmediab"
		mnt_sur="/home/engells/mnt/mmediab"
		mnt_tar="/home/engells/mnt/xmmediab"
		_bak_data_to_local ;;

	*)

		echo '未定義之處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 2

esac

unset Des ; unset way 

