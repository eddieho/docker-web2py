#!/bin/bash

set -x # echo on

# Docker CE for Ubuntu installation is https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#os-requirements

#
# 1. Installing Docker CE
#
sudo apt-get update

sudo apt-get -y install \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

# this apt-get update is necessary for next apt-get to find docker-ce
sudo apt-get update

# for production, please run
# sudo apt-get install docker-ce=<VERSION>
# instead of getting the latest version

sudo apt-get install -y docker-ce

# verify docker is properly installed
sudo docker run hello-world


#
# 2. Installing Docker Compose
#
# Notes:
# Docker Compose is not part of Docker CE. Please find installation guide a://docs.docker.com/compose/install/
#  
# Please refer to https://github.com/docker/compose/blob/master/CHANGELOG.md for the latest version number or a version you want

COMPOSE_VERSION=1.15.0
curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m`  > /tmp/docker-compose

sudo mv /tmp/docker-compose /usr/local/bin
sudo chmod 0755 /usr/local/bin/docker-compose
sudo chown root:root /usr/local/bin/docker-compose
