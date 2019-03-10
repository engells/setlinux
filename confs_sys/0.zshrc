# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH=/home/engells/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# 設定 tmuxifier
[[ -s "$HOME/.tmuxifier/init.sh" ]] && source "$HOME/.tmuxifier/init.sh"
export EDITOR=vim

# 設定umask
umask 022

# 設定不存入歷史指令檔的指令
export HISTIGNORE=shutdown:exit:df:\&

# 不紀錄重複指令
HISTCONTROL=ignoredups:ignorespace

# 設定路徑，加入~/ktws/scripts
export PATH=$PATH:~/mnt/scripts

# 設定提示符號
#PS1='[\u@\h \W]\$ '

# 設定彩色顯示 ls 指令結果
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -al'


