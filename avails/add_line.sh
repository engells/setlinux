#!/bin/bash
# program: to add lines into txt file
# made by: Engells
# date: Oct 6, 2012
# content: 

echo '選擇處理方式 1:使用 sed 及 echo 2:使用 sed G'

read way

if [ -z $way ]; then echo '未輸入處理方式,2秒後跳出程式' && sleep 2 && exit 2 ; fi

case $way in

	1)

		cat a.txt | sed '/^$/d' > b.txt

		while read line
		do
			echo $line >> c.txt
			echo >> c.txt
		done < "b.txt"
		;;

	2)
		#處理 txt 小說，自動增加空白行。本段作為利用 awk 取得參數之範例
		mTitile='請依序輸入: \n 來源檔檔名(-if:) 輸出檔檔名(-of:)'	#輸入視窗提示標題
		PreText='-if:/home/engells/aa.txt -of:/home/engells/ab.txt'	#預設處理檔案

		$DIA --inputbox "$mTitile" 10 75 "$PreText" 2> $TMP		#將輸入視窗資料傳入暫存檔

		InText=$( cat $TMP )						#將暫存檔導入變數$InText
		[ -z "$InText" ] && InText=$PreText				#若變數$InText為空值，代入變數$PreText之值

		for i in $InText
		do
			case $i in
				-if*) f1=$(echo $i | awk -F: '{ print $2 }') ;;	#取得 -if: 之後的字串，即來源檔檔名
				-of*) f2=$(echo $i | awk -F: '{ print $2 }') ;;	#取得 -of: 之後的字串，即輸出檔檔名
			esac
		done

		cat $f1 | sed G > $f2

		unset i; unset f1; unset f2
		;;


	*)

		echo '未定義之處理方式,2秒後跳出程式' && sleep 2 && exit 3
		;;

esac

rm -f "$TMP"
unset DIA												
unset TMP
unset mTitile
unset PreText
unset InText
