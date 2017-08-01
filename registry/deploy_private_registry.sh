#!/bin/bash 

MYDIR=`dirname $0`
. $MYDIR/../env_for_cluster.sh 

echo "docker service create --name ${REGISTRY_NAME} --publish ${REGISTRY_PUBLISHED_PORT}:${REGISTRY_CONTAINER_PORT} registry:2"
docker service create --name ${REGISTRY_NAME} --publish ${REGISTRY_PUBLISHED_PORT}:${REGISTRY_CONTAINER_PORT} registry:2

echo "docker service ls"
docker service ls

echo "please wait until registry has been deployed. i.e. 1/1 before pushing images"
