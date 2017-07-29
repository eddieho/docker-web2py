#!/bin/bash

echo sudo docker run --name mysql_test01 -p 3306:3306 -v `pwd`/mysql_conf/mysql.conf.d:/etc/mysql/mysql.conf.d -e MYSQL_ROOT_PASSWORD=Welcome1 -d mysql_one
sudo docker run --name mysql_test01 -p 3306:3306 -v `pwd`/mysql_conf/mysql.conf.d:/etc/mysql/mysql.conf.d -e MYSQL_ROOT_PASSWORD=Welcome1 -d mysql_one


