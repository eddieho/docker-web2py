# docker-web2py
Purpose of this project is to build a set of Docker artefacts to support an application with these components:
1. web tier - Apache web server v2.4.x 
1. application tier - a Python 2.7 based framework from http://web2py.com/ 
1. database tier - MySQL v5.7.x

The docker application will support scaling up web and application tiers across multiple machines while the database tier is expected to be a single node at least initially. You may add additional components (e.g. a caching layer) to the docker once you are familiar with the docker application. This project has some pre-defined customisation points through externalising configuration and data directories such that you don't need to change project artefacts to meet your project needs. Of course, you may add your own extension points easily as well.

The project has been developed on an Ubuntu/Debian based Linux environment and has been verified on Ubuntu 16.x machines. All scripts and steps are based on the following 2 Docker components:
1. Docker Community Edition - v17.06.0
1. Docker Compose - v1.15.0

**warning**
Docker has been changed rapidly. Please do not try to run the project on versions below the verified vesions. In particular, some scripts depend on Docker Compose v1.15.0. For the same reason, please verify the scripts if you run them on a future version to avoid any surprise.

# Preparation of Machine(s)
The Docker application can run across multiple machines but you can start with one Linux machine and then extend it later. 
All Linux machines running this project will need an account capable of running priviledged commands via [sudo](https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-ubuntu-quickstart) unless you can run it directly on root (not recommended).

When the machine is ready, please clone this git project by
`git clone https://github.com/eddieho/docker-web2py.git` onto your Linux machine. 

# Installation of Docker
You can install docker and docker-compose manually by following their instructions at https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/ and https://docs.docker.com/compose/install/.

Alternatively, you can use the scripts in this project to prepare your first machine for Docker as follows:
1. Go to the top of the cloned project directory
1. `cd install`
1. `./install_docker_ce_and_compose.sh`
1. Verify the installation by checking the versions installed 
`docker --version` 
> Docker version 17.06.0-ce, build 02c1d87  # sample output
`docker-compose --version` 
> docker-compose version 1.15.0, build e12f3b9
1. Run `post_install_docker.sh` to configure your linux user to be in the 'docker' group. Then logout and login again to refresh the user's group membership. 

# New to Docker
If you are new to Docker, I suggest you follow these Docker tutorials before running this project:
1. [Docker getting started](https://docs.docker.com/get-started/)
1. [Docker Compose getting started](https://docs.docker.com/compose/gettingstarted/)

It will take an hour to complete each but it is well worth the efforts.

This project will use Docker stack which is a higher level construct than Docker compose but the concept is very similar. I would recommend learning Docker stack through the scripts in this project.

# Building Docker images
The project has the following dependencies to base images:

|Component|version|base image|image name|
|---|---|---|---|
|Apache web server|2.4.x|https://hub.docker.com/_/httpd/|web2py_apache2|
|Python (*)|2.7.x|https://hub.docker.com/_/python/|web2py_python27|
|MySQL|v5.7.x|https://hub.docker.com/_/mysql/|web2py_mysql5|

(*) - web2py is an application deployed to the Python environment.

You can build these images by the command
`docker-compose -f docker-compose-1node.yml build`

Once it is done, verify the image built by 
`docker image ls`
you should be able to see something similar to: 

REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE

**web2py_apache2**      latest              250b95c1bcab        5 seconds ago        243MB

**web2py_python27**     latest              d01517983952        About a minute ago   774MB

**web2py_mysql5**       latest              f2bf559fbb46        6 minutes ago        468MB

When these images are ready, you can work on deploying to a single-node Docker Swarm cluster. 

# Deploy to single node SWARM cluster
First step is to create a Docker Swarm by
`docker swarm init`
You will see an output like 
`Swarm initialized: ...
  docker swarm join --token SWMTKN-1-xxxx 192.168.xxx.yyy:2377`
 
The 'docker swarm join' will be used when new nodes are added to the cluster in a following section. 
 
Now let's deploy the application to this newly created Swarm cluster.
1. Go to top of the project directory
1. `./deploy_web2py_1node.sh` 
You will see output like:

Creating network web2py_default

Creating service web2py_mysql5

Creating service web2py_apache2

Creating service web2py_python27

You can check the deploy by 
`docker service ls`

Here is a sample output:

ID                  NAME                MODE                REPLICAS            IMAGE                    PORTS

60uag112d5dh        web2py_apache2      replicated          2/2                 web2py_apache2:latest    *:80->8080/tcp

elqmr6mrhxe4        web2py_python27     replicated          2/2                 web2py_python27:latest   *:8080->80/tcp

xnfhp6e0a7pw        web2py_mysql5       replicated          1/1                 web2py_mysql5:latest     *:3306->3306/tcp

When the deployment of image is completed, you will see the 2 numbers in column REPLICAS the same. You can check the status by re-running command `docker service ls` repeatedly.

If you want to access the command line of any docker container, you just need to get its ID and then run:
`docker exec -it 60uag112d5dh /bin/bash` 
60uag112d5dh is the ID of the container for web2py_apache2 in the sample output.

Now you have deployed the application successfully. If you are new to Docker, I suggest you to familiar yourself with the docker application before taking up the challenge of deploying into a multi-node swarm cluster. You may apply most of the concepts to a multi-node cluster but you will also deal with new challenges. 

# Deploy to multi-node SWARM cluster

When you scale from a single node to a multi-node swarm cluster, you will need to deal with at least 2 new challenges:
**How to distribute images on each node**
All the nodes need to access to the same set of images. When you run a single-node cluster, all the images are cached locally and the command `docker image ls` shows all the locally cached images. Running docker across nodes will require a registry such that every node can resolve to the same image easily. If your team has standardised on a public or private registry, then you can stick with that one. Otherwise, you will have 2 choices:
* public registry such as hub.docker.com - your machine needs to have very good upload speed to Internet because images are hundreds of MBs.
* private registry - you can build a private registry quickly for testing. When changes to images are stablised, you can switch to a public registry because trying to provide resilency of a registry is not a trivial task. 

In this document, I will cover how to deploy a private registry for testing the deployment quickly. 

**Where to deploy each component**
Some containers may need to access external resources where it is not appropriate to copy into the images. E.g. MySQL needs to have a persistent storage and it's not available on every node, all Apache containers need to access the same content directory and the directory may be changed dynamically. Hence you want to have the flexibility of deploying specific types of containers to certain nodes only. This project uses Docker compose constraint to work with Docker node label such as MySQL is only deployed to a node capable of supporting database directory. Specifically, the MySQL container is only deployed to a node with label "web2py.tier.db=true".

## Deploy a private registry

## Add new Docker node to Swarm cluster

# Misc notes

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
