#!/bin/sh


MYSQLPASSMAILW=`pwgen -c -1 8`
echo $MYSQLPASSMAILW > /usr/local/src/mysql-mailscanner-pass

echo "Creating Database mailscanner for storing all logs for mailwatch"
mysqladmin create mailscanner -uroot 1>/dev/null 2>/dev/null
mysql < files/mailscanner-files/MailWatch-1.2.18/create.sql 2>/dev/null
mysql -f < files/mailscanner-files/mailwatch-fix-for-subject-special-char-support.sql 2>/dev/null 
mysql -f < files/mailscanner-files/mailwatch-extra.sql 2>/dev/null 
echo "GRANT ALL PRIVILEGES ON mailscanner.* TO mailscanner@localhost IDENTIFIED BY '$MYSQLPASSMAILW'" | mysql -uroot
mysqladmin -uroot reload
mysqladmin -uroot refresh

MYSQLPASSMW=`pwgen -c -1 8`
echo $MYSQLPASSMW > /usr/local/src/mailwatch-admin-pass

echo "adding user mailwatch with password for gui access , password in /usr/local/src/mailwatch-admin-pass";
echo "DELETE FROM mailscanner.users WHERE \`username\` = 'mailwatch'" | mysql ;
echo "INSERT INTO \`mailscanner\`.\`users\` (\`username\`, \`password\`, \`fullname\`, \`type\`, \`quarantine_report\`, \`spamscore\`, \`highspamscore\`, \`noscan\`, \`quarantine_rcpt\`) VALUES ('mailwatch', MD5('$MYSQLPASSMW'), 'Mail Admin', 'A', '0', '0', '0', '0', NULL);"  | mysql;


touch /var/log/clamav/clamav.log 2>/dev/null
chmod 666 /var/log/clamav/clamav.log 2>/dev/null

/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/MailScanner_perl_scripts/*.pm /usr/share/MailScanner/perl/custom/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/tools/Cron_jobs/*.php /usr/local/bin/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/tools/Postfix_relay/*.php /usr/local/bin/
###/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/tools/Postfix_relay/mailwatch-postfix-relay /usr/local/bin/
##/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/tools/Postfix_relay/mailwatch-milter-relay /usr/local/bin/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/tools/Postfix_relay/mailwatch-milter-relay-tail-process.sh /usr/local/bin/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/tools/Cron_jobs/mailwatch /etc/cron.daily/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.18/mailscanner /var/www/html/
/bin/cp -pv files/mailscanner-files/conf.php /var/www/html/mailscanner/
chown -R www-data:www-data /var/www/html/mailscanner/
chmod 666 /var/spool/MailScanner/incoming/SpamAssassin.cache.db 1>/dev/null 2>/dev/null

sed -i "s/zaohm8ahC2/`cat /usr/local/src/mysql-mailscanner-pass`/" /var/www/html/mailscanner/conf.php
sed -i "s/zaohm8ahC2/`cat /usr/local/src/mysql-mailscanner-pass`/" /usr/share/MailScanner/perl/custom/MailWatchConf.pm
sed -i "s/zaohm8ahC2/`cat /usr/local/src/mysql-mailscanner-pass`/" /var/www/html/imagedata/index.php
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /var/www/html/mailscanner/conf.php
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/"   /etc/MailScanner/MailScanner.conf
sed -i "s/zaohm8ahC2/`cat /usr/local/src/mysql-mailscanner-pass`/" /var/www/html/mailscanner/detail.php
echo "Resarting mailscanner and msmilter service ...please wait..."
systemctl restart mailscanner msmilter.service 
##saferside chown
chmod 666 /var/spool/MailScanner/incoming/SpamAssassin.cache.db 2>/dev/null 1>/dev/null
mysql < files/mailscanner-files/add-auth-track.sql 
mysql < files/mailscanner-files/imageviewdata.sql 


echo "All Setup Done ,please reboot the Server once";
echo "Done."
