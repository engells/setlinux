#! /bin/bash
# vim:ts=2
# program: Using to clean system and config trackball
# made by: Engells
# date: Dec 21, 2011
# content: 

_bak_vir_disks()
{
	[ -d ~/mnt/dump1 ] || sudo mkdir -p ~/mnt/dump1
	sudo umount ~/mnt/dump1 2>/dev/null
	sudo mount -t ext4 $device_1 ~/mnt/dump1
	rm -r ~/mnt/dump1/virtual/{Linux_Web.img,WinXP_Work.vdi}
	cd ~/virtual/vir_disks	&& cp -av ./{Linux_Web.img,WinXP_Work.vdi} ~/mnt/dump1/virtual/
}

_bak_data()
{
	[ -d ~/mnt/dump3 ] || sudo mkdir -p ~/mnt/dump3
	[ -d ~/mnt/dump4 ] || sudo mkdir -p ~/mnt/dump4
	sudo umount ~/mnt/dump3 2>/dev/null
	sudo umount ~/mnt/dump4 2>/dev/null
	sudo mount -t ext4 $device_3 ~/mnt/dump3
	sudo mount -t ext4 $device_4 ~/mnt/dump4
	sudo chown engells:engells -R ~/mnt/dump3
	sudo chown engells:engells -R ~/mnt/dump4
	rm -r ~/mnt/dump3/* ; cd ~/ktws && cp -av . ~/mnt/dump3
	rm -r ~/mnt/dump4/* ; cd ~/mmedia && cp -av . ~/mnt/dump4
}

_bak_data2()
{
	[ -d ~/mnt/dump1 ] || sudo mkdir -p ~/mnt/dump1
	[ -d ~/mnt/dump2 ] || sudo mkdir -p ~/mnt/dump2
	[ -d ~/mnt/dump3 ] || sudo mkdir -p ~/mnt/dump3
	[ -d ~/mnt/dump2 ] || sudo mkdir -p ~/mnt/dump4
	sudo umount ~/mnt/dump1 2>/dev/null
	sudo umount ~/mnt/dump2 2>/dev/null
	sudo umount ~/mnt/dump3 2>/dev/null
	sudo umount ~/mnt/dump4 2>/dev/null
	sudo mount -t ext4 $device_1 ~/mnt/dump1
	sudo mount -t ext4 $device_2 ~/mnt/dump2
	sudo mount -t ext4 $device_3 ~/mnt/dump3
	sudo mount -t ext4 $device_4 ~/mnt/dump4
	sudo chown engells:engells -R ~/mnt/dump3
	sudo chown engells:engells -R ~/mnt/dump4
	rm -r ~/mnt/dump3/* ; cd ~/mnt/dump1 && cp -av . ~/mnt/dump3
	rm -r ~/mnt/dump4/* ; cd ~/mnt/dump2 && cp -av . ~/mnt/dump4
}

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
		_set_trackball ;;

	um)

		sudo umount /media/Linux
		sudo umount /media/Profile
		sudo umount /media/WareHouse1
		sudo umount /media/WareHouse2 ;;

	dc)

		echo '2秒後開始將資料備份至外接式硬碟' && sleep 2
		
		device_1="/dev/sdc2"
		device_2="/dev/sdc3" 
		device_3="/dev/sdc4"
		_bak_vir_disks
		_bak_data ;;

	dk)

		echo '2秒後開始將資料備份至本地硬碟' && sleep 2

		device_3="/dev/sda5"
		device_4="/dev/sda6"
		_bak_data ;;

	dl)

		echo '2秒後開始將資料備份至本地硬碟' && sleep 2

		device_1="/dev/sdb7"
		device_2="/dev/sdb8"
		device_3="/dev/sda7"
		device_4="/dev/sda8"
		_bak_data2 ;;


	*)

		echo '未定義之處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 2

esac

unset Des ; unset way 

