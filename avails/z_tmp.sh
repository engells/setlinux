#!/bin/bash
# vim:ts=2
# program: Using for script sample and testing
# made by: Engells
# date: Dec 21, 2011
# content: 

echo '選擇處理方式 r:移除Linux核心 w:批次下載 a:增加repository'

read way

if [ -z $way ]; then echo '未輸入處理方式,2秒後跳出程式' && sleep 2 ; fi

DIA='/usr/bin/dialog'											
TMP='/dev/shm/dialog-out'

case $way in

	r)
		#To remove linux core
		sudo apt-get purge linux-image-3.2.0-23
		;;

	w)
		for (( i=0; i<=68; i=i+1))
		do
		 j="http://a.blog.xuite.net/a/a/c/1/25950422/blog_2573371/txt/60995144/$i.jpg"
		 wget $j
		done
		;;

	a)
		#To add a reponsitory method 1
		sudo add-apt-repository $InText			#ex: ppa:ubuntu-wine/ppa
		##sudo add-apt-key

		#To add a reponsitory method 2
		#deb http://download.virtualbox.org/virtualbox/debian jaunty non-free
		#wget -q http://download.virtualbox.org/virtualbox/debian/sun_vbox.asc -O- | sudo apt-key add -
		;;

	t)
		#  1.jpg => 01.jpg
		for f in $(ls ./)
		do
		 f_prefix=${f%.*}
		 if (( $f_prefix < 10 )); then
		  f_suffix=${f#*.}
		  mv f 0$f_prefix.$f_suffix;
		 fi
		done
		;;

	*)

		echo '未定義之處理方式,2秒後跳出程式' && sleep 2
		;;

esac

rm -f "$TMP"
unset DIA												
unset TMP; unset mTitile; ; unset PreText; unset InText
unset i; unset f; unset f_prefix; unset f_suffix

