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

docker node inspect $NODE_NAME |grep -A 5 Labels
