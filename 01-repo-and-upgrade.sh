#!/bin/bash


## set to India IST timezone -- You can dissable it if needed
timedatectl set-timezone 'Asia/Kolkata'
systemctl restart rsyslog 


##disable ipv6 as most time not required
## also while installation at time ipv6 is not ready at your setup
sysctl -w net.ipv6.conf.all.disable_ipv6=1 1>/dev/null
sysctl -w net.ipv6.conf.default.disable_ipv6=1 1>/dev/null

## backup existing repo by copy just for safety
/bin/cp -pR /etc/apt/sources.list /usr/local/src/old-sources.list-`date +%s`
echo "" >  /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list


apt-get update
apt-get -y upgrade
## few tools need for basic mangement
apt-get -y install vim curl git software-properties-common dirmngr screen mc apt-transport-https lsb-release ca-certificates openssh-server iptraf-ng telnet iputils-ping debconf-utils pwgen xfsprogs iftop htop multitail net-tools elinks wget pssh 



##### configure proper timezone
#dpkg-reconfigure tzdata
##### configure locale proper
#dpkg-reconfigure locales
## set India IST time.
#/bin/rm -rf /etc/localtime
#/bin/ln -vs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
#### for adding firmware realtek driver
#apt-get install firmware-linux-nonfree
#apt-get install firmware-realtek
#update-initramfs -u
## only if VM notfor LXC
## for proxmox/kvm better preformance
#apt-get -y install qemu-guest-agent
## if on Consle need Mouse to use for copy paste use gpm
#apt-get install gpm
#google dns: [2001:4860:4860::8888]
#cloudflare dns: [2606:4700:4700::1111]


hostname -f
ping `hostname -f` -c 2


