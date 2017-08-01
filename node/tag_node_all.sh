#!/bin/bash 

if [ $# -gt 1 ]
then
  echo "usage $0 docker_node_name/host_name"
  exit -1
fi

if [ $# -eq 0 ]
then
  NODE_NAME=`hostname`
else
  NODE_NAME=$1
fi

set -x # echo on
docker node update --label-add web2py.tier.web=true $NODE_NAME
docker node update --label-add web2py.tier.app=true $NODE_NAME
docker node update --label-add web2py.tier.db=true $NODE_NAME
