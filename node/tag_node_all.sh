#!/bin/bash 

set -x # echo on
docker node update --label-add web2py.tier.web=true `hostname`
docker node update --label-add web2py.tier.app=true `hostname`
docker node update --label-add web2py.tier.db=true `hostname`
