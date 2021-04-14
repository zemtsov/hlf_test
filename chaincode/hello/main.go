package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-protos-go/peer"
)

type ChaincodeValue struct {
	Value string `json:"value"`
}

// HelloChaincode ...
type HelloChaincode struct {
}

// Init ...
func (cc *HelloChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {

	storeValue(stub, "value1", "initial_value")

	fmt.Println("Init function invoked successfully")

	return shim.Success(nil)
}

// Invoke ...
func (cc *HelloChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, args := stub.GetFunctionAndParameters()

	fmt.Println("Invoked successfully")

	if function == "store" {
		if len(args) < 2 {
			return shim.Error("Not enough arguments")
		}
		return storeValue(stub, args[0], args[1])
	}
	if function == "read" {
		if len(args) < 1 {
			return shim.Error("Not enough arguments")
		}
		return readValue(stub, args[0])
	}
	return shim.Error("Unknown function")
}

func readValue(stub shim.ChaincodeStubInterface, key string) peer.Response {

	bytes, err := stub.GetState(key)
	if err != nil {
		return shim.Error("Failed reading value")
	}

	chaincodeValue := ChaincodeValue{}
	err = json.Unmarshal(bytes, &chaincodeValue)
	if err != nil {
		return shim.Error("Failed unmarshalling value")
	}

	return shim.Success([]byte(chaincodeValue.Value))
}

func storeValue(stub shim.ChaincodeStubInterface, key string, value string) peer.Response {

	bytes, err := json.Marshal(ChaincodeValue{Value: value})
	if err != nil {
		return shim.Error("Failed marshalling value")
	}

	if stub.PutState(key, bytes) != nil {
		return shim.Error("Failed storing value")
	}
	return shim.Success([]byte(value))
}

func main() {

	if err := shim.Start(&HelloChaincode{}); err != nil {
		fmt.Printf("Failed to start chaincode. Error: %s", err.Error())
	}
}
