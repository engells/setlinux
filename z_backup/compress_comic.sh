#! /bin/bash
# vim:ts=4
# program: Using to rebuild cpmpressed comic files
# made by: Engells
# date: Jul 18, 2013
# content: 完成的內容
#	1.以第一參數表示作業程序為解壓縮、整理資料或製作壓縮檔
#	2.以第二參數表示表示解壓縮來源檔是否包括目錄在內
#	3.解壓縮、整理資料或製作壓縮檔皆以模組處理

_decompress()
{
if [ -z $2 ]; then 
	Des2='請輸入壓縮來源檔種類 wd:包含目錄 nd:不含目錄'
	printf "%s\n" "$Des2"
	read way2
	if [ -z "$way2" ]; then way2='wd' ; fi
else
	way2=$2
fi

if [[ "$way2" == "wd" ]]; then
	_decompress_wd
else
	_decompress_nd
fi
}

_decompress_wd()
{
for fn in $(ls ./)
do
	if [[ $(file $fn | grep 'bzip2') ]]; then
		[ -d $fn ] || tar jxvf $fn

	elif [[ $(file $fn | grep 'RAR') ]]; then
		[ -d $fn ] || unrar e $fn

	else
		echo "other file type" > /dev/null

	fi
done
}

_decompress_nd()
{
for fn in $(ls ./)
do
	if [[ $(file $fn | grep 'bzip2') ]]; then
		[ -d $fn ] || dn=$(echo $fn | sed 's/Comic-//' | sed 's/\.tar.*$//' | sed 's/-/_/')
		[ -d $fn ] || mkdir $dn && cd $dn && tar jxvf ../$fn && cd ..

	elif [[ $(file $fn | grep 'RAR') ]]; then
		[ -d $fn ] || dn=$(echo $fn | sed 's/Comic-//' | sed 's/\.rar$//' | sed 's/-/_/')
		[ -d $fn ] || mkdir $dn && cd $dn && unrar e ../$fn && cd ..

	else
		echo "other file type" > /dev/null

	fi
done
}

_rm_photo_db()
{
for dn in $(ls ./)
do
	if [[ -d $dn ]]; then
		rm ./$dn/Thumbs.db 2>/dev/null; rm ./$dn/*.txt 2>/dev/null
		fn=$(echo $dn | sed 's/Comic_//' | sed 's/-/_/')
		[[ "$dn" != "$fn" ]] && mv $dn $fn
	fi
done
}

_compress()
{
for dn in $(ls ./)
do
	if [[ -d $dn ]]; then
		fn=$(echo "Comic-$dn.tar" | sed 's/_/-/')
		echo $fn
		tar cvf $fn $dn
	fi
done
}

if [ -z $1 ]; then 
	Des1='請輸入處理方式 de:解壓縮 rm:整理資料 cp:製作壓縮檔 all:左列全部作業'
	printf "%s\n" "$Des1"
	read way1
	if [ -z "$way1" ]; then way1='all' ; fi

else
	way1=$1
fi

case $way1 in
	de)
		_decompress ;;
	rm)
		_rm_photo_db ;;
	cp)
		_compress ;;
	all)
		_decompress
		_rm_photo_db
		_compress ;;
	*)
		echo " " > /dev/null
esac

