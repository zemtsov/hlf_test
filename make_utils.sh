#!/bin/bash

. env.sh

WORKING_DIR=${PWD}

if [ ! -d ${GOPATH}/src/github.com/hyperledger/fabric ]; then
    mkdir -p ${GOPATH}/src/github.com/hyperledger
    cd ${GOPATH}/src/github.com/hyperledger
    git clone https://github.com/hyperledger/fabric
fi

echo "Changing to HLF source directory"
cd ${GOPATH}/src/github.com/hyperledger/fabric || exit 1
git checkout "${FABRIC_VERSION_TAG}"

echo "Current directory is ${PWD}"
echo "Making cryptogen utility"
make cryptogen

echo "Making configtxgen utility"
make configtxgen

echo "Making configtxlator utility"
make configtxlator

echo "Making peer utility"
make peer

echo "Copying result files into the working directory"

if [ -d "${WORKING_DIR}/bin" ]; then
    echo "Removing existing binaries"
    rm -Rf ${WORKING_DIR}/bin
fi

mkdir -p ${WORKING_DIR}/bin

cp build/bin/* ${WORKING_DIR}/bin


if [ ! -d ${GOPATH}/src/github.com/hyperledger/fabric-ca ]; then
    mkdir -p ${GOPATH}/src/github.com/hyperledger
    cd ${GOPATH}/src/github.com/hyperledger
    git clone https://github.com/hyperledger/fabric-ca
fi

echo "Changing to Fabric CA source directory"
cd ${GOPATH}/src/github.com/hyperledger/fabric-ca || exit 1
git checkout "${FABRIC_CA_VERSION_TAG}"
GO111MODULE=off make fabric-ca-client
cp bin/fabric-ca-client ${WORKING_DIR}/bin

echo "Returning to the working directory"
cd ${WORKING_DIR}
