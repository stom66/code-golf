# Code Golf

#### It should be noted that I have never played golf.

This repository serves as a dumping ground for miscellaneous nix scripts. The scripts are written with CentOS in mind unless specified otherwise.


### Contents:

* MOTD Info



### MOTD Info

A simple script to enable basic system info to be displayed on login. Run the following to grab the script from this repository and enable it.

	# Install the required dependencies
	sudo yum install -q -y util-linux

    # Update sshd_config to disable MOTD
    sudo sed -i "s/^\(PrintMotd\s* \s*\).*\$/\1no/" "/etc/sshd/sshd_config"

    # Restart ssh
    sudo systemctl restart sshd

    # Get the script that echos system info
    sudo wget -O /etc/profile.d/login-info.sh https://foo.com/ 

    # Make it executable
    sudo chmod +x /etc/profile.d/login-info.sh
    