# vim:ts=2
# lib: Using to clean system and config trackball
# made by: Engells
# date: Mar 31, 2019
# content: 
# note: the arguments could be deliverd by lunch shcripts

_empty_dev_tar()
{
	for DIR in $(ls $mnt_tar)
	do
		[ -d $DIR ] && rm -rvf $DIR
		[ -f $DIR ] && rm -vf $DIR
	done
}

_bak_data_to_portable()
{
	pool_sur=$(echo $dev_sur | awk -F"/" '{ print $1 }')

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
}

_bak_data_to_local()
{
	pool_sur=$(echo $dev_sur | awk -F"/" '{ print $1 }')
	pool_tar=$(echo $dev_tar | awk -F"/" '{ print $1 }')

	echo "mounting source device ..." && sleep 2
	sudo zpool list | grep $pool_sur 1>/dev/null 2>/dev/null || sudo zpool import -d /dev/disk/by-id $pool_sur
	sudo zfs mount | grep $dev_sur 1>/dev/null 2>/dev/null || sudo zfs mount $dev_sur

	echo "mounting target device ..." && sleep 2
	sudo zpool list | grep $pool_tar 1>/dev/null 2>/dev/null || sudo zpool import -d /dev/disk/by-id $pool_tar
	sudo zfs mount | grep $dev_tar 1>/dev/null 2>/dev/null || sudo zfs mount $dev_tar

	echo "empting target device ..." && sleep 2
	cd $mnt_tar && _empty_dev_tar && sudo chown $(whoami):$(whoami) -R $mnt_tar

	echo "dumping from source device to target device ..." && sleep 2
	cd $mnt_sur && sudo rsync -avAHX . $mnt_tar
}

_clean_apt()
{
	echo '2 秒後開始清除 APT 系統' && sleep 2

	sudo apt-get autoremove --purge
	sudo apt-get autoclean
	sudo apt-get clean
	sudo localepurge
}

_clean_bash()
{
	echo '2 秒後開始清除 bash 及 zsh 歷史指令' && sleep 2

	[ -f ~/.bash_history ] && cat /dev/null > ~/.bash_history
	[ -f ~/.zsh_history ] && cat /dev/null > ~/.zsh_history
}

_rm_zfs_mnt_dir()
{
	echo '卸載 kpl dataset'
	for zfs_set in ktwsb mmediab
	do
		sudo zfs umount kpl/$zfs_set 2>/dev/null
	done

	echo '卸載 xpl 以及 zpl dataset'
	for zfs_set in $(sudo zfs mount | awk '{ print $1 }' | grep -E 'xpl|zpl')
	do
		sudo zfs umount $zfs_set 2>/dev/null
	done

	echo '2 秒後開始移除 dataset 掛載點' && sleep 2
	for mnt_dir in ktws mmedia ktwsb mmediab virt warehouse
	do
		sudo rm -rf /home/engells/mnt/$mnt_dir 2>/dev/null
		sudo rm -rf /home/engells/mnt/x$mnt_dir 2>/dev/null
		sudo rm -rf /home/engells/mnt/z$mnt_dir 2>/dev/null
	done
}

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


