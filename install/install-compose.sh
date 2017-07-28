#!/bin/bash

COMPOSE_VERSION=1.15.0
curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m`  > /tmp/docker-compose

sudo mv /tmp/docker-compose /usr/local/bin 
