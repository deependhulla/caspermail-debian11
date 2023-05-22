#!/bin/bash
## Also set time for India : Asia/Kolkata

echo "Setting rc.local, perl, bash, vim basic default config and IST time sync NTP"
#export LANGUAGE=en_US.UTF-8
#export LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
#locale-gen en_US.UTF-8
#dpkg-reconfigure locales

#build rc.local as it not there by default useful at times.
## copy if there by chance
/bin/cp -pR /etc/rc.local /usr/local/src/old-rc.local-`date +%s` 2>/dev/null
## create with default IPV6 disabled 
touch /etc/rc.local 
printf '%s\n' '#!/bin/bash'  | tee -a /etc/rc.local 1>/dev/null
echo "#sysctl -w net.ipv6.conf.all.disable_ipv6=1" >>/etc/rc.local
echo "#sysctl -w net.ipv6.conf.default.disable_ipv6=1" >> /etc/rc.local
echo "sysctl vm.swappiness=0" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod 755 /etc/rc.local
## need like autoexe bat on startup
echo "[Unit]" > /etc/systemd/system/rc-local.service
echo " Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
echo " ConditionPathExists=/etc/rc.local" >> /etc/systemd/system/rc-local.service
echo "" >> /etc/systemd/system/rc-local.service
echo "[Service]" >> /etc/systemd/system/rc-local.service
echo " Type=forking" >> /etc/systemd/system/rc-local.service
echo " ExecStart=/etc/rc.local start" >> /etc/systemd/system/rc-local.service
echo " TimeoutSec=0" >> /etc/systemd/system/rc-local.service
echo " StandardOutput=tty" >> /etc/systemd/system/rc-local.service
echo " RemainAfterExit=yes" >> /etc/systemd/system/rc-local.service
## featured Removed
###echo " SysVStartPriority=99" >> /etc/systemd/system/rc-local.service
echo "" >> /etc/systemd/system/rc-local.service
echo "[Install]" >> /etc/systemd/system/rc-local.service
echo " WantedBy=multi-user.target" >> /etc/systemd/system/rc-local.service

systemctl enable rc-local
systemctl start rc-local

