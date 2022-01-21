#!/bin/bash

. /opt/gopath/scripts/env.sh
. /opt/gopath/scripts/utils.sh

cd /opt/gopath/src/"${CHAINCODE_NAME}" || exit
. chaincode.env || exit
info "Chaincode package ID read from the file is ${CHAINCODE_ID}"
cd - || exit

export CHAINCODE_ID=$CHAINCODE_ID

useOrganization 1
/opt/gopath/scripts/chaincode/approve.sh

useOrganization 2
/opt/gopath/scripts/chaincode/approve.sh

/opt/gopath/scripts/chaincode/commit.sh
