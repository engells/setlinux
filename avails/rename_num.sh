#!/bin/bash

for d in $(ls ./)
do

	if [ -d $d ]; then

	  cd $d

	  for f in $(ls ./)
	  do

		rename 's/00/0/' *.jpg
		#f_prefix=${f%.*}

		#if (( $f_prefix <= 9 )); then
		#  f_suffix=${f#*.}
		#  mv $f 0$f_prefix.$f_suffix;
		#fi
	  done

	 cd ..

	fi

done
