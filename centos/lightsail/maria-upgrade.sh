#!/bin/sh

cp ./maria10-4.repo /etc/yum.repos.d/
yum -y upgrade maria*
systemctl restart mariadb