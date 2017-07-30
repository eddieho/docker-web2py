#!/bin/bash 

PROJECT_NAME=web2py
COMPOSE_FILE=docker-compose.yml
echo docker-compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} up -d
docker-compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} up -d
