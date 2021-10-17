#! /bin/bash
# vim:ts=2
# program: Using to clean system and config trackball
# made by: Engells
# date: Apr 27, 2019
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
				sudo umount /media/engells/$mnt_dir
		done
		;;

	rzd)

		echo '2 秒後開始移除 ZFS dataset 掛載點' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh
		_rm_zfs_mnt_dir
		;;

	dc1)

		echo '2 秒後開始將資料備份至外接式硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh

		dev_sur="kpl/ktws"
		dev_tar="zpl/ktws"
		mnt_sur="/home/engells/ktws"
		mnt_tar="/home/engells/mnt/zktws"
		_bak_data_to_local

		dev_sur="kpl/mmedia"
		dev_tar="zpl/mmedia"
		mnt_sur="/home/engells/mmedia"
		mnt_tar="/home/engells/mnt/zmmedia"
		_bak_data_to_local 
		;;

	dc2)

		echo '2 秒後開始將資料備份至外接式硬碟' && sleep 2

		. /home/engells/ktws/scripts/libs/kt_lib_default.sh

		dev_sur="kpl/ktwsb"
		dev_tar="zpl/ktwsb"
		mnt_sur="/home/engells/mnt/ktwsb"
		mnt_tar="/home/engells/mnt/zktwsb"
		_bak_data_to_local

		dev_sur="kpl/mmediab"
		dev_tar="zpl/mmediab"
		mnt_sur="/home/engells/mnt/mmediab"
		mnt_tar="/home/engells/mnt/zmmediab"
		_bak_data_to_local
		;;

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
		_bak_data_to_local 
		;;

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
		_bak_data_to_local
		;;

	*)

		echo '未定義之處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 2

esac

unset Des ; unset way 

