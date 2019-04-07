# vim:ts=2
# lib: Using to clean system and config trackball
# made by: Engells
# date: Mar 31, 2019
# content: 
# note: the arguments could be deliverd by lunch shcripts

<<<<<<< HEAD
_empty_dev_tar()
{
	for DIR in $(ls $mnt_tar)
	do
		[ -d $DIR ] && rm -rvf $DIR
		[ -f $DIR ] && rm -vf $DIR
	done

=======
_bak_data_import_pool()
{
	echo 'clearing dataset mountpoint of pool xpl'

	sudo zpool export xpl 2>/dev/null

	for DIR in ktws mmedia ktwsb mmediab
	do
		sudo rm -r -f ~/mnt/$DIR
	done

	echo 'importing pool xpl ' && sudo zpool import -d /dev/disk/by-id xpl && sleep 5
>>>>>>> 7dc64d84764170782caeda80aab802e4722557ef
}

_bak_data_to_portable()
{
<<<<<<< HEAD
	pool_sur=$(echo $dev_sur | awk -F"/" '{ print $1 }')
	pool_tar=$(echo $dev_tar | awk -F"/" '{ print $1 }')

	echo "mounting source device ..." && sleep 2
	sudo zpool list | grep kpl 1>/dev/null 2>/dev/null || sudo zpool import -d /dev/disk/by-id kpl
	sudo zfs list | grep $dev_sur 1>/dev/null 2>/dev/null || sudo zfs mount $dev_sur

	echo "mounting target device ..." && sleep 2
	sudo umount $mnt_tar 2>/dev/null
	sudo mount $dev_tar $mnt_tar 2>/dev/null

	echo "empting target device ..." && sleep 2
	cd $mnt_tar && _empty_dev_tar

	echo "dumping from source device to target device ..." && sleep 2
	cd $mnt_sur && cp -av . $mnt_tar
=======
	for DIR in $mnt_sur $mnt_tar
	do
		[ -d $DIR ] || sudo mkdir -p $DIR
			sudo umount $DIR 2>/dev/null
	done

	sudo mount -t ext4 $device_sur $mnt_sur
	sudo mount -t ext4 $device_tar $mnt_tar
	rm -r -f $mnt_tar/* ; cd $mnt_sur && cp -av . $mnt_tar
>>>>>>> 7dc64d84764170782caeda80aab802e4722557ef
}

_bak_data_to_local()
{
<<<<<<< HEAD
	pool_sur=$(echo $dev_sur | awk -F"/" '{ print $1 }')
	pool_tar=$(echo $dev_tar | awk -F"/" '{ print $1 }')

	echo "mounting source device ..." && sleep 2
	sudo zpool list | grep $pool_sur 1>/dev/null 2>/dev/null || sudo zpool import -d /dev/disk/by-id $pool_sur
	sudo zfs mount | grep $dev_sur 1>/dev/null 2>/dev/null || sudo zfs mount $dev_sur # echo "---"

	echo "mounting target device ..." && sleep 2
	sudo zpool list | grep $pool_tar 1>/dev/null 2>/dev/null || sudo zpool import -d /dev/disk/by-id $pool_tar
	sudo zfs mount | grep $dev_tar 1>/dev/null 2>/dev/null || sudo zfs mount $dev_tar #echo "---"

	echo "empting target device ..." && sleep 2
	cd $mnt_tar && _empty_dev_tar

	echo "dumping from source device to target device ..." && sleep 2
	cd $mnt_sur && cp -av . $mnt_tar
=======

	[ -d $mnt_sur ] || sudo mkdir -p $mnt_sur
	sudo umount $mnt_sur 2>/dev/null

	sudo mount -t ext4 $device_sur $mnt_sur
	echo "mounting dadaset $device_tar" 
	sudo zfs umount $device_tar 2>/dev/null && sudo zfs mount $device_tar && sleep 5

	rm -r -f $mnt_tar/* ; cd $mnt_sur && cp -av . $mnt_tar

>>>>>>> 7dc64d84764170782caeda80aab802e4722557ef
}

_clean_apt()
{
<<<<<<< HEAD
	echo '2 秒後開始清除 APT 系統' && sleep 2
=======
	echo '2秒後開始清除 APT 系統' && sleep 2
>>>>>>> 7dc64d84764170782caeda80aab802e4722557ef
	sudo apt-get autoremove --purge
	sudo apt-get autoclean
	sudo apt-get clean
	sudo localepurge
}

_clean_bash()
{
<<<<<<< HEAD
	echo '2 秒後開始清除 bash 及 zsh 歷史指令' && sleep 2
=======
	echo '2秒後開始清除 bash 及 zsh 歷史指令' && sleep 2
>>>>>>> 7dc64d84764170782caeda80aab802e4722557ef
	[ -f ~/.bash_history ] && cat /dev/null > ~/.bash_history
	[ -f ~/.zsh_history ] && cat /dev/null > ~/.zsh_history
}

<<<<<<< HEAD
_rm_zfs_mnt_dir()
{
	for $zfs_set in $(sudo zfs mount | awk '{ print $1 }' | grep -E 'xpl/')
	do
		sudo zfs umount $zfs_set 2>/dev/null
	done

	for $zfs_set in $(sudo zfs mount | awk '{ print $1 }' | grep -E 'zpl/')
	do
		sudo zfs umount $zfs_set 2>/dev/null
	done

	for $mnt_dir in xktws xktwsb xmmedia xmmediab zktws zktwsb zmmedia zmmediab
	do
		sudo rm -rf /home/engells/mnt/$mnt_dir 2>/dev/null
	done
}

=======
>>>>>>> 7dc64d84764170782caeda80aab802e4722557ef
_rm_kernel()
{
	sudo apt-get purge '^linux-.*-4.18.0-17'
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