## make cpan auto yes for pre-requist modules of perl
(echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan 1>/dev/null

#Disable vim automatic visual mode using mouse
echo "\"set mouse=a/g" >  ~/.vimrc
echo "syntax on" >> ~/.vimrc
##  for  other new users
echo "\"set mouse=a/g" >  /etc/skel/.vimrc
echo "syntax on" >> /etc/skel/.vimrc

## centos 7 like bash ..for all inteactive 
echo "" >> /etc/bash.bashrc
echo "alias cp='cp -i'" >> /etc/bash.bashrc
echo "alias l.='ls -d .* --color=auto'" >> /etc/bash.bashrc
echo "alias ll='ls -l --color=auto'" >> /etc/bash.bashrc
echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
echo "alias mv='mv -i'" >> /etc/bash.bashrc
echo "alias rm='rm -i'" >> /etc/bash.bashrc
echo "export EDITOR=vi" >> /etc/bash.bashrc

## for using crontab via vi editor
export EDITOR=vi

#Load bashrc
#bash
#source /etc/bash.bashrc


CFG_HOSTNAME_FQDN=`hostname -f`
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string $CFG_HOSTNAME_FQDN" | debconf-set-selections
echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections
echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections

## postfix for basic use as default MTA and install build tool for any complication 
## iptables is still usefull and other addon tools 
## build-essential ...at time needed for any code make..or kernel driver...you can skip it if needed
## command line sendEmail for testing and report sending
apt-get -y install postfix iptables-persistent libimage-exiftool-perl build-essential gnupg2 zip rar unrar ftp poppler-utils tnef sudo whois libauthen-pam-perl libio-pty-perl libnet-ssleay-perl perl-openssl-defaults sendemail rsync mariadb-server php apache2 libapache2-mod-php php-mysql php-cli php-common php-imap php-ldap php-xml php-curl php-mbstring php-zip php-apcu php-gd php-imagick imagemagick mcrypt memcached php-memcached php-bcmath dbconfig-common libapache2-mod-php php-intl php-mysql php-intl libdbd-mysql-perl certbot python3-certbot-apache automysqlbackup php-mailparse perl-doc mysqltuner catdoc unzip tar imagemagick tesseract-ocr tesseract-ocr-eng poppler-utils exiv2 libnet-dns-perl libmailtools-perl php-mail-mime 
## to use more advance database storage type
# apt-get install mariadb-plugin-rocksdb

a2enmod actions > /dev/null 2>&1
a2enmod proxy_fcgi > /dev/null 2>&1
a2enmod fcgid > /dev/null 2>&1
a2enmod alias > /dev/null 2>&1
a2enmod suexec > /dev/null 2>&1
a2enmod rewrite > /dev/null 2>&1
a2enmod ssl > /dev/null 2>&1
a2enmod actions > /dev/null 2>&1
a2enmod include > /dev/null 2>&1
a2enmod dav_fs > /dev/null 2>&1
a2enmod dav > /dev/null 2>&1
a2enmod auth_digest > /dev/null 2>&1
a2enmod cgi > /dev/null 2>&1
a2enmod headers > /dev/null 2>&1
a2enmod proxy_http > /dev/null 2>&1

systemctl stop apache2
## usefull for nginx imap & smtp proxy  --also with php-fpm
apt-get -y install nginx-full php-fpm php-pear
systemctl stop php7.4-fpm.service > /dev/null 2>&1
systemctl disable php7.4-fpm.service > /dev/null 2>&1
## keep fpm disabled default -- useful for very high load web-server
systemctl stop php.fpm  > /dev/null 2>&1
systemctl disable php-fpm > /dev/null 2>&1
#To enable PHP 7.4 FPM in Apache2 do:
#a2enmod proxy_fcgi setenvif
#a2enconf php7.4-fpm

## download latest MyslqTunner--useful when perforance tuning needed
#https://github.com/major/MySQLTuner-perl/blob/master/INTERNALS.md
cd /opt
git clone https://github.com/major/MySQLTuner-perl.git
cd -

### changing timezone to Asia Kolkata
sed -i "s/;date.timezone =/date\.timezone \= \'Asia\/Kolkata\'/" /etc/php/7.4/apache2/php.ini
sed -i "s/;date.timezone =/date\.timezone \= \'Asia\/Kolkata\'/" /etc/php/7.4/cli/php.ini
sed -i "s/;date.timezone =/date\.timezone \= \'Asia\/Kolkata\'/" /etc/php/7.4/fpm/php.ini
##disable error
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ERROR/" /etc/php/7.4/cli/php.ini
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ERROR/" /etc/php/7.4/fpm/php.ini
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ERROR/" /etc/php/7.4/apache2/php.ini



sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.4/apache2/php.ini
sed -i "s/post_max_size = 100M/post_max_size = 100M/" /etc/php/7.4/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 50M/" /etc/php/7.4/apache2/php.ini

## install insstead of systemd-timesyncd for better time sync
apt-get install chrony -y 2>/dev/null 1>/dev/null
## -x option added to allow in LXC
echo 'DAEMON_OPTS="-F 1 -x "' >  /etc/default/chrony 
systemctl restart chrony 

/bin/cp -p files/extra-files/etc-config-backup.sh /bin/
/bin/cp -p files/extra-files/pfHandle /bin/

## safe backup
files/extra-files/etc-config-backup.sh

apt-get -y install unbound 1>/dev/null 2>/dev/null
## copy fw default settings 
/bin/cp -pR files/rootdir/* /
systemctl restart unbound 1>/dev/null 2>/dev/null
systemctl restart  rsyslog
systemctl stop nginx
systemctl restart  apache2
systemctl restart  cron
systemctl restart  mariadb



## for PHP composer package
#echo "installing php composer"
#cd /opt
#php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
#php composer-setup.php
#php -r "unlink('composer-setup.php');"
#cd -


echo " Please Logout and login again so that bashrc is reloaded for you"
