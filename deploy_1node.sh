#!/bin/bash

set -x # echo on

# need to initialise a data directory for MySQL if not exists
mkdir -p mysql5/datadir

. ./env_for_1node.sh

docker stack deploy --compose-file docker_compose_1node.yml web2py

echo "check service status"
docker service ls
