# lib: this lib is for testing
# vim:ts=2
# made by: Engells
# date: Sep 26, 2012
# content: 
# note: the arguments could be deliverd by lunch shcripts

sDir="/home/engells/ktws/scripts/install"

_cat_test()
{
	cat $sDir/pkgs.list | grep '^install_apt' | awk '{ print $2 }'
}

_bash_array_test()
{
  DDS=(
    a1
    b1
    c1 c2 c3
    d1
    e1 e2
  )

  for DD in ${DDS[@]}; do
    echo $DD
  done

  #SHELL_CONFIGS_DIR=~/repos/shell-dev-configs

  # Bash array
  #CONFIGS=(
  #  .aliases
  #  .profile
  #  .commonrc .bashrc .zshrc
  #  .vimrc
  #  .gitconfig .gitignore
  #)

  # Symlink repo's .foo as a new file ~/.foo
  #for CONFIG in ${CONFIGS[@]}; do
  #  ln -sf "$SHELL_CONFIGS_DIR/$CONFIG" "$CONFIG"
  #done
}

