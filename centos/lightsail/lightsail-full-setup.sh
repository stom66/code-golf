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

# ===== end settings


printf "Starting CentOS 7 setup script v1"


# === Run YUM update
printf "Updating from Yum...\n"
sudo yum update -y


# === install dependencies
printf "Finshed updating. Now installing additional dependencies...\n"
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
sudo yum install -y epel-release gcc gcc-c++ gem git lm_sensors make nano ncdu nodejs perl perl-Authen-PAMperl-CPAN ruby-devel rubygems scl-utils screen util-linux wget yum-utils zip https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm http://rpms.remirepo.net/enterprise/remi-release-7.rpm


# === YUM clean
printf "Finshed dependencies. Cleaning yum\n"
sudo yum clean all -q


# === Add public key to authorized_keys
if [ -z "$PUBKEY" ];
then
printf "Skipping pubkey\n"
else
# add ssh keys for stom
printf "Adding pubkey to authorized_keys\n"
sudo mkdir /home/centos/.ssh
sudo chmod 700 /home/centos/.ssh 
sudo touch /home/centos/.ssh/authorized_keys
sudo chmod 600 /home/centos/.ssh/authorized_keys
sudo echo $PUBKEY >> /home/centos/.ssh/authorized_keys
sudo chown -R centos:centos /home/centos/.ssh
fi

#
# setup motd 

printf "Adding systeminfo to motd\n"
sh motd.sh
echo "Installed MotD" >> ./setup-script.log


#=== setup remi php 7.4
sh php-remi.sh
echo "Installed PHP:" >> ./setup-script.log
php -v >> ./setup-script.log

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
sudo hostnamectl set-hostname --static $HOSTNAME
echo "prepend domain-name-servers 127.0.0.1;" | sudo tee -a /etc/dhcp/dhclient.conf
printf "done\n"

# Virtualmin installer
printf "Fetching Virtualmin installer.\n"
wget -O ~/virtualmin-installer.sh http://software.virtualmin.com/gpl/scripts/install.sh
chmod +x ~/virtualmin-installer.sh
printf "Setup complete. Run the virtualmin installer: sudo ./virtualmin-installer.sh\n"

printf "Setup complete!\n"
printf "The dependenices have been installed, the system is up to date.\n"
printf "Now run the virtualmin installer\n\n       sudo ./virtualmin-installer.sh\n"


