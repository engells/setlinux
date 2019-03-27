#!/bin/sh
# vim:ts=4
# program: To backup tmpfs while halting
# made by: Engells
# date: Feb 9, 2013
# content: 

_dump2bak()
{
rm -rf $tardir/*
cd $surdir
cp -R . $tardir
}

_chg_owner()
{
chown -R engells:engells $surdir
chown -R engells:engells $tardir
}

for way in varlog userdl
do
	case $way in
		varlog)
			# to backup /var/log
			surdir=/var/log
			tardir=/var/backups/log
			_dump2bak
			;;
		userdl)
			# to backup ~/downloads
			surdir=/home/engells/downloads
			tardir=/home/engells/mnt/bak
			_dump2bak
			_chg_owner
			;;
		cache)
			# to backup ~/.cache
			surdir=/home/engells/.cache
			tardir=/home/engells/mnt/cache
			_dump2bak
			_chg_owner
			;;
		*)
			echo '' > /dev/null
	esac
done

unset way; unset surdir ; unset tardir

