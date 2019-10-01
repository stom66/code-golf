#!/bin/bash
# Simple function to use sed to update config file settings

function set_config(){
	echo "Updating ${1}, setting ${2} to ${3}"
    sudo sed -i "s/^\($2\s* \s*\).*\$/\1$3/" $1
}

file="/etc/sshd/sshd_config"
key="PrintMotd"
value="no"

set_config $file $key $value