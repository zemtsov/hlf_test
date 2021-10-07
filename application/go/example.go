package main

import (
	"fmt"
	"github.com/zemtsov/hlf_test/application/go/clientconfig"
	"io/ioutil"
	"log"
	"path/filepath"

	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

func main() {

	walletPath := filepath.Join(clientconfig.ClientWalletPath, clientconfig.ClientMspId)

	log.Println("creating the wallet on the file system")
	wallet, err := gateway.NewFileSystemWallet(walletPath)
	if err != nil {
		log.Fatalf("failed creating the wallet: %v", err)
	}

	if !wallet.Exists(clientconfig.ClientUserName) {
		err = PopulateWallet(wallet)
		if err != nil {
			log.Fatalf("failed populating the wallet contents: %v", err)
		}
	}

	gw, err := gateway.Connect(
		gateway.WithConfig(config.FromFile(filepath.Clean(clientconfig.ConnectionProfilePath))),
		gateway.WithIdentity(wallet, clientconfig.ClientUserName),
	)
	if err != nil {
		log.Fatalf("Failed to connect to gateway: %v", err)
	}
	defer gw.Close()

	network, err := gw.GetNetwork(clientconfig.ChannelName)
	if err != nil {
		log.Fatalf("Failed to get network: %v", err)
	}

	contract := network.GetContract(clientconfig.ChaincodeName)

	log.Println("--> Submit Transaction")
	result, err := contract.SubmitTransaction("store", "value1", "value_from_the_app")
	if err != nil {
		log.Fatalf("failed submitting transaction: %v", err)
	}
	log.Println(string(result))

	log.Println("--> Evaluate Transaction")
	result, err = contract.EvaluateTransaction("read", "value1")
	if err != nil {
		log.Fatalf("failed querying the chaincode: %v", err)
	}
	log.Println(string(result))
}

func PopulateWallet(wallet *gateway.Wallet) error {

	log.Println("============ Populating wallet ============")
	credentialsPath := filepath.Join(
		clientconfig.CryptoRootPath,
		"peerOrganizations",
		clientconfig.ClientOrgDomain,
		"users",
		fmt.Sprintf("%s@%s", clientconfig.ClientUserName, clientconfig.ClientOrgDomain),
		"msp",
	)

	certificateDir := filepath.Join(credentialsPath, "signcerts")
	files, err := ioutil.ReadDir(certificateDir)
	if err != nil {
		return err
	}
	if len(files) != 1 {
		return fmt.Errorf("certificates directory is empty")
	}

	certPath := filepath.Join(certificateDir, files[0].Name())
	// read the certificate pem
	cert, err := ioutil.ReadFile(filepath.Clean(certPath))
	if err != nil {
		return err
	}

	keyDir := filepath.Join(credentialsPath, "keystore")
	// there's a single file in this dir containing the private key
	files, err = ioutil.ReadDir(keyDir)
	if err != nil {
		return err
	}
	if len(files) != 1 {
		return fmt.Errorf("keystore directory is empty")
	}
	keyPath := filepath.Join(keyDir, files[0].Name())
	key, err := ioutil.ReadFile(filepath.Clean(keyPath))
	if err != nil {
		return err
	}

	identity := gateway.NewX509Identity(clientconfig.ClientMspId, string(cert), string(key))

	return wallet.Put(clientconfig.ClientUserName, identity)
}
