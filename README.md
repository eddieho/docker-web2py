# Overview of docker-web2py
Purpose of this project is to build a set of Docker artefacts to support an application with these components:
1. web tier - Apache web server v2.4.x 
1. application tier - a Python 2.7 based framework from http://web2py.com/ 
1. database tier - MySQL v5.7.x

The docker application will support scaling up web and application tiers across multiple machines while the database tier is expected to be a single node at least initially. You may add additional components (e.g. a caching layer) to the docker once you are familiar with the docker application. This project has some pre-defined customisation points through externalising configuration and data directories such that you don't need to change project artefacts to meet your project needs. Of course, you may add your own extension points easily as well.

The project has been developed on an Ubuntu/Debian based Linux environment and has been verified on Ubuntu 16.x machines. All scripts and steps are based on the following 2 Docker components:
1. Docker Community Edition - v17.06.0
1. Docker Compose - v1.15.0

The rest of this README will cover how to deploy by various scripts and commands. Since the objective is to provide a framework rather than an actual project, the following items are not implemented here but leave it for actual projects to fill in the details:
1. Apache
* SSL configuration
* module installation
* log file collection
1. Python 
* web2py installation
* application configuration 
1. MySQL
* backup/recovery
* network directory to support persistent data

**warning**
Docker has been changing rapidly. Please do not try to run the project on versions below the verified vesions. In particular, some scripts depend on Docker Compose v1.15.0. For the same reason, please verify the scripts if you run them on a future version to avoid any surprise.

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

`Creating network web2py_default

Creating service web2py_mysql5

Creating service web2py_apache2

Creating service web2py_python27`

You can check the deploy by 
`docker service ls`

Here is a sample output:

`ID                  NAME                MODE                REPLICAS            IMAGE                    PORTS

60uag112d5dh        web2py_apache2      replicated          2/2                 web2py_apache2:latest    *:80->8080/tcp

elqmr6mrhxe4        web2py_python27     replicated          2/2                 web2py_python27:latest   *:8080->80/tcp

xnfhp6e0a7pw        web2py_mysql5       replicated          1/1                 web2py_mysql5:latest     *:3306->3306/tcp`

When the deployment of image is completed, you will see the 2 numbers in column REPLICAS the same. You can check the status by re-running command `docker service ls` repeatedly.

If you want to access the command line of any docker container, you just need to get its ID and then run:
`docker exec -it 60uag112d5dh /bin/bash` 
60uag112d5dh is the ID of the container for web2py_apache2 in the sample output.

Now you have deployed the application successfully. If you are new to Docker, I suggest you to familiar yourself with the docker application before taking up the challenge of deploying into a multi-node swarm cluster. You may apply most of the concepts to a multi-node cluster but you will also deal with new challenges. 

# Deploy to multi-node SWARM cluster

When you scale from a single node to a multi-node swarm cluster, you will need to deal with at least 2 new challenges:

**1. How to distribute images on each node**

All the nodes need to access to the same set of images. When you run a single-node cluster, all the images are cached locally and the command `docker image ls` shows all the locally cached images. Running docker across nodes will require a registry such that every node can resolve to the same image easily. If your team has standardised on a public or private registry, then you can stick with that one. Otherwise, you will have 2 choices:
* public registry such as hub.docker.com - your machine needs to have very good upload speed to Internet because images are hundreds of MBs.
* private registry - you can build a private registry quickly for testing. When changes to images are stablised, you can switch to a public registry because trying to provide resilency of a registry is not a trivial task. 

In this document, I will cover how to deploy a private registry for testing the deployment quickly. 

**2. Where to deploy each component**

Some containers may need to access external resources where it is not appropriate to copy into the images. E.g. MySQL needs to have a persistent storage and it's not available on every node, all Apache containers need to access the same content directory and the directory may be changed dynamically. Hence you want to have the flexibility of deploying specific types of containers to certain nodes only. This project uses Docker compose constraint to work with Docker node label such as MySQL is only deployed to a node capable of supporting database directory. Specifically, the MySQL container is only deployed to a node with label "web2py.tier.db=true". You can extend the concept to other tiers such as having "web2py.tier.web=true" for Apache http server and "web2py.tier.app=true" for Python containers.

## Topology
The project assumes there are multiple nodes and one of them is designated as a "master" node for deploying services. Let's assume there are 3 nodes called "docker01", "docker02" and "docker03" respectively where "docker01" is the "master" node where you have tried the single node deployment. I will refer to "docker01" in the rest of the section even though none of the scripts has hard-coded any hostname inside.  

## Deploy a private registry
1. go to top of project directory on "docker01" and then go to subdirectory `./registry`
2. run `./deploy_private_registry.sh`
It will deploy a v2 registry from official library at hub.docker.com. You can check the deployment by `docker service ls` to see 

`ID                  NAME                MODE                REPLICAS            IMAGE                                         PORTS

9kky12ihlxk8        registry            replicated          1/1                 registry:2                                    *:5000->5000/tcp`


3. run `./push_private_images.sh` to publish images to private registry
4. check if publish is successful by the command `./list_images_in_registry.sh`. It should print this single line on what images are stored in the private registry:
`{"repositories":["web2py_apache2","web2py_mysql5","web2py_python27"]}`

Now the registry is ready and you will prepare other nodes to join the swarm cluster.

**Note:** - the registry does not have a persistent directory configured. As a result, restarting "docker01" will lose all images but you can just run the script `push_private_images.sh` again to re-populate the registry.

## Add new Docker node to Swarm cluster
First go to "docker01" and run `docker swarm join-token worker` to print a command for joining new nodes. Make a copy of the whole line of `docker swarm join` command.

For every new node to join the swarm of "docker01":
1. git clone this repository `git clone https://github.com/eddieho/docker-web2py.git`
1. install Docker and Docker Compose. Please go back to an earlier section "**Installation of Docker**" for instructions.
1. run the command `docker swarm join --token SWMTKN-1-....` obtained from "docker01".
1. go to "docker01" and run `docker node ls` to see if the joining node is visible to swarm manager on "docker01".

By the end of the process, running `docker node ls` should show all the nodes just joined plus the master "docker01".

## Prepare Test Environment
1. If you are using a private registry, then please run the following script in every single node including "docker01":

`./tests/allow_insecure_registries.sh`

By default, registry client has to connect via SSL. For test purpose but never in production, you can allow plain text communication. 

2. Mark only one node to run MySQL. Choose one node you want and run the script `./node/tag_node_db.sh` such that it marks the Docker node with a label 'web2py.tier.db=true'. If you have provisioned access to the same directory on a storage (e.g. NFS mount), then you may mark all those nodes with 'web2py.tier.db=true' and Docker stack will pick one of them to run. Remember this verison of the project only supports one container of MySQL for the whole application.

3. Prepare directory mappings - If you inspect the file env_for_cluster.sh, you will see directory mappings such as:

export MYSQL_CONF_DIR=$HOME/web2py/mysql5/mysql_cnf/mysql.conf.d

export MYSQL_DATA_DIR=$HOME/web2py/mysql5/datadir

export MYSQL_INIT_DIR=$HOME/web2py/mysql5/init

They are referenced in docker stack file `docker_compose_cluster.yml`. If you just want to do a quick sanity test of deployment, you may run the script `./tests/set_test_links.sh` on every single node in the cluster including "docker01". Otherwise, please edit the file env_for_cluster.sh to ensure all variables ending with "_DIR" are pointing to an appropriate directory.

## Deploy application to cluster
Here is a recap and checklist of what you have done to prepare for cluster deployment:
1. all nodes have been registered as shown by the command `docker node ls` running on "docker01".
1. all nodes can access the registry for images. If you are using a private registry, you can test it with `./registry/list_images_in_registry.sh`
1. one and only one node has been marked with a label `web2py.tier.db=true` by the script `./node/tag_node_db.sh`.
1. directory mappings have been configured whether it is by the sample script `./test/set_test_links.sh` or you have manually edited the file env_for_cluster.sh

Now you can deploy the application to the cluster by `./deploy_cluster.sh`. It will take some time to complete the deployment even if there is no error. You can check the deployment by:
1. Run `docker service ls` on a manager node (i.e. "docker01") to find out all replicas have been deployed. i.e. the values under 'REPLICAS' has N/N instead of 0/N, 1/N, etc.
1. Run `docker ps` on all the nodes to find out how many instances of each component has been deployed.
1. Run `docker ps` on the node marked with `web2py.tier.db=true` to ensure web2py_mysql5 is running there. 

## Networking in Docker Swarm
If you try to access any published port outside of Docker container (e.g. port 5000 of private registry), you can just access any Docker node with the port number. In fact, you can look the script `./registry/list_images_in_registry.sh` to see that it talks to local machine's name at port 5000 and it doesn't matter which node you run the script as long as it is a swarm node. 

If you try to access a service (e.g. web2py_python27) from another container (e.g. webpy_apache2), then you just need to call the service name as if it is a host name and Docker swarm will round robin the request to one instance of the service. Perhaps explaining a bit of details will help. There are 3 services in the docker application defined in docker_compose_cluster.yml:
1. web2py_apache2
1. web2py_python27
1. web2py_mysql5

Let's say both web2py_apache2 and web2py_python27 have 3 replicas to have 6 containers altogether at runtime. Docker swarm will create 6 different IP addresses for these 6 containers. On top of that, there is a service level virtual ip for each service. If you go into any container by `docker exec -it <container ID> /bin/bash`, you can run nslookup to find a service's virtual ip by `nslookup web2py_apache2`, `nslookup web2py_python27` or `nslookup web2py_mysql5`. The default behaviour is each nslookup call will return exactly one IP address which the VIP of the service. If you try to have integration between services (e.g. Apache routing to python application tier), you should use web2py_python27 inside web2py_apache2 and let swarm handles round-robin. 

If you try to access a specific container, then you will need to find out its IP address by command `docker network inspect web2py_default` (web2py_default is an overlay network created by docker stack automatically).

This is the default behaviour of end point mode "vip". Alternatively, you may want to do your own load balancing and want to access IP address of individual containers regardless of where they are. In this case, you may switch to end point mode of "dnsrr". Please look at Docker networking documentation [here](https://docs.docker.com/compose/compose-file/#endpoint_mode) for more details. 
