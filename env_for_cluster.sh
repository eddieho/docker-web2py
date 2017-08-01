#
# environment variables for deploying web2py to a multi-node Docker Swarm cluster
#
# registry 
export REGISTRY_NAME=registry
export REGISTRY_HOSTNAME=ubuntu-docker01
export REGISTRY_PUBLISHED_PORT=5000
export REGISTRY_CONTAINER_PORT=5000

# web2py - apache2
export APACHE2_CONF_DIR=$HOME/web2py/apache2/conf
export APACHE2_HTDOCS_DIR=$HOME/web2py/apache2/htdocs

# web2py - MySQL 
export MYSQL_CONF_DIR=$HOME/web2py/mysql5/mysql_cnf/mysql.conf.d
export MYSQL_DATA_DIR=$HOME/web2py/mysql5/datadir
export MYSQL_INIT_DIR=$HOME/web2py/mysql5/init
