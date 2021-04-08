package main

import (
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-protos-go/peer"
)

// HelloChaincode ...
type HelloChaincode struct {
}

// Init ...
func (cc *HelloChaincode) Init(_ shim.ChaincodeStubInterface) peer.Response {

	return shim.Success(nil)
}

// Invoke ...
func (cc *HelloChaincode) Invoke(_ shim.ChaincodeStubInterface) peer.Response {

	return shim.Success([]byte("\n****** Hello from chaincode ******\n"))
}

func main() {

	if err := shim.Start(&HelloChaincode{}); err != nil {
		fmt.Printf("Failed to start chaincode. Error: %s", err.Error())
	}
}
