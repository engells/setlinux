#!/bin/bash
# vim:ts=4
# program: To rename files
# made by: Engells
# date: Oct 05, 2012
# content:

# 將原有檔名前加入$1參數，並將.rar更換為.DOS.rar或.zip換為.DOS.zip

	Dir="./"
	fName=${3:-'Str.Wa'} 

	for f in $(ls $Dir)
	do
		case $f in
			*.rar) mv $f 'Game.'$fName'.'$f ;;
			*.zip) mv $f 'Game.'$fName'.'$f ;;
			*) echo 'a' > /dev/null ;;
		esac
	done

	rename 's/\.rar/\.DOS\.rar/' *.rar 2> /dev/null
	rename 's/\.zip/\.DOS\.zip/' *.zip 2> /dev/null

	unset Dir
	unset fName


# 所有檔名開頭為 One 的 rar 壓縮檔，更換為 One.Vol.0 開頭的檔名。重點在於對 . 使用跳脫字元(反斜號)
	rename 's/^One/OnePiece\.Vol\.0/' *.rar

# 將所有符合.DVD加上多個任意字元加上FoV的字串從檔名中刪除
	rename 's/\.DVD.*FoV//' *.*

# 將zip壓縮檔改為.DOS.zip結尾，此法運用參數擴展技巧
	find ./ -name '*.zip'|while read i; do mv $i ${i%.zip}.DOS.zip; done
	find ./ -name '*.zip'|while read i; do mv $i ${i/%.zip/.DOS.zip}; done

# 將小括弧內含一個以上字元的字串清除
	rename 's/\(..*\)/---/g' *.*
