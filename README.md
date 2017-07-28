# docker-web2py
building a docker based web2py environment

The build will be based on the following Docker components:
- docker community edition
- docker compose
- docker swarm

The web2py environment will consist of 3 images:
- web2py on Python v2.7.x
- Apache web server v2.4.x
- MySQL community edition v5.7.x

Initially, MySQL will be a single node only but Apache and MySQL can be scaled through multiple instances on multiple Docker nodes.
