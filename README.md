# Code Golf

#### It should be noted that I have never played golf.

This repository serves as a dumping ground for miscellaneous nix scripts. The scripts are written with CentOS in mind unless specified otherwise.


### Contents:

* motd



### MOTD SysInfo

A simple script to enable basic system info to be displayed on login. Run the following to make sure you have the dependencies, update `sshd_config`, grab the script from this repository and enable it.

```bash
sudo yum install util-linux -y
sudo sed -i "s/^\(PrintMotd\s* \s*\).*\$/\1no/" "/etc/ssh/sshd_config"
sudo systemctl restart sshd
sudo wget -O /etc/profile.d/sysinfo.motd.sh https://raw.githubusercontent.com/stom66/code-golf/master/bash/motd/sysinfo.motd.sh
sudo chmod +x /etc/profile.d/sysinfo.motd.sh
```

Optionally you can make your own changes to the information displayed by editing `/etc/profile.d/sysinfo.motd.sh`.



    