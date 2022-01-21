#!/bin/bash

. /opt/gopath/scripts/utils.sh

peer lifecycle chaincode install /opt/gopath/src/"${CHAINCODE_NAME}"/"${CHAINCODE_LABEL}".tgz
