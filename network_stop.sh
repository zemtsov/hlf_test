#!/bin/bash

. env.sh

echo "Stopping test network"
docker-compose -f docker/docker-compose-test-net.yaml -f docker/docker-compose-ca.yaml -f docker/docker-compose-couch.yaml down --volumes --remove-orphans

echo "Deleting containers"
CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "No containers available for deletion"
else
    docker rm -f $CONTAINER_IDS
fi

echo "Deleting images"
DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    echo "No images available for deletion"
else
    docker rmi -f $DOCKER_IMAGE_IDS
fi
