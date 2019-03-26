#!/bin/sh
# vim:ts=4
# program: To reload files to tmpfs while booting
# made by: Engells
# date: Feb 9, 2013
# content: 

_dump2bak()
{
sudo rm -rf $tardir/*
cd $surdir
sudo cp -R . $tardir
}

_chg_owner()
{
sudo chown -R engells:engells $surdir
sudo chown -R engells:engells $tardir
}

for way in varlog userdl
do
	case $way in
		varlog)
			# to reload /var/log
			surdir=/var/backups/log
			tardir=/var/log
			_dump2bak
			;;
		userdl)
			# to reload ~/downloads
			surdir=/home/engells/mnt/bak
			tardir=/home/engells/downloads
			_dump2bak
			_chg_owner
			;;
		cache)
			# to reload ~/.cache
			surdir=/home/engells/mnt/cache
			tardir=/home/engells/.cache
			_dump2bak
			_chg_owner
			;;
		samba)
			# disable samba servive after booting
			service smbd stop
			service nmbd stop
			;;
		*)
			echo '' > /dev/null
	esac
done

unset way; unset surdir ; unset tardir

