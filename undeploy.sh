#!/bin/bash

set -x # echo on

# need to initialise a data directory for MySQL if not exists

docker stack rm web2py
