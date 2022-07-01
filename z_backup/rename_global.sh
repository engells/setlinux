#!/bin/bash
# vim:ts=2
# program: To remane sub-dorectories and files in a directory
# made by: Engells
# date: Sep 26, 2012
# content: 應用遞迴涵式技巧進入各子目錄，配合二個涵式分別更名目錄及檔案名稱，將目標目錄底下所有子目錄及檔案全部更名。

cycle_dirs()
{
rename 's/ /\_/g' * #處理檔名有空格的檔案及目錄

for f in $(ls ./)
do
  if [[ -d $f ]]; then rename_dir $f; fi
done

for f in $(ls ./)
do
  if [[ ! -d $f ]]; then
    rename_file $f
  else
    cd $f
    cycle_dirs
    cd ..
  fi
done
}

rename_dir()
{
  nf=$(echo $1 | sed 's/-/\_/g' | sed 's/ /\_/g'  | sed 's/\./\_/g')
  echo "Now, renameing dir: $1, new name would be $nf"
  [[ $1 = $nf ]] || mv $1 $nf

}

rename_file()
{
  [[ -d $1 ]] || chmod 644 $1
  nf=$(echo $1 | sed 's/(/-/g' | sed 's/)//g')
  nf=$(echo $nf | sed 's/\./-/g' | sed 's/\_/-/g' | sed 's/ /-/g' | sed 's/--*/-/g')
  nf=$(echo $nf | sed 's/\(^..*\)-/\1\./' | sed 's/-tar/\.tar/')
  #echo "Now, renameing file: $1, new name would be $nf"
  [[ $1 = $nf ]] || mv $1 $nf  
}

cycle_dirs

if [[ -f ./rename.sh ]]; then chmod a+x ./rename.sh; fi

#rename 's/ /\_/g' $f


