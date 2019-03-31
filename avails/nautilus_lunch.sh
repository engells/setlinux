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
		device_1="/dev/sdb6"
		device_2="/dev/sdb7"
		device_3="/dev/sdc6" 
		device_4="/dev/sdc7"
		_bak_data_to_portable ;;

	dc2)

		echo '2秒後開始將資料備份至外接式硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		device_1="/dev/sdb8"
		device_2="/dev/sdb9"
		device_3="/dev/sdc8"
		device_4="/dev/sdc9"
		_bak_data_to_portable ;;

	dk1)

		echo '2秒後開始將資料備份至本地硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		_bak_data_import_pool
		device_1="/dev/sdb6"
		device_2="/dev/sdb7"

		_bak_data_to_local step1 ;;

	dk2)

		echo '2秒後開始將資料備份至本地硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		#_bak_data_import_pool
		device_1="/dev/sdb8"
		device_2="/dev/sdb9"

		_bak_data_to_local step2 ;;

	*)

		echo '未定義之處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 2

esac

unset Des ; unset way 

