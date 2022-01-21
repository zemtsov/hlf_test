#!/bin/bash

. /opt/gopath/scripts/env.sh
. /opt/gopath/scripts/utils.sh

title "Making package for the chaincode ${CHAINCODE_NAME}"

/opt/gopath/scripts/chaincode/package.sh

title "Installing the chaincode package on the peer ${ORG1_PEER0_ID}"
useOrganization 1
/opt/gopath/scripts/chaincode/install.sh

title "Installing the chaincode package on the peer ${ORG2_PEER0_ID}"
useOrganization 2
/opt/gopath/scripts/chaincode/install.sh

INSTALLED_CHAINCODES=$(peer lifecycle chaincode queryinstalled)

CHAINCODE_ID=$(echo "${INSTALLED_CHAINCODES}" | sed -n "/${CHAINCODE_LABEL}/{s/^Package ID: //; s/, Label:.*$//; p;}")

cd /opt/gopath/src/"${CHAINCODE_NAME}" || exit

info "Writing chaincode.env"

echo "CHAINCODE_SERVER_ADDRESS=${CHAINCODE_NAME}-chaincode-svc:${CHAINCODE_PORT}" > chaincode.env
echo "CHAINCODE_ID=${CHAINCODE_ID}" >> chaincode.env

info "Chaincode package ID is ${CHAINCODE_ID}"
