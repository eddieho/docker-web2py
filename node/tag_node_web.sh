#!/bin/bash 

set -x
docker node update --label-add web2py.tier.web=true `hostname`
