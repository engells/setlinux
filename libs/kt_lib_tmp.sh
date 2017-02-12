# lib: this lib is for testing
# made by: Engells
# date: Sep 26, 2012
# content: 
# note: the arguments could be deliverd by lunch shcripts

sDir="/home/engells/ktws/scripts/install"

_cat_test()
{
	cat $sDir/pkgs.list | grep '^install_apt' | awk '{ print $2 }'
}


