#!/bin/bash
# vim:ts=4
# program: to extract files in a folder
# made by: Engells
# date: May 1, 2022
# content: 

#====副函式======================


#====程式主體=====================

i=0

for name_file_if in $(ls ./)
do
  name_file_prefix=${name_file_if%\.*}     # 取得檔名主體
  name_file_postfix=${name_file_if##*\.}   # 取得副檔名
  #echo "$name_file_if  $name_file_prefix  $name_file_postfix  $0"

  case $name_file_postfix in
    tar)
      mkdir $name_file_prefix && tar xvf $name_file_if -C $name_file_prefix
      ;;
    bz2)
      [[ "${name_file_if:0-7:3}" == "tar" ]] && mkdir ${name_file_prefix%\.*}  || mkdir $name_file_prefix
      [[ "${name_file_if:0-7:3}" == "tar" ]] && tar jxvf $name_file_if -C $name_file_prefix || bzip2 -d $name_file_if
      ;;
    xz)
      [[ "${name_file_if:0-6:3}" == "tar" ]] && mkdir ${name_file_prefix%\.*}  || mkdir $name_file_prefix
      [[ "${name_file_if:0-6:3}" == "tar" ]] && tar Jxvf $name_file_if -C $name_file_prefix || xz -d $name_file_if
      ;;
    7z)
      7z x -o${name_file_prefix} $name_file_if 
      ;;
    sh)
      ;;
    *)
      if [ $name_file_if != ${0#\.\/} ]; then echo "$name_file_if is not known compression file type, nothing will not do!"; fi
      ;;
  esac
done

unset name_file_if; unset name_file_prefix; unset name_file_postfix
unset i

