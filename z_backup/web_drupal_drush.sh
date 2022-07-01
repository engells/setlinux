#!/bin/bash
# vim:fdm=marker:ts=2
# program: To buidl webs with drush on a stnadby LAMP condition.
# made by: Engells
# date: Oct 21, 2012
# content: To make sure the LAMP situation is ready before running the script.
#	This scripts will build four sites: kth.idv, kth.idv/akt, kth.idv/kpt, proto.idv and dev.idv.
# Remember run the script with root authorization: sudo ./drupal_drush.sh

_install_drush()
{
#{{{
echo ""; echo 'staring to install drush ...'; echo ""; sleep 3
apt-get install php-pear
pear channel-discover pear.drush.org
pear install drush/drush
}
#}}}

_install_drupal()
{
#{{{
echo ""; echo 'starting to install drupal binary ...'; echo ""; sleep 3
cd /home
drush dl drupal
mv drupal* ${drupal_dir##/*/}
}
#}}}

_build_web()
{
#{{{
echo ""; echo "starting to install web $site_db"; echo ""; sleep 3
# 產生網站目錄
[ -d $drupal_dir/sites/$site_dir ] || rm -r $drupal_dir/sites/$site_dir
[ ! -d $drupal_dir/sites/$site_dir ] || mkdir -p $drupal_dir/sites/$site_dir

# 安裝網站
drush si standard \
	--sites-subdir=$site_dir \
	--db-url=mysql://$admin:$pass_db@localhost/$site_db \
	--account-name=$admin \
	--account-pass=$pass_web

# 設定網站相關目錄權限
[ -d $drupal_dir/sites/$site_dir/files ] || mkdir $drupal_dir/sites/$site_dir/files
[ -d $drupal_dir/sites/$site_dir/modules ] || mkdir $drupal_dir/sites/$site_dir/modules
[ -d $drupal_dir/sites/$site_dir/themes ] || mkdir $drupal_dir/sites/$site_dir/themes
chmod a+w $drupal_dir/sites/$site_dir/files
}
#}}}

_enable_site()
{
#{{{
echo ""; echo 'starting to enable virtual site ...'; echo ""; sleep 3
# 移除虛擬主機設定
if [[ -f /etc/apache2/sites-available/$site_url ]]; then
 rm /etc/apache2/sites-available/$site_url
 a2dissite $site_url
 service apache2 reload
fi

# 重新輸入虛擬主機設定
cat > "/etc/apache2/sites-available/$site_url" << HERE
<VirtualHost *:80> 
ServerAdmin engells@gmail.com
ServerName $site_url
ServerAlias www.$site_url
DocumentRoot "$drupal_dir"
	<Directory "$drupal_dir">
		AllowOverride All
		Order allow,deny
		Allow from All
	</Directory>
</VirtualHost>
HERE

# 啟用 apache2 虛擬主機
a2ensite $site_url
service apache2 reload

# 在 /etc/hosts 加入虛擬主機網址，各段資料以 tab 鍵隔開。$'\t' 代表 tab 鍵，『.』不需跳脫符號，此點與正則表示式不同
echo 127.0.0.1$'\t'$site_url$'\t'$'\t'www.$site_url >> /etc/hosts
}
#}}}

_enable_rewrite_allsites()
{
#{{{
echo ""; echo 'starting enable rewrite function ...' ; echo ""; sleep 3
a2dismod rewrite
# 備份 drupal 程式所提供的 .htaccess
cd $drupal_dir
cp .htaccess .htaccess.bak
mv .htaccess apache-rewrite.conf

# 將備份 drupal 程式所提供的 .htaccess 導入 apache2 的組態設定
cat >> /etc/apache2/conf.d/drupal.conf << HERE
<Directory $drupal_dir>
	Include $drupal_dir/apache-rewrite.conf
</Directory>
HERE
a2enmod rewrite
service apache2 restart
}
#}}}

_enable_rewrite_subsite()
{
#{{{
# 增加子網站之網址重寫機制，本函式必須在 _enable_rewrite_allsites 之後執行
echo ""; echo "starting to add rule of url rewrite for subsite ..."; echo ""; sleep 3
cd $drupal_dir
ln -s . $site_suffix

# 新增 rewrite rule，注意新增內容需放在原先之複寫規則之前
cat >> $drupal_dir/apache-rewrite.conf << HERE

  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_URI} ^/$site_suffix
  RewriteRule ^(.*)$ $site_suffix/index.php [L,QSA]

HERE
}
#}}}

_map_siteurl_dir()
{
#{{{
echo ""; echo "starting to map site url and site dir ..."; echo ""; sleep 3

# 新增 alies rule
[ -f $drupal_dir/sites/sites.php ] || cp $drupal_dir/sites/example.sites.php $drupal_dir/sites/sites.php
cat >> $drupal_dir/sites/sites.php << HERE
\$sites['$site_url'] = '$site_dir';
HERE
}
#}}}

drupal_dir="/home/kth"
admin="webadm"
pass_db="kt9833atmysql"
pass_web="kt9833atweb"

# 檢查及安裝 drush
if dpkg --get-selections | grep 'php-pear' ; then
  echo '' > /dev/null
else
  _install_drush
fi

# 檢查及安裝 drupal
[ -d $drupal_dir ] || _install_drupal


# 清除 apache2 有關 drupal 設定檔
cat /dev/null > /etc/apache2/conf.d/drupal.conf

# 安裝主網站及分站
cd $drupal_dir

for site in main acct kpt dev
do
	case $site in
	main)
		site_url="kth.idv"
		site_dir="kth"
		site_db="drup_kth"
		_build_web
		_enable_rewrite_allsites
		_map_siteurl_dir
		_enable_site ;;
	acct)
		site_url="kth.idv.akt"		# ref url is kth.idv/acct
		site_dir="akt"
		site_db="drup_akt"
		site_suffix="akt"
		_build_web
		_enable_rewrite_subsite
		_map_siteurl_dir ;;
	kpt)
		site_url="kth.idv.kpt"		# ref url is kth.idv/kpt
		site_dir="kpt"
		site_db="drup_kpt"
		site_suffix="kpt"
		_build_web
		_enable_rewrite_subsite
		_map_siteurl_dir ;;
	dev)
		site_url="proto.idv"
		site_dir="proto"
		site_db="drup_proto"
		_build_web
		_map_siteurl_dir
		_enable_site ;;
	*)
		echo "Nothing" > /dev/null ;;
	esac
done

# 安裝測試主站
echo ""; echo "starting to build the site of developing..."; echo ""; sleep 3
drupal_dir="/home/drupal"
[ -d $drupal_dir ] || _install_drupal
cd $drupal_dir
site_url="dev.idv"
site_dir="dev"
site_db="drup_dev"
_build_web
_enable_rewrite_allsites
_map_siteurl_dir
_enable_site

# unset variables
unset f; unset drupal_dir; unset admin; unset pass_db; unset pass_web
unset site; unset site_url; unset site_dir; unset site_db; unset site_suffix

# last configuration and restart apache2
vi /etc/hosts
vi $drupal_dir/apache-rewrite.conf
service apache2 restart

# manual checking
# /etc/apache2/sites-available, be sure only kth.idv, proto.idv and dev.idv exist.
# /etc/apache2/sites-enabled
# /etc/apache2/conf.d, be sure site directories of kth, and dev included in config.
# $drupal_dir/apache-rewrite.conf, the new rewrite rules musbe added up to default rules with higher priority.
# $drupal_dir/sites/sites.pho, be sure the diretories maping to the sites are correct.

