#
# environment variables for deploying web2py to a single-node Docker Swarm cluster
#
# web2py - apache2
export APACHE2_CONF_DIR=./apache2/conf
export APACHE2_HTDOCS_DIR=./apache2/htdocs

# web2py - MySQL 
export MYSQL_CONF_DIR=./mysql5/mysql_cnf/mysql.conf.d
export MYSQL_DATA_DIR=./mysql5/datadir
export MYSQL_INIT_DIR=./mysql5/init

