#!/bin/bash

# Network parameters
export COMPOSE_PROJECT_NAME=net

# Hyperledger Fabric parameters
export IMAGE_TAG=2.2.2
export IMAGE_TAG_CA=1.4.9
export CHANNEL_NAME=primary

# Certs
export CORE_PEER_TLS_ENABLED=true

export PEER0_ORG1_MSP=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export PEER0_ORG2_MSP=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp

export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Chaincode parameters
export CC_NAME=hello
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH=chaincode/${CC_NAME}
export INIT_REQUIRED="--init-required"
export CC_END_POLICY="--signature-policy OR('Org1MSP.peer','Org2MSP.peer')"
