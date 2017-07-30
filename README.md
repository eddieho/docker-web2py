# docker-web2py
building a docker based web2py environment

The build will be based on the following Docker components:
- docker community edition
- docker compose
- docker swarm

The web2py environment will consist of 3 docker services:
1. Apache web server v2.4.x - base image is httpd:2.4 from https://hub.docker.com/_/httpd/ 
1. web2py - base image is python:2.7 from https://hub.docker.com/_/python/
1. MySQL community edition v5.7.x - base image is mysql:5.7 from https://hub.docker.com/_/mysql/

Initially, MySQL will be a single node only but Apache and MySQL can be scaled through multiple instances on multiple Docker nodes.

**Latest Status**
* A single docker compose has been created to run 3 containers of Apache v2.4.x, Python v2.7.x and MySQL v5.7.x
* MySQL
  * configuration directory and data directory have been externalised
  * database initialisation script is supported (i.e. only runs when database does not exist) and can be further customised 
* Apache
  * config and document directories have been externalised
  * does not have SSL support
* web2py has not been installed but pymysql on python 2.7 has been verified to connect into MySQL in container successfully.
* All three containers can talk to each other. 
* Docker CE and Compose installation scripts have been verified in new Ubutun 16.x vm's. 

**Next Steps**
* deploy to a single swarm node.
* deploy to a cluster of 3 swarm manager nodes.
