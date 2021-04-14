#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

if [ -d "organizations/peerOrganizations" ]; then
    echo "Removing existing crypto materials"
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
fi

docker-compose -f docker/docker-compose-ca.yaml up -d 2>&1

echo "Sleep 5 sec"
sleep 5
echo "Going on..."

. organizations/fabric-ca/registerEnroll.sh

echo "Creating Org1 Identities"

createOrg1

echo "Creating Org2 Identities"

createOrg2

echo "Creating Orderer Org Identities"

createOrderer
