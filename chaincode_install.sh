. env.sh

PATH=${PWD}/bin:$PATH
CC_SRC_PATH=chaincode/${CC_NAME}
CC_VERSION=${1:-"1"}
CC_SEQUENCE=1
INIT_REQUIRED="NA"
CC_END_POLICY="NA"
CC_COLL_CONFIG="NA"

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# VENDOR
######################################################################

echo "Vendoring chaincode"

pushd $CC_SRC_PATH
rm -rf vendor go.mod go.sum
go mod init
GO111MODULE=on go mod vendor
popd

######################################################################
# PACKAGE
######################################################################

echo "Packaging chaincode"

FABRIC_CFG_PATH=./config peer lifecycle chaincode package ${CC_SRC_PATH}/${CC_NAME}.tar.gz \
    --path ${CC_SRC_PATH} \
    --lang ${CC_RUNTIME_LANGUAGE} \
    --label ${CC_NAME}_${CC_VERSION}

result=$?
if [ $result -ne 0 ]; then
    echo "Failed packaging chaincode"
    exit 1
fi

######################################################################
# ORG 1
######################################################################

echo "Installing chaincode on peer0.org1.example.com"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

peer lifecycle chaincode install ${CC_SRC_PATH}/${CC_NAME}.tar.gz

result=$?
if [ $result -ne 0 ]; then
    echo "Failed installing chaincode on peer0.org1.example.com"
fi

echo "Querying the list of installed chaincodes"
peer lifecycle chaincode queryinstalled >&log.txt
cat log.txt
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

echo "Approving the chaincode"
peer lifecycle chaincode approveformyorg -o localhost:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG}

######################################################################
# ORG 2
######################################################################

echo "Installing chaincode on peer0.org2.example.com"

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp

peer lifecycle chaincode install ${CC_SRC_PATH}/${CC_NAME}.tar.gz

result=$?
if [ $result -ne 0 ]; then
    echo "Failed installing chaincode on peer0.org2.example.com"
fi

echo "Querying the list of installed chaincodes"
peer lifecycle chaincode queryinstalled >&log.txt
cat log.txt
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

echo "Approving the chaincode"
peer lifecycle chaincode approveformyorg -o localhost:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG}
