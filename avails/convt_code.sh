#!/bin/bash
# program: to convert code of file
# made by: Engells
# date: Oct 6, 2012
# content: 

for f in $( ls *.txt )
do
	iconv -f BIG-5 -t UTF-8 $f -o 風塵劫-$f
	#rename 's/jy_001//g' *.*
done
