#!/bin/bash

#
# prepare apache2 and mysql5 quickly to perform sanity check 
# it will create symbolic link from $HOME/web2py to directories in source directories
# you should modify the script env_for_cluster.sh or env_for_1node.sh to customise for your environment
#
set -x # echo on

MYDIR=`pwd`/`dirname $0`

echo $MYDIR

mkdir -p $HOME/web2py
mkdir -p $HOME/web2py/apache2
mkdir -p $HOME/web2py/mysql5

ln -s $MYDIR/../apache2/conf $HOME/web2py/apache2/conf
ln -s $MYDIR/../apache2/htdocs $HOME/web2py/apache2/htdocs

ln -s $MYDIR/../mysql5/mysql_cnf $HOME/web2py/mysql5/mysql_cnf
ln -s $MYDIR/../mysql5/init $HOME/web2py/mysql5/init
mkdir -p $HOME/web2py/mysql5/datadir
