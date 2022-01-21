#!/bin/bash

. /opt/gopath/scripts/env.sh
. /opt/gopath/scripts/utils.sh

useOrganization 1
/opt/gopath/scripts/chaincode/invoke.sh

sleep 2

/opt/gopath/scripts/chaincode/query.sh

useOrganization 2
/opt/gopath/scripts/chaincode/query.sh
