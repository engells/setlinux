#!/bin/bash
# vim:ts=2

if [ -z $1 ]; then 
	Des='請輸入轉換語系 tw:繁體中文 us:美式英文'
	printf "%s\n" "$Des"

	read way
	if [ -z "$way" ]; then echo '未選擇處理方式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi

else

	way=$1

fi

work_tty=$(tty)
chk_tty=$(echo ${work_tty} | awk -F "/" '{print $3}')

if [ "${work_tty}" = "/dev/tty1" ] || [ ${chk_tty} = pts ]; then

	case $way in
		tw)
			target_locale="zh_TW.UTF-8" ;;
		*)
			target_locale="en_US.UTF-8"
	esac

	export LANG="${target_locale}"
	export LANGUAGE="${target_locale}"
	export LC_CTYPE="${target_locale}"
	export LC_ALL="${target_locale}"

fi

unset way ;unset work_tty ; unset chk_tty ; unset target_locale

