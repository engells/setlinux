#!/bin/bash
# vim:ts=4
# program: To transform audio
# made by: Engells
# date: Jan 22, 2014
# content: wave to mp3, and wave to flac

_tran_mp3()
{
for on in $(ls *.wav)
do
	nn=$(echo $on | sed 's/Track_//' | sed 's/\.wav//')
	if (($nn < 10)); then nn=0$nn; fi
	nn=$(basename $(pwd))_$nn.mp3
	lame -V1 $on $nn
done
}

_tran_flac()
{
for on in $(ls *.wav)
do
	flac --keep-foreign-metadata $on
done

for on in $(ls *.flac)
do
	nn=$(echo $on | sed 's/Track_//' | sed 's/\.flac//')
	if (($nn < 10)); then nn=0$nn; fi
	nn=$(basename $(pwd))_$nn.flac
	mv $on $nn
done
}

#-確認作業方式------------
if [ -z $1 ]; then
	Des="請輸入轉換格式:"; printf "%s\n" "$Des"
	Des="m: 轉換為 mp3"; printf "%s\n" "$Des"
	Des="f: 轉換為 flac"; printf "%s\n" "$Des"
	read way1
	if [ -z "$way1" ]; then echo '未選擇轉換格式, 兩秒鐘後離開程式...' && sleep 2 && exit 1 ; fi
else
	way1=$1
fi

#-實際作業--------------

rename 's/Track /Track_/' *

case $way1 in
	m) _tran_mp3 ;;
	f) _tran_flac ;;
	*) echo '錯誤 未定義之作業方式' ;;
esac

