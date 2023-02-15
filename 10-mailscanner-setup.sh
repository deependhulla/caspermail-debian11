#!/bin/sh


wget https://github.com/MailScanner/v5/releases/download/5.4.5-3/MailScanner-5.4.5-3.noarch.deb -O /opt/MailScanner-5.4.5-3.noarch.deb
wget -c https://github.com/MailScanner/v5/releases/download/5.4.5-3/MailScanner-5.4.5-3.noarch.deb.sig -O /opt/MailScanner-5.4.5-3.noarch.deb.sig
#sh files/mailscanner-files/extra-perl-modules.sh

dpkg -i /opt/MailScanner-5.4.5-3.noarch.deb
/usr/sbin/ms-configure --MTA=postfix --installClamav=N --installCPAN=Y --ignoreDeps=N --ramdiskSize=0
##backup Message.pm as we are updating with Opentrack URL-Images
/bin/cp /usr/share/MailScanner/perl/MailScanner/Message.pm /usr/local/src/MailScanner-Orginal-Message-`date +%s`.pm 

## allow http://lists.mailscanner.info/pipermail/mailscanner/2012-February/099106.html
## 
## Edit the AppArmor profile
## /etc/apparmor.d/usr.sbin.clamd
## Add these 2 lines:
##  /var/spool/MailScanner/** rw,
##  /var/spool/MailScanner/incoming/** rw,
## Then, reload AppArmor /etc/init.d/apparmor reload
## Else Error : clam  : lstat() failed on: /var/spool/MailScanner/incoming/
/bin/cp -pRv files/mailscanner-files/usr.sbin.clamd /etc/apparmor.d/
systemctl restart apparmor.service 2>/dev/null 

sed -i "s/run_mailscanner=0/run_mailscanner=1/" /etc/MailScanner/defaults 
#/bin/cp -p files/mailscanner-files/header_checks /etc/postfix/header_checks

##/bin/cp -p files/mailscanner-files/clamd.conf /etc/clamav/

touch /etc/MailScanner/archives.filetype.rules.conf
touch /etc/MailScanner/archives.filename.rules.conf
touch /etc/MailScanner/filename.rules.conf
mkdir /var/spool/MailScanner/incoming 2>/dev/null
mkdir /var/spool/MailScanner/quarantine 2>/dev/null
mkdir /var/spool/MailScanner/incoming/Locks 2>/dev/null
chown postfix.postfix /var/spool/MailScanner/incoming
chown postfix.postfix /var/spool/MailScanner/quarantine
chown postfix:root /var/spool/postfix/

## for Update
#chown -R postfix:mtagroup /var/spool/MailScanner/milterin
#chown -R postfix:mtagroup /var/spool/MailScanner/milterout
#chown -R postfix:postfix /var/spool/MailScanner/quarantine
## Check version
#perl -MSendmail::PMilter -le 'print $Sendmail::PMilter::VERSION'

#/bin/cp -pRv files/mailscanner-files/ms-etc/* /etc/MailScanner/

## so that mailwatch can read
chmod 744 /var/spool/postfix/incoming/
chmod 744 /var/spool/postfix/hold/
chown -R postfix  /var/log/clamav 2>/dev/null
/bin/cp -pR files/mailscanner-rootdir/* /
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/"   /usr/share/MailScanner/perl/MailScanner/Message.pm

## Mail-Archive Tool
mkdir /archivedata
mkdir /archivedata/mail-archive-uncompress 2>/dev/null
mkdir /archivedata/mail-archive-compress 2>/dev/null
mkdir /archivedata/mail-archive-process 2>/dev/null
chmod 777 /archivedata
chmod 777 /archivedata/mail-archive-uncompress
chmod 777 /archivedata/mail-archive-compress
chmod 777 /archivedata/mail-archive-process

touch /var/log/clamav/clamav.log 2>/dev/null
chmod 666 /var/log/clamav/clamav.log 2>/dev/null

chmod 666 /var/spool/MailScanner/incoming/SpamAssassin.cache.db 1>/dev/null 2>/dev/null

sed -i "s/powermail\.mydomainname\.com/`hostname`/"   /etc/MailScanner/MailScanner.conf

echo "Resarting all service ...please wait..."
systemctl restart dovecot
systemctl restart opendkim
#systemctl restart clamav-daemon 2>/dev/null
#systemctl restart cron

##force one more time
chmod 666 /var/spool/MailScanner/incoming/SpamAssassin.cache.db 2>/dev/null 1>/dev/null

## For Updating All Perl Extra Module to Latest Version
/usr/sbin/ms-configure --update

systemctl enable postfix
systemctl restart postfix
systemctl enable mailscanner
systemctl restart mailscanner
systemctl enable msmilter
systemctl restart msmilter

echo "Done."
