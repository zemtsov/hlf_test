#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

CC_VERSION=${1:-"1"}

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# VENDOR
######################################################################

echo
echo "Vendoring chaincode ${CC_NAME}"

pushd "$CC_SRC_PATH" || exit 1
rm -rf vendor go.mod go.sum
go mod init
GO111MODULE=on go mod vendor
popd || exit 1

######################################################################
# PACKAGE
######################################################################

echo
echo "Packaging chaincode ${CC_NAME}, version ${CC_VERSION}"

rm "${CC_SRC_PATH}"/"${CC_NAME}".tar.gz | true

peer lifecycle chaincode package "${CC_SRC_PATH}"/"${CC_NAME}".tar.gz \
    --path "${CC_SRC_PATH}" \
    --lang "${CC_RUNTIME_LANGUAGE}" \
    --label "${CC_NAME}"_"${CC_VERSION}"

result=$?
if [ $result -ne 0 ]; then
    echo "Failed packaging chaincode"
    exit 1
fi
