#!/bin/bash

. env.sh

if [ -z "$1" ]
then
  echo "ERROR: Version of the chaincode not passed"
  exit 1
fi

if [ -z "$2" ]
then
  echo "ERROR: Sequence number of the chaincode not passed"
  exit 1
fi


CC_VERSION=${1}
CC_SEQUENCE=${2}

. chaincode_package.sh "$CC_VERSION"
. chaincode_install.sh "$CC_VERSION"
. chaincode_approve.sh "$CC_VERSION" "$CC_SEQUENCE"
. chaincode_commit.sh "$CC_VERSION" "$CC_SEQUENCE"
