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
# ORG 1 and ORG 2
######################################################################

echo "Committing chaincode on channel ${CHANNEL_NAME}"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

PEER_CONN_PARMS="--peerAddresses localhost:7051 --peerAddresses localhost:9051"

peer lifecycle chaincode commit -o localhost:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} $PEER_CONN_PARMS --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} >&log.txt

result=$?
if [ $result -ne 0 ]; then
    echo "Failed installing chaincode on peer0.org1.example.com"
fi

cat log.txt


######################################################################
# ORG 1
######################################################################

echo
echo "Querying committed chaincode on ORG 1"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

echo "Querying the list of installed chaincodes"
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} >&log.txt
cat log.txt


######################################################################
# ORG 2
######################################################################

echo
echo "Querying committed chaincode on ORG 2"

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp

echo "Querying the list of installed chaincodes"
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} >&log.txt
cat log.txt
