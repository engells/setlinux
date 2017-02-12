#!/bin/bash
# vim:ts=2
# program: To create a bootable USB devive
# made by: Engells
# date: Jan 25, 2013
# content: 

# lib zone ===================

_enboot_fat()
{
echo ""; echo "starting to make $tar_dev bootable ..."; echo ""
sudo mkfs.vfat -n $vol_name $tar_dev; sleep 2
sudo mount $tar_dev $mnt_tar; sudo mkdir -p $mnt_tar/boot/syslinux/
sudo umount $mnt_tar
sudo syslinux -d /boot/syslinux -i $tar_dev
sudo mount $tar_dev $mnt_tar
sudo cp /usr/lib/syslinux/{chain.c32,memdisk,menu.c32,reboot.c32,vesamenu.c32} $mnt_tar/boot/syslinux/
sudo cp /home/engells/ktws/scripts/configs/syslinux.cfg $mnt_tar/boot/syslinux/
sudo umount $mnt_tar
sudo dd if=/usr/lib/syslinux/mbr.bin of=$tar_dsk
echo ""; echo "$tar_dev is bootable ..."; echo ""
}

_enboot_ext()
{
echo ""; echo "starting to make $tar_dev bootable ..."; echo ""
sudo mkfs.ext2 -L $vol_name $tar_dev; sleep 2
sudo mount $tar_dev $mnt_tar; sleep 2
sudo extlinux -i $mnt_tar; sleep 2
sudo umount $mnt_tar; sleep 2
echo ""; echo "$tar_dev is bootable  ..."; echo ""
}

_dump_img()
{
echo ""; echo "stating to mount device and img file ..."; echo ""
sudo mount $tar_dev $mnt_tar
sudo mount $sur_img $mnt_sur

echo "stating to dump files form img file to device ..."; echo ""
cd $mnt_sur; sudo cp -av . $mnt_tar

echo ""; echo "starting to rename isolinux.xxx to syslinux.xxx ..."; echo ""
cd $mnt_tar
if [ -d isolinux ] ; then
	cd isolinux
	[ -f isolinux.bin ] && sudo mv isolinux.bin syslinux.bin
	[ -f isolinux.cfg ] && sudo mv isolinux.cfg syslinux.cfg
	cd $mnt_tar
	sudo mv isolinux syslinux
else
	[ -d boot/syslinux ] || sudo mkdir -p boot/syslinux && sudo touch boot/syslinux/syslinux.cfg
fi

cd ~/
#sudo sync
echo ""; echo "stating to umount device and img file after 60 seconds..."; echo ""; sleep 60
sudo umount $mnt_tar
sudo umount $mnt_sur

echo ""; echo "finish current dumping ..."; echo ""; sleep 2
}


# operation model choice =====

if [ -z $1 ]; then 
	des='請輸入處理方式 pre:格式劃分割區 ins:安裝可開機系統'
	printf "%s\n" "$des"

	read way
	if [ -z "$way" ]; then echo '未選擇處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi

else

	way=$1

fi


# perpartion zone ============
tar_dsk='/dev/sdb'
[ -d /home/engells/mnt/dump1 ] || mkdir -p /home/engells/mnt/dump1
[ -d /home/engells/mnt/dump2 ] || mkdir -p /home/engells/mnt/dump2
mnt_tar="/home/engells/mnt/dump1"
mnt_sur="/home/engells/mnt/dump2"


# format partition ===========
case $way in
	pre)
		# make 1st primary partition bootable with syslinux
		i=1; tar_dev=$tar_dsk$i; vol_name='Boot'
		_enboot_fat

		# make other partition bootable with extlinux
		for os in u32 u64 sr pm sl mi
		do
			case $os in
			u32)
				i=2; tar_dev=$tar_dsk$i; vol_name='Linux_32'
				;;
			u64)
				i=3; tar_dev=$tar_dsk$i; vol_name='Linux_64'
				;;
			sr)
				i=5; tar_dev=$tar_dsk$i; vol_name='SysRescue'
				;;
			pm)
				i=6; tar_dev=$tar_dsk$i; vol_name='PMagic'
				;;
			sl)
				i=7; tar_dev=$tar_dsk$i; vol_name='Slax'
				;;
			mi)
				i=8; tar_dev=$tar_dsk$i; vol_name='Minis'
				;;
			*)
				echo '' > /dev/null
			esac

			_enboot_ext

		done

		;;	

	ins)
		sudo umount $mnt_tar

		# dump os img to partition
		for os in u32 u64 sr pm sl
		do
			case $os in
			u32)
				i=2; tar_dev=$tar_dsk$i
				sur_img="/home/engells/ktws/0_sur_linux/dist_linux/Ubuntu-12.04.1-desktop-i386.iso"
				;;
			u64)
				i=3; tar_dev=$tar_dsk$i
				sur_img="/home/engells/ktws/0_sur_linux/dist_linux/Ubuntu-12.04.1-alternate-amd64.iso"
				;;
			sr)
				i=5; tar_dev=$tar_dsk$i
				sur_img="/home/engells/ktws/0_sur_linux/dist_linux/SystemrRscueCD-3.2.0-x86.iso"
				;;
			pm)
				i=6; tar_dev=$tar_dsk$i
				sur_img="/home/engells/ktws/0_sur_linux/dist_linux/PartedMagic-201212-amd64.iso"
				;;
			sl)
				i=7; tar_dev=$tar_dsk$i
				sur_img="/home/engells/ktws/0_sur_linux/dist_linux/Slax-7.0-amd64.iso"
				;;
			*)
				echo '' > /dev/null
			esac

			echo "starting to dumping $sur_img to $tar_dev ..."

			_dump_img

		done

		;;

	*)

		echo '未定義之處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 2

esac

unset des; unset way; unset os; unset i
unset tar_dsk; unset tar_dev; unset mnt_tar; unset sur_img; unset mnt_img

