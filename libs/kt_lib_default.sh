# lib: Using to clean system and config trackball
# made by: Engells
# date: June 05, 2012
# content: 
# note: the arguments could be deliverd by lunch shcripts

_clean_apt()
{
	echo '2秒後開始清除系統' && sleep 2
	sudo apt-get autoremove --purge
	sudo apt-get autoclean
	sudo apt-get clean
	sudo localepurge
}

_clean_bash()
{
	echo '2秒後開始清除bash歷史指令' && sleep 2
	cat /dev/null > ~/.bash_history
}

_set_trackball()
{
	xinput set-prop 'Logitech USB Trackball' "Evdev Wheel Emulation" 1
		# 啟用滾輪模擬: 啟用後，按住滾輪模擬鍵再滾動軌跡球，即等於滾輪滾動。
	xinput set-prop 'Logitech USB Trackball' "Evdev Wheel Emulation Button" 9
		# 指定滾輪模擬鍵: 8 是小左鍵，9是小右鍵。在 GPointing Settings 中，不能指定第9鍵。
	xinput set-prop 'Logitech USB Trackball' "Evdev Wheel Emulation Axes" 6 7 4 5
		# 允許水平與垂直方向滾動。
	xinput set-prop 'Logitech USB Trackball' "Evdev Wheel Emulation Timeout" 200
	xinput set-prop 'Logitech USB Trackball' "Evdev Middle Button Emulation" 1
		# 啟用中鍵模擬：啟用後，同時點擊左鍵與右鍵等於點擊中鍵。
	xinput set-prop 'Logitech USB Trackball' "Evdev Middle Button Timeout" 50 
}

_dl_youtube()
{
	for l in url1 url2 url3
	do
		youtube-dl $l
	done
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

_test_echo()
{
	echo $tt
}
