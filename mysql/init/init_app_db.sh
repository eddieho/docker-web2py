#!/bin/bash

# FIXME: Need to store password differently
export MYSQL_PWD=Welcome1

cd /docker-entrypoint-initdb.d

mysql -u root -v  < ./init_app_db.mysql
