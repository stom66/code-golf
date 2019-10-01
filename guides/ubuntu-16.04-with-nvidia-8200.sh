#!/bin/bash

# commands to configure ubuntu 16.04 with nvidia graphics drivers suitable for an nvidia 8200m

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-340
sudo nvidia-xconfig