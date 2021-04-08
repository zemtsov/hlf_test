#!/bin/bash

WORKING_DIR=${PWD}
echo "Changing to HLF source directory"
cd ${GOPATH}/src/github.com/hyperledger/fabric

echo "Current directory is ${PWD}"
echo "Making cryptogen utility"
make cryptogen

echo "Making configtxgen utility"
make configtxgen

echo "Making peer utility"
make peer

echo "Copying result files into the working directory"

if [ -d "${WORKING_DIR}/bin" ]; then
    echo "Removing existing crypto materials"
    rm -Rf ${WORKING_DIR}/bin
fi

mkdir -p ${WORKING_DIR}/bin

cp build/bin/* ${WORKING_DIR}/bin

echo "Returning to the working directory"
cd ${WORKING_DIR}
