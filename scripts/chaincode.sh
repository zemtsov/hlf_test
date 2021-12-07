#!/bin/bash

######################################################################
## Deploy the chaincode
######################################################################

export CHAINCODE_PACKAGE="${CHAINCODE_NAME}.tar.gz"

/bin/bash ./scripts/deploy_chaincode.sh
