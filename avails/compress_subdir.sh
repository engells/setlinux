#!/bin/bash
# program: To compress sub-dorectories in a directory
# made by: Engells
# date: Apr 3, 2018
# content: 將次一級目錄壓縮為 tar 檔案

compress_dirs()
{
rename 's/ /\_/g' * #處理檔名有空格的檔案及目錄

for d in $(ls ./)
do
	if [[ -d $d ]]; then tar -cvf $d.tar $d; fi
done
}

compress_dirs
