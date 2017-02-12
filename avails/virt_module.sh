#! /bin/bash
# vim:ts=4
# program: To start or stop vbox/kvm
# made by: Engells
# date: Feb 3, 2013
# content: 

Des="請輸入處理方式:"; printf "%s\n" "$Des"
Des="rb: 卸載 VirtualBox 模組"; printf "%s\n" "$Des"
Des="rk: 卸載 KVM 模組"; printf "%s\n" "$Des"
Des="lb: 啟用 VirtualBox 模組"; printf "%s\n" "$Des"
Des="lk: 啟用 KVM 模組"; printf "%s\n" "$Des"
Des="mb: 修復 VirtualBox 模組"; printf "%s\n" "$Des"
read way
if [ -z "$way" ]; then echo '未選擇處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi

case $way in
	rb)
		sudo service vboxdrv stop
		;;
	rk)
		sudo service qemu-kvm stop
		;;
	lb)
		sudo service qemu-kvm stop
		sudo service vboxdrv start
		;;
	lk)
		sudo service vboxdrv stop
		sudo service qemu-kvm start
		;;
	mb)
		sudo service vboxdrv setup
		;;
	*)
		echo '未定義之處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 2
esac

sleep 3; unset Des; unset way

