#!/bin/bash

. env.sh

echo "Starting test network"
docker-compose -f docker/docker-compose-test-net.yaml up -d
