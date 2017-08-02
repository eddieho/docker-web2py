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
* deployment to a single node warm works by using Docker Stack and a private registry https://docs.docker.com/engine/swarm/stack-deploy/#push-the-generated-image-to-the-registry. It's possible to use Docker hub for distribution of images but upload bandwidth is a big issue. Hence a private registry is deployed for testing. 
* deployed to 3-node cluster successfully with support of constraining MySQL container to selected nodes using a node label web2py.tier.db=true

**Next Steps**
* update this README.cmd
