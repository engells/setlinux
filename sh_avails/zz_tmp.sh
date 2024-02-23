#!/bin/bash
SAVEIFS=$IFS		#新增一個變數SAVEIFS，把原本的IFS值儲存起來。
IFS=$(echo -en "\n\b")	#將IFS的值改掉
for FILE in $(ls ./)
do
#NEWNAME=`echo $FILE|sed -e "s/ /_/g"`
#mv $FILE $NEWNAME
echo $FILE
cp $FILE ../
done

#檢視一下：
#ls *.mp3
#aaa.mp3  bbb.mp3  ccc.mp3
#成功了，最後別忘了把IFS的值設回來：
IFS=$SAVEIFS
