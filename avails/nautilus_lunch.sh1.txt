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

		echo '2秒後開始將資料備份至外接式硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		mnt_sur="/home/engells/mnt/dump1"
		mnt_tar="/home/engells/mnt/dump3"

		device_sur="/dev/sdb6"
		device_tar="/dev/sdc6"
		_bak_data_to_portable

		device_sur="/dev/sdb7"
		device_tar="/dev/sdc7"
		_bak_data_to_portable ;;

	dc2)

		echo '2秒後開始將資料備份至外接式硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		mnt_sur="/home/engells/mnt/dump1"
		mnt_tar="/home/engells/mnt/dump3"

		device_sur="/dev/sdb8"
		device_tar="/dev/sdc8"
		_bak_data_to_portable

		device_sur="/dev/sdb9"
		device_tar="/dev/sdc9"
		_bak_data_to_portable ;;

	dk1)

		echo '2秒後開始將資料備份至本地硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		mnt_sur="/home/engells/mnt/dump1"

		device_sur="/dev/sdb6"
		device_tar="xpl/ktws"
		_bak_data_to_local

		device_sur="/dev/sdb7"
		device_tar="xpl/mmedia"
		_bak_data_to_local ;;

	dk2)

		echo '2秒後開始將資料備份至本地硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		mnt_sur="/home/engells/mnt/dump1"

		device_sur="/dev/sdb8"
		device_tar="xpl/ktwsb"
		_bak_data_to_local

		device_sur="/dev/sdb9"
		device_tar="xpl/mmediab"
		_bak_data_to_local ;;

	*)

		echo '未定義之處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 2

esac

unset Des ; unset way 

