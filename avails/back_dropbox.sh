#!/bin/bash
# vim:ts=2
# program: Using to backup data to Dropbox
# made by: Engells
# date: Dec 21, 2011
# content: 

_cp_files()
{
[ -d $dir_tar ] || mkdir -p $dir_tar

cd $dir_tar

for dir_sub in $(ls $dir_tar)
do
	if [ -d $dir_sub ]; then
		rm -r $dir_sub
	else
		rm $dir_sub
	fi
done

cd $dir_sur && cp -av . $dir_tar/ && cd ~/mnt/bak
}

for item in script computer linux win access

do
	case $item in
	script)
		dir_sur='/home/engells/ktws/scripts'
		dir_tar='/home/engells/mnt/Dropbox/Linux_Scripts'
		;;
	computer)
		dir_sur='/home/engells/ktws/0_know_computer'
		dir_tar='/home/engells/mnt/Dropbox/Computer_Docs'
		;;
	linux)
		dir_sur='/home/engells/ktws/0_know_linux'
		dir_tar='/home/engells/mnt/Dropbox/Linux_Docs'
		;;
	win)
		dir_sur='/home/engells/ktws/0_know_win'
		dir_tar='/home/engells/mnt/Dropbox/Win_Docs'
		;;
	access)
		dir_sur='/home/engells/ktws/0_know_office/MS_Access_2003'
		dir_tar='/home/engells/mnt/Dropbox/Office_Docs'
		;;
	*)
		echo '' > /dev/null
	esac

	echo '';	echo "processing $item"; echo ''

	_cp_files

done

echo '' && echo 'dumping operation finished ...' && echo '' && sleep 5

unset item; unset dir_sub; unset dir_sur; unset dir_tar


