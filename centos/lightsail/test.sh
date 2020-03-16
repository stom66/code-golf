
#!/bin/sh

printf "================== \n"
printf "== Script start == \n"
printf "================== \n"

while [ $# -gt 0 ]; do
	key="$1"
	case $key in
		-h|--help)
			echo "$package - attempt to capture frames"
			echo " "
			echo "$package [options] application [arguments]"
			echo " "
			echo "options:"
			echo "-h, --help                show brief help"
			echo "-d, --domain=domain.tld   specify an FQDN to use as the system hostname"
			echo "-k, --pubkey=PUBKEY      specify an public key to be added to the authorized_keys file"
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

# check we have a domain to use for configuration
if [ -z "$DOMAIN" ]; then
	printf "You must provide a valid FQDN. \n"
	printf "Enter an fqdn (example.com): "
	read -r DOMAIN
else
	printf "Using FQDN: ${DOMAIN} \n"
fi
if [ -z "$DOMAIN" ]; then
	printf "You have not entered a valid FQDN. Script is exiting."
	exit 0
fi


#check if we're using a pubkey
if [ -z "$PUBKEY" ]; then
	printf "You have not provided a public key for SSH authorisation. \n"
	printf "Enter your public key (skip): "
	read -r PUBKEY
else
	printf "Using public key ${PUBKEY}"
fi
if [ -z "$PUBKEY" ]; then
	printf "Skipping pubkey... \n"
fi


printf "Running test script with following parameters:\n"
printf "  Host:       ${DOMAIN} \n"
printf "  Public Key: ${PUBKEY} \n"
