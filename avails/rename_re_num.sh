#!/bin/bash
# vim:ts=4
# program: to rename files in a folder
# made by: Engells
# date: Apr 19, 2022
# content: 

#====副函式======================

_name_num()
{
if (($i<10)); then
  name_file_num="000"${i}
elif (($i<100)); then
  name_file_num="00"${i}
elif (($i<1000)); then
  name_file_num="0"${i}
else
  name_file_num=${i}
fi
}

_name_full()
{
name_file_of="${name_file_prefix}__${name_file_num}.${name_file_postfix}"
}


#====程式主體=====================

i=0

for name_file_if in $(ls ./)
do
  name_file_prefix=${name_file_if%__*}    # 取得檔名主體
  name_file_postfix=${name_file_if##*\.}  # 取得副檔名

  _name_num
  _name_full

  #echo "${name_file_prefix}  ${name_file_postfix}  $i  ${name_file_num}"
  if [ ${name_file_if} != ${0#\.\/} ]; then mv $name_file_if $name_file_of; fi

  i=$(($i+1))  # 雙層小括弧確保變數 i 為數字
done

unset name_file_if; unset name_file_of
unset name_file_prefix; unset name_file_num; unset name_file_postfix
unset i

