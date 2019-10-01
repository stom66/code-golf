# A very rough guide to setting up Streama on CentOS with Virtualmin cpanel

**Rough outline of steps:**

1) Install CentOS 7.5
2) Update and install required dependencies
3) Install Virtualmin console to allow (some) management tasks and easy domain management
4) Install streama and setup proxy

## Setting up the OS and Dependencies

Create new machine with CentOS 7.5
Log in via SSH
Update centos first and install the various dependencies:

```
sudo yum update -y
sudo yum install -q -y epel-release gcc gem git java-1.8.0-openjdk-devel lm_sensors nano ncdu nodejs perl perl-CPAN scl-utils ruby-devel rubygems screen wget yum-utils zip https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum clean all -q
sudo yum-config-manager --enable remi-php56 -q
sudo yum update -q -y
sudo yum install -y -q php72 php72-php php72-php-bcmath php72-php-cli php72-php-common php72-php-curl php72-php-devel php72-php-fpm php72-php-gd php72-php-gmp php72-php-intl php72-php-json php72-php-mbstring php72-php-mcrypt php72-php-mysqlnd php72-php-opcache php72-php-pdo php72-php-pear php72-php-pecl-apcu php72-php-pecl-geoip php72-php-pecl-imagick php72-php-pecl-json-post php72-php-pecl-memcache php72-php-pecl-xmldiff php72-php-pecl-zip php72-php-process php72-php-pspell php72-php-simplexml php72-php-soap php72-php-tidy php72-php-xml php72-php-xmlrpc
echo "prepend domain-name-servers 127.0.0.1;" | sudo tee -a /etc/dhcp/dhclient.conf
```

Done. We've installed a whole bunch of dependencies and now we're ready to install the Virtualmin console.

## Setting up Virtualmin console

Run the following commands to fetch, chmod and run the Virtualmin installer. Follow the prompts it gives you.

```
wget -O ~/virtualmin-installer.sh http://software.virtualmin.com/gpl/scripts/install.sh
chmod +x ~/virtualmin-installer.sh
sudo ~/.virtualmin-installer.sh
```

Once it has installed go to the url specified by the installer. Note https and port 10000

Log in with the username root and the root password. You can change the root password by running the following command via SSH:

`sudo /usr/libexec/webmin/changepass.pl /etc/webmin root mypassword123`

Complete the Virtualmin setup steps in the guide. I recomend enabling the MySQL database as you may want it later and it's easier to set it up now.

Now we should have a working virtualmin install. Test it by going to your fqdn (regular port 80). You should see a response in your browser that reports you are not able to view this directory. This is a good sign, it means Apache is responding on the domain. Onwards.

## Installing streama

We're going to setup another account for streama and we do most of it via the virtualmin panel.

Under Virtualmin, make a new virtual website for your domain. This can also be a subdomain or another domain name you have pointing at the server. Whatever, it just needs to actually resolve through DNS.

Give the account the custom username `streama` and a decent, secure password. This will be the account we do most of our work through. When you're creating the site make sure the following features are enabled:

 * Setup DNS Zones
 * Setup website for domain
 * Setup SSL website too
 * Create MySQL database

You don't really need to accept mail or setup virus/webalizer/spam/dav. We won't be using that.

When you've created the site in virtualmin go back to the SSH console and do:

`su streama`

You'll need to enter the password we set for the account. When you're logged in, run the following to download a copy of streama:

```
mkdir ~/streama
wget https://github.com/streamaserver/streama/releases/download/v1.7.2/streama-1.7.2.jar
chmod +x ~/streama/streama-1.7.2.jar
```

To launch streama, type the following:

`screen -S streama ~/streama/streama-1.7.2.jar`

Once you see the console output `Grails application running at http://localhost:8080 in environment: production` then it is running. 

You can now disconnect form this screen by pressing `CTRL + A` then `CTRL + D`. 

To resume the screen you can run `screen -r streama` to reconnect to the streama screen.

Now head back to your Virtualmin Console and go to Virtualmin -> Server Configuration -> SSL certificate -> Lets encrypt
Choose "Request certificate" and wait for it to return. If it fails try again with just the domain (minus the www.). If it succeeds go back to the Current Cert tab and Hit all the buttons for "copy to" (assuming this is the default domain for the server, eg no subdomains)
Go to Virtualmin -> Server Configuration -> Edit Proxy Website
Set "Proxy enabled" to "Yes"
Set the Proxy URL to "http://localhost:8080/"
Save and apply
Test streama is working by visiting the domain and logging in with the default details.

If it is, then success. You can start uploading movies to the server. You're much better using the server as a seedbox though and downloading torrents to it.







