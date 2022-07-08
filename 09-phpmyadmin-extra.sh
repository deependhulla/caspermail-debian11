#!/bin/sh

## for Development of checking Database in details.

wget -c "https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-english.tar.gz" -O /tmp/phpMyAdmin-5.2.0-english.tar.gz
cd /tmp
tar -xvzf phpMyAdmin-5.2.0-english.tar.gz 
cd -
mv -v /tmp/phpMyAdmin-5.2.0-english /var/www/html/dbadminonweb

cp /var/www/html/dbadminonweb/config.sample.inc.php /var/www/html/dbadminonweb/config.inc.php

chown -R www-data:www-data /var/www/html/dbadminonweb

sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg\['blowfish_secret'\] = '`pwgen -c 32 1`';/" /var/www/html/dbadminonweb/config.inc.php

