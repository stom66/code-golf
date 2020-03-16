#!/bin/bash

# This script is designed to be run as sudo on a fresh installation of CentOS 7 
# running on the AWS Lightsail platform.
#
# It will install all required dependencies for a typical webdev server, including 
# Virtualmin, a LAMP stack, nodejs, and various utilities.
#
# It will also change various config file settings and add the key provided to
# the authorised_keys file for the default centos account.


# ====== settings 
HOSTNAME="ls2.tom2.co.uk"
PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEflkUUVLscb4jtD23/WQe0qMwE0cEVvtoO5A8dUz8l7"
# Note, this is my own key. You probably want to change this.

PACKAGES="screen wget nano epel-release gcc gcc-c++ gem git lm_sensors make ncdu nodejs perl perl-Authen-PAM perl-CPAN ruby-devel rubygems scl-utils util-linux yum-utils zip"

# ===== end settings


#==begin install
printf "Starting CentOS 7 setup script v2"

touch ./setup-script.log
TIME_START=$(date +"%T")
echo "Install started at: $TIME_START" >> ./setup-script.log

#===basic reqs
yum install screen wget nano -y -q


# === Run YUM update
yum update -y

# === install dependencies
printf "Finshed updating. Now installing additional dependencies...\n"
yum install -y $PACKAGES 

echo "Installed and updated yum packages" >> ./setup-script.log

#=== setup remi php 7.4
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php74
yum update -y

yum install -y php74 php74-php php74-php-bcmath php74-php-cli php74-php-common php74-php-curl php74-php-devel php74-php-fpm php74-php-gd php74-php-gmp php74-php-intl php74-php-json php74-php-mbstring php74-php-mcrypt php74-php-mysqlnd php74-php-opcache php74-php-pdo php74-php-pear php74-php-pecl-apcu php74-php-pecl-geoip php74-php-pecl-imagick php74-php-pecl-json-post php74-php-pecl-memcache php74-php-pecl-xmldiff php74-php-pecl-zip php74-php-process php74-php-pspell php74-php-simplexml php74-php-soap php74-php-tidy php74-php-xml php74-php-xmlrpc
ln -s /usr/bin/php74 /usr/bin/php


echo "Installed PHP:" >> ./setup-script.log
php -v >> ./setup-script.log

#=== motd stuff
sed -i '/^#.*PrintMotd/s/^#//' /etc/ssh/sshd_config
sed -i '/^PrintMotd/s/yes/no/' /etc/ssh/sshd_config
systemctl restart sshd
wget -O /etc/profile.d/sysinfo.motd.sh https://raw.githubusercontent.com/stom66/code-golf/master/bash/motd/sysinfo.motd.sh
chmod +x /etc/profile.d/sysinfo.motd.sh



# Network and hostname settings
printf "Setting up network\n"
printf "Enter the FQDN for the server: "
if [ -z "$HOSTNAME" ];
then
	read -r HOSTNAME
fi
hostnamectl set-hostname --static $HOSTNAME
echo "prepend domain-name-servers 127.0.0.1;" | tee -a /etc/dhcp/dhclient.conf
printf "done\n"


#=== fin

TIME_END=$(date +"%T")
echo "Install finished at: $TIME_END" >> ./setup-script.log



#=== trigger virtualmin
wget -O ~/virtualmin-installer.sh http://software.virtualmin.com/gpl/scripts/install.sh
chmod +x ~/virtualmin-installer.sh