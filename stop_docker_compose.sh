#!/bin/bash 

PROJECT_NAME=web2py
COMPOSE_FILE=docker-compose.yml
echo docker-compose -p ${PROJECT_NAME} stop
docker-compose -p ${PROJECT_NAME} stop
