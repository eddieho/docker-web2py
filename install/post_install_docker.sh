#!/bin/bash

set -x # echo on

# minimum customisation needed to run docker

sudo groupadd docker

# $USER should be set by bash to have login user
sudo usermod -aG docker $USER

# configure Docker to start on boot
sudo systemctl enable docker

set +x # echo off

echo 
echo Please logout from the shell and then login again before you run docker or docker-compose.
echo Otherwise, the changes by usermod is not refreshed.
echo After login, please run Linux command "groups" to see if your login has a group "docker"
