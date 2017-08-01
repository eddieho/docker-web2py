#!/bin/bash

set -x # echo on

. ./env_for_cluster.sh

docker stack deploy --compose-file docker_compose_cluster.yml web2py

echo "check service status"
docker service ls
