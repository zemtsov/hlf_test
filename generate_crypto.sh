#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

if [ -d "organizations/peerOrganizations" ]; then
    echo "Removing existing crypto materials"
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
fi

echo "Creating crypto materials for Org1"

cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"

result=$?
if [ $result -ne 0 ]; then
    echo "Failed creating crypto materials for Org1"
fi

echo "Creating crypto materials for Org2"

cryptogen generate --config=./organizations/cryptogen/crypto-config-org2.yaml --output="organizations"

result=$?
if [ $result -ne 0 ]; then
    echo "Failed creating crypto materials for Org2"
fi

echo "Creating crypto materials for Orderer"

cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

result=$?
if [ $result -ne 0 ]; then
    echo "Failed creating crypto materials for Orderer"
fi

. organizations/ccp-generate.sh
