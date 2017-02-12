#!/bin/bash
# vim:ts=4
# program: To set up chroot inner environment
# made by: Engells
# date: Dec 30, 2012
# content: To add user in chroot environment

_root_config()
{
[ -f /root/.bashrc ] || touch /root/.bashrc
cat > /root/.bashrc << HERE
export PATH=$PATH
export DISPLAY=:0
xauth merge /tmp/display
HERE

[ -f /root/.bash_profile ] || touch /root/.bash_profile
cat > /root/.bash_profile << HERE
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
HERE

[ -f /root/cln ] || touch /root/cln
cat > /root/cln << HERE
apt-get autoremove
apt-get remove
apt-get clean
cat /dev/null > /root/.bash_history
HERE

chmod a+x /root/cln

[ -f /root/.Xauthority ] || touch /root/.Xauthority
}

_add_group()
{
groupadd $group_name
grep $group_name /etc/group /etc/gshadow
}

_add_user()
{
useradd -g $group_name -m -d /home/$user_name -s /bin/bash $user_name 
grep $user_name /etc/passwd /etc/shadow /etc/group
passwd $user_name 
}

_bash_config()
{
[ -f /home/$user_name/.bashrc ] || touch /home/$user_name/.bashrc
cat > /home/$user_name/.bashrc << HERE
umask 022
export HISTIGNORE=shutdown:exit:df:\&
HISTCONTROL=ignoredups:ignorespace
PS1="${debian_chroot:+($debian_chroot)}\u@\h \W\$ "
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -al'
export DISPLAY=:0
HERE

[ -f /home/$user_name/.bash_profile ] || touch /home/$user_name/.bash_profile
cat > /home/$user_name/.bash_profile << HERE
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
HERE

[ -f /home/$user_name/cln ] || touch /home/$user_name/cln
cat > /home/$user_name/cln << HERE
apt-get autoremove
apt-get remove
apt-get clean
cat /dev/null > /home/$user_name/.bash_history
HERE

chmod a+x /home/$user_name/cln

chown $user_name:$user_name -R /home/$user_name/
}

group_name="engells"
user_name="engells"

echo ""; echo "to modify bash config files for root ..."; echo ""; sleep 2; _root_config
echo ""; echo "to creat a group with name of $group_name ...";echo ""; sleep 2; _add_group
echo ""; echo "to creat a user with name of $user_name ...";echo ""; sleep 2; _add_user
echo ""; echo "to creat bash config files for user $user_name ...";echo ""; sleep 2; _bash_config
echo ""; echo "to setup sudo configure for user $user_name ...";echo ""; sleep 2; visudo

if dpkg --get-selections | grep 'xauth' ; then
	echo '' > /dev/null
else
	apt-get update && apt-get install xauth
fi

dpkg-reconfigure locales
dpkg-reconfigure tzdata

unset group_name; unset user_name

