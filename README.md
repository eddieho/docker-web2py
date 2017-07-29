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
