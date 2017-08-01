#!/bin/bash 

MYDIR=`dirname $0`
. $MYDIR/../env_for_cluster.sh 

set -x
curl -X GET http://`hostname`:${REGISTRY_PUBLISHED_PORT}/v2/_catalog

