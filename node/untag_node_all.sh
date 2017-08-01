#!/bin/bash 

set -x # echo on
docker node update --label-rm web2py.tier.web `hostname`
docker node update --label-rm web2py.tier.app `hostname`
docker node update --label-rm web2py.tier.db `hostname`
