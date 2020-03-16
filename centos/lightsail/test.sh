
#!/bin/sh

print_vars() {
	printf "|| FQDN:          ${DOMAIN} \n"
	printf "|| Public key:    ${PUBKEY} \n"
	printf "|| \n"
}

while [ $# -gt 0 ]; do
	key="$1"
	case $key in
		-h|--help)
			echo "CentOS Amazon LightSail Virtualmin Installer (CALVIn)"
			echo " "
			echo "This script will configure a CentOS 7 Amazon Lightsail instance to provide"
			echo "a typical webhosting framework. It will install the following major features and "
			echo "their required dependencies"
			echo "	* Virtualmin - apache, mysql, postfix, dovecot, etc"
			echo "	* NodeJS 12.x "
			echo "	* PHP 7.2 (via Virtualmin) and 7.4 (via Remi) "
			echo "	* PHP 7.2 (via Virtualmin) and 7.4 (via Remi) "

			echo "options:"
			echo "-h, --help                show brief help"
			echo "-d, --domain domain.tld   specify an FQDN to use as the system hostname"
			echo "-k, --pubkey PUBKEY      specify an public key to be added to the authorized_keys file"
			exit 0
			;;
		-d|--domain)
			DOMAIN="$2"
			shift
			shift
			;;
		-k|--pubkey)
			PUBKEY="$2"
			shift
			shift
			;;
		*)
			break
			;;
	esac
done


printf "|| Starting CALVIn. Checking config \n"
printf "|| ================================ \n"

# check we have a domain to use for configuration
if [ -z "$DOMAIN" ]; then
	printf "Enter a valid FQDN (example.com):"
	read -r DOMAIN
fi
if [ -z "$DOMAIN" ]; then
	printf "You must specify a FQDN. Script is exiting.\n\n"
	exit 0
fi


#check if we're using a pubkey
if [ -z "$PUBKEY" ]; then
	printf "Enter an optional public key to install (skip):"
	read -r PUBKEY
fi

printf "$(print_vars)"


##
## Start install
##
touch ./calvin.log
TIME_START=$(date +"%T")
echo "Install started at: $TIME_START" >> ./calvin.log
echo "   Using FQDN:      $DOMAIN" >> ./calvin.log
echo "   Using pubkey:    $PUBKEY" >> ./calvin.log

# Add pubkey
if [ ! -z "$PUBKEY" ]; then
./05-add-public-key.sh -k "${PUBKEY}"
echo "Added pubkey to authorized_keys: ${PUBKEY}" >> ./calvin.log
fi

# Trigger yum updates and dependecy installs
./10-hostname-setup.sh "${HOSTNAME}"
echo "Configured system to use hostname: ${HOSTNAME}" >> ./calvin.log

# Trigger yum updates and dependecy installs
./20-yum-update-and-install-dependencies.sh
echo "Yum installed and updated" >> ./calvin.log



# Add SysInfo MOTD
./40-add-motd-system-info.sh
echo "Added sysinfo motd" >> ./calvin.log


# setup remi php 7.4
./50-php-add-remi.sh
echo "Installed Remi PHP 7.4:" >> ./calvin.log
php -v >> ./calvin.log

#setup node 12.x
./55-node-js-12.sh
echo "Installed NodeJS 12.x:" >> ./calvin.log
node -v >> calvin.log

# fetch virtualmin
./66-virtualmin-installer.sh "${DOMAIN}"