#!/bin/bash
# program: To buidl LAMP condition.
# made by: Engells
# date: Oct 24, 2012
# content: To To buidl LAMP condition

_install_lamp_pack()
{
echo ""; echo 'starting to install lamp ...'; echo ""; sleep 3 
apt-get install lamp-server^
apt-get install phpmyadmin
}

_install_lamp_dtl()
{
echo ""; echo 'starting to install lamp ...'; echo ""; sleep 3
apt-get install apache2
apt-get install php5 libapache2-mod-php5

[ -f /var/www/phpinfo.php ] || touch /var/www/phpinfo.php
cat > "/var/www/phpinfo.php" << HERE
<?php
phpinfo();
?>
HERE
service apache2 restart
firefox http://localhost/phpinfo.php

_enable_phpmyadmin

apt-get install mysql-server
#apt-get install libapache2-mod-auth-mysql	(optional)
#apt-get install php5-mysql		(optional)
#apt-get install phpmyadmin		(optional)
}

_config_php()
{
sed -i '/register_globals/s/on/off/g' /etc/php5/apache2/php.ini
}

_enable_phpmyadmin()
{
ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf
service apache2 restart
}

_add_virtual_host()
{
echo ""; echo 'starting to add a new virtual host on apache server ...'; echo ""; sleep 3
mkdir -p $html_dir

cat > "/etc/apache2/sites-available/$html_url" << HERE
<VirtualHost *:80>
ServerAdmin engells@gmail.com
ServerName $html_url
ServerAlias www.$html_url
DocumentRoot "$html_dir"
	<Directory "$html_dir">
		AllowOverride All
		Order allow,deny
		Allow from All
	</Directory>
</VirtualHost>
HERE

a2ensite $html_url
service apache2 reload

echo 127.0.0.1$'\t'$html_url$'\t'$'\t'www.$html_url >> /etc/hosts
}

html_dir="/home/www"
html_url="home.idv"

_install_lamp_pack
#_config_php
_enable_phpmyadmin
_add_virtual_host
