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

ln -s $MYDIR/../apache2 $HOME/web2py/apache2
ln -s $MYDIR/../mysql5 $HOME/web2py/mysql5

