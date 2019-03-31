# vim:ts=2
# lib: Using to clean system and config trackball
# made by: Engells
# date: Mar 30, 2019
# content: 
# note: the arguments could be deliverd by lunch shcripts

_bak_vir_disks()
{
	[ -d ~/mnt/dump1 ] || sudo mkdir -p ~/mnt/dump1
	sudo umount ~/mnt/dump1 2>/dev/null
	sudo mount -t ext4 $device_1 ~/mnt/dump1
	rm -r -f ~/mnt/dump1/*
	sudo dd if=/dev/sdb4 of=/dev/sdc4 status=progress conv=noerror,sync bs=4k
	# sudo pv -tpreb /dev/sdb4 | dd of=/dev/sdc4 bs=4096 conv=notrunc,noerror
}

_bak_data_setdir()
{
	[ -d ~/mnt/dump1 ] || sudo mkdir -p ~/mnt/dump1
	[ -d ~/mnt/dump2 ] || sudo mkdir -p ~/mnt/dump2
	[ -d ~/mnt/dump3 ] || sudo mkdir -p ~/mnt/dump3
	[ -d ~/mnt/dump2 ] || sudo mkdir -p ~/mnt/dump4
	sudo umount ~/mnt/dump1 2>/dev/null
	sudo umount ~/mnt/dump2 2>/dev/null
	sudo umount ~/mnt/dump3 2>/dev/null
	sudo umount ~/mnt/dump4 2>/dev/null
}

_bak_data_import_pool()
{
	echo 'importing pool xpl ' && sudo zpool import -d /dev/disk/by-id xpl &&  sleep 5
}

_bak_data_mount_sur()
{
	if [ -z $1 ] && return

	case $1 in
		sdc)
			sudo mount -t ext4 $device_1 ~/mnt/dump1
			sudo mount -t ext4 $device_2 ~/mnt/dump2
			sudo mount -t ext4 $device_3 ~/mnt/dump3
			sudo mount -t ext4 $device_4 ~/mnt/dump4
			;;
		sda)
			sudo mount -t ext4 $device_1 ~/mnt/dump1
			sudo mount -t ext4 $device_2 ~/mnt/dump2
			;;
		*)
			echo 'mounted nothing!'
			;;
	esac
}

_bak_data_main()
{
	sudo chown engells:engells -R ~/mnt/dump3
	sudo chown engells:engells -R ~/mnt/dump4
	rm -r -f ~/mnt/dump3/* ; cd ~/mnt/dump1 && cp -av . ~/mnt/dump3
	rm -r -f ~/mnt/dump4/* ; cd ~/mnt/dump2 && cp -av . ~/mnt/dump4
}

_bak_data_to_portable()
{
	_bak_data_setdir
	_bak_data_mount_sur sdc
	_bak_data_main
}

_bak_data_to_local()
{
	_bak_data_setdir
	_bak_data_mount_sur sda

	case $1 in
		step1)
			sudo zfs set mountpoint=/home/engells/mnt/dump3 xpl/ktws &&  sleep 2
			sudo zfs set mountpoint=/home/engells/mnt/dump4 xpl/mmedia &&  sleep 2
			echo 'mounting dadaset ktws' $$ sudo zfs mount xpl/ktws &&  sleep 5
			echo 'mounting dadaset mmedia' $$ sudo zfs mount xpl/mmedia &&  sleep 5
			_bak_data_main
			sudo zfs set mountpoint=/home/engells/mnt/ktws xpl/ktws &&  sleep 2
			sudo zfs set mountpoint=/home/engells/mnt/mmedia xpl/mmedia &&  sleep 2
			;;
		step2)
			sudo zfs set mountpoint=/home/engells/mnt/dump3 xpl/ktwsb &&  sleep 2
			sudo zfs set mountpoint=/home/engells/mnt/dump4 xpl/mmediab &&  sleep 2
			echo 'mounting dadaset ktws' $$ sudo zfs mount xpl/ktws &&  sleep 5
			echo 'mounting dadaset mmedia' $$ sudo zfs mount xpl/mmedia &&  sleep 5
			_bak_data_main
			sudo zfs set mountpoint=/home/engells/mnt/ktwsb xpl/ktwsb &&  sleep 2
			sudo zfs set mountpoint=/home/engells/mnt/mmediab xpl/mmediab &&  sleep 2
			;;
		*)
			echo 'done nothing!'
			;;
	esac
}

_clean_apt()
{
	echo '2秒後開始清除 APT 系統' && sleep 2
	sudo apt-get autoremove --purge
	sudo apt-get autoclean
	sudo apt-get clean
	sudo localepurge
}

_clean_bash()
{
	echo '2秒後開始清除 bash 及 zsh 歷史指令' && sleep 2
	[ -f ~/.bash_history ] && cat /dev/null > ~/.bash_history
	[ -f ~/.zsh_history ] && cat /dev/null > ~/.zsh_history
}

_rm_kernel()
{
	sudo apt-get purge '^linux-.*-3.2.0-23'
}

_add_line_bak()
{
	cat $f1 | sed '/^$/d' > $f2
	while read line
	do
		echo $line >> $f2
		echo >> $f2
	done < "$f2"
}


