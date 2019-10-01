#!/bin/bash

# This script is designed to be run on a fresh installation of CentOS 7 
# running on the AWS Lightsail platform.
#
# It will install all required dependencies for a typical webdev server, including 
# Virtualmin, a LAMP stack, nodejs, and various utilities.
#
# It will also change various config file settings and add the key provided to
# the authorised_keys file for the default centos account.


# ====== settings 
HOSTNAME=""
PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEflkUUVLscb4jtD23/WQe0qMwE0cEVvtoO5A8dUz8l7"

ADD_MOTD_SYSINFO=0



# ===== end settings


printf "Starting CentOS 7 setup script v1"

printf "Updating from Yum...\n"
sudo yum update -y
printf "Finshed updating. Now installing additional dependencies...\n"
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
sudo yum install -y epel-release gcc gcc-c++ gem git lm_sensors make nano ncdu nodejs perl perl-Authen-PAMperl-CPAN ruby-devel rubygems scl-utils screen util-linux wget yum-utils zip https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm http://rpms.remirepo.net/enterprise/remi-release-7.rpm

printf "Finshed dependencies. Cleaning yum\n"
sudo yum clean all -q

#

# add ssh keys for stom
printf "Adding pubkey to authorized_keys\n"
sudo mkdir /home/centos/.ssh
sudo chmod 700 /home/centos/.ssh 
sudo touch /home/centos/.ssh/authorized_keys
sudo chmod 600 /home/centos/.ssh/authorized_keys
# Note, this is my own key. You probably want to change this.
sudo echo PUBKEY >> ~/.ssh/authorized_keys
sudo chown -R centos:centos /home/centos/.ssh

#
# setup motd 
printf "Adding systeminfo to motd\n"
sudo sed -i "s/^\(PrintMotd\s* \s*\).*\$/\1no/" "/etc/ssh/sshd_config"
sudo systemctl restart sshd
sudo wget -O /etc/profile.d/login-info.sh https://raw.githubusercontent.com/stom66/code-golf/master/bash/motd-generator-simple-info.sh
sudo chmod +x /etc/profile.d/login-info.sh


# Remi PHP stuff
printf "Enabling Remi Repo for PHP 7.3 and upgrade from 5.6"
sudo yum-config-manager --enable remi-php73 -q
sudo yum update -y
printf "done\n"

printf "Enabling Remi Repo for PHP and installing 7.3... "
sudo yum install -y php73 php73-php php73-php-bcmath php73-php-cli php73-php-common php73-php-curl php73-php-devel php73-php-fpm php73-php-gd php73-php-gmp php73-php-intl php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pear php73-php-pecl-apcu php73-php-pecl-geoip php73-php-pecl-imagick php73-php-pecl-json-post php73-php-pecl-memcache php73-php-pecl-xmldiff php73-php-pecl-zip php73-php-process php73-php-pspell php73-php-simplexml php73-php-soap php73-php-tidy php73-php-xml php73-php-xmlrpc
printf "done\n"

# NPM/Gem stuff
printf "Installing LESS and SASS... "
sudo npm install -g less sass
printf "done\n"

# Network and hostname settings
printf "Setting up network\n"
printf "Enter the FQDN for the server: "
if [ -z "$HOSTNAME" ];
then
	read -r HOSTNAME
fi
sudo hostnamectl set-hostname --static HOSTNAME
echo "prepend domain-name-servers 127.0.0.1;" | sudo tee -a /etc/dhcp/dhclient.conf
printf "done\n"

# Virtualmin installer
printf "Fetching Virtualmin installer.\n"
wget -O ~/virtualmin-installer.sh http://software.virtualmin.com/gpl/scripts/install.sh
chmod +x ~/virtualmin-installer.sh
printf "Setup complete. Run the virtualmin installer: ./virtualmin-installer.sh\n"

sudo ~/.virtualmin-installer.sh

