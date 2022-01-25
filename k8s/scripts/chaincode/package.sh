#!/bin/bash

. /opt/gopath/scripts/utils.sh

cd /opt/gopath/src/"${CHAINCODE_NAME}" || exit

info "Writing connection.json"
if [ -f connection.json ]; then
  rm connection.json
fi
jq <<< "{\"address\": \"${CHAINCODE_NAME}-chaincode-svc:${CHAINCODE_PORT}\", \"dial_timeout\": \"10s\", \"tls_required\": false}" > connection.json

#touch connection.json

info "Writing metadata.json"
if [ -f metadata.json ]; then
  rm metadata.json
fi
jq <<< "{\"type\": \"external\", \"label\": \"${CHAINCODE_LABEL}\"}" > metadata.json

info "Putting connection.json to the archive"
if [ -f code.tar.gz ]; then
  rm code.tar.gz
fi
tar cfz code.tar.gz connection.json

info "Creating the chaincode package"
if [ -f "${CHAINCODE_LABEL}".tgz ]; then
  rm "${CHAINCODE_LABEL}".tgz
fi
tar cfz "${CHAINCODE_LABEL}".tgz metadata.json code.tar.gz
