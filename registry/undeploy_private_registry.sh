#!/bin/bash 

MYDIR=`dirname $0`
. $MYDIR/../env_for_cluster.sh 

set -x
docker service rm ${REGISTRY_NAME}
docker service ls

