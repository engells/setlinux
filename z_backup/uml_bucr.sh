#! /bin/bash
# vim:fdm=marker:ts=2
# program: To buidl chroot environment
# made by: Engells
# date: Dec 30, 2012
# content: To buidl chroot environment via debootstrap command

_install_debootstrap()
{
	sudo apt-get update
	sudo apt-get install debootstrap
}

_build_chroot()
{
	echo ""; echo "to build chroot environment of $desc_txt ..."; echo ""; sleep 2

	[ -d $dir_name ] || sudo mkdir $dir_name

	sudo debootstrap --arch $arch_type $linux_dist $dir_name $pkg_sur

	[ -d $dir_name/dev/input ] || sudo mkdir -p $dir_name/dev/input

	[ -f $dir_name/etc/apt/sources.list ] && \
		sudo mv $dir_name/etc/apt/sources.list $dir_name/etc/apt/sources.list.bak
	echo 'deb http://free.nchc.org.tw/ubuntu/ precise main' | sudo tee $dir_name/etc/apt/sources.list

	[ -f $dir_name/var/lib/locales/supported.d/local ] && \
		sudo mv $dir_name/var/lib/locales/supported.d/local $dir_name/var/lib/locales/supported.d/local.bak
	echo 'en_US.UTF-8 UTF-8' | sudo tee $dir_name/var/lib/locales/supported.d/local

	sudo cp /mnt/conf/setcr $dir_name/root/
}

#=ensure package debootstrap is installed==================
if dpkg --get-selections | grep 'debootstrap' ; then
	echo '' > /dev/null
else
	_install_debootstrap
fi


#=parepare configure setup files============================
[ -d /mnt/conf ] || sudo mkdir -p /mnt/conf
sudo cp /home/engells/ktws/scripts/avails/uml_sub_config.sh /mnt/conf/setcr
sudo chmod a+x /mnt/conf/setcr
sudo ln -s /home/engells/ktws/scripts/avails/uml_enter.sh /usr/local/bin/encr
sudo chmod a+x /usr/local/bin/encr


#=install chroot environment================================
linux_dist="precise"
pkg_sur="http://free.nchc.org.tw/ubuntu"

for chroot_type in u64 u32
do
	case $chroot_type in
		u64)
			desc_txt="Ubuntu 64 bit"
			arch_type="amd64"
			dir_name="/mnt/u64"
			_build_chroot ;;
		u32)
			desc_txt="Ubuntu 32 bit"
			arch_type="i386"
			dir_name="/mnt/u32"
			_build_chroot ;;
	*)
		echo "Nothing" > /dev/null ;;
	esac
done


#=prepare to quit the script================================
unset desc_txt; unset arch_type; unset linux_dist; unset dir_name; unset pkg_sur


