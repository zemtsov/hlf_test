#!/bin/bash

# Network parameters
export COMPOSE_PROJECT_NAME=net

# Hyperledger Fabric parameters
export IMAGE_TAG=2.2.2
export CHANNEL_NAME=primary

# Chaincode parameters
export CC_NAME=hello
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH=chaincode/${CC_NAME}
export INIT_REQUIRED="--init-required"
export CC_END_POLICY="--signature-policy AND('Org1MSP.peer','Org2MSP.peer')"
