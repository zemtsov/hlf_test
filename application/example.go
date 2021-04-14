package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"path/filepath"

	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

const (
	AppUserName   = "appUser"
	ChannelName   = "primary"
	ChaincodeName = "hello"
)

type Organization struct {
	MspID                 string
	Domain                string
	ConnectionProfilePath string
}

var Organizations = []Organization{
	{
		MspID:                 "Org1MSP",
		Domain:                "org1.example.com",
		ConnectionProfilePath: filepath.Join(".", "connection-org1.yaml"),
	},
	{
		MspID:                 "Org2MSP",
		Domain:                "org2.example.com",
		ConnectionProfilePath: filepath.Join(".", "connection-org2.yaml"),
	},
}

func main() {

	org := Organizations[1]
	log.Printf("Working with organization %s\n", org.MspID)

	walletName := fmt.Sprintf("%swallet", org.MspID)

	wallet, err := gateway.NewFileSystemWallet(walletName)
	if err != nil {
		log.Fatalf("Failed to create wallet: %v", err)
	}

	if !wallet.Exists(AppUserName) {
		err = PopulateWallet(wallet, org)
		if err != nil {
			log.Fatalf("Failed to populate wallet contents: %v", err)
		}
	}

	gw, err := gateway.Connect(
		gateway.WithConfig(config.FromFile(filepath.Clean(org.ConnectionProfilePath))),
		gateway.WithIdentity(wallet, AppUserName),
		gateway.WithDiscovery(true),
		gateway.WithCommitHandler(gateway.DefaultCommitHandlers.OrgAll),
	)
	if err != nil {
		log.Fatalf("Failed to connect to gateway: %v", err)
	}
	defer gw.Close()

	network, err := gw.GetNetwork(ChannelName)
	if err != nil {
		log.Fatalf("Failed to get network: %v", err)
	}

	contract := network.GetContract(ChaincodeName)

	log.Println("--> Submit Transaction")
	result, err := contract.SubmitTransaction("store", "value1", "value_from_the_app")
	if err != nil {
		log.Fatalf("Failed to Submit transaction: %v", err)
	}
	log.Println(string(result))

	log.Println("--> Evaluate Transaction")
	result, err = contract.EvaluateTransaction("read", "value1")
	if err != nil {
		log.Fatalf("Failed to evaluate transaction: %v", err)
	}
	log.Println(string(result))
}

func PopulateWallet(wallet *gateway.Wallet, organization Organization) error {

	log.Println("============ Populating wallet ============")
	credPath := filepath.Join(
		"..",
		"organizations",
		"peerOrganizations",
		organization.Domain,
		"users",
		fmt.Sprintf("User1@%s", organization.Domain),
		"msp",
	)

	certDir := filepath.Join(credPath, "signcerts")
	files, err := ioutil.ReadDir(certDir)
	if err != nil {
		return err
	}
	if len(files) != 1 {
		return fmt.Errorf("cert dir should contain one file")
	}

	certPath := filepath.Join(certDir, files[0].Name())
	// read the certificate pem
	cert, err := ioutil.ReadFile(filepath.Clean(certPath))
	if err != nil {
		return err
	}

	keyDir := filepath.Join(credPath, "keystore")
	// there's a single file in this dir containing the private key
	files, err = ioutil.ReadDir(keyDir)
	if err != nil {
		return err
	}
	if len(files) != 1 {
		return fmt.Errorf("keystore folder should have contain one file")
	}
	keyPath := filepath.Join(keyDir, files[0].Name())
	key, err := ioutil.ReadFile(filepath.Clean(keyPath))
	if err != nil {
		return err
	}

	identity := gateway.NewX509Identity(organization.MspID, string(cert), string(key))

	return wallet.Put(AppUserName, identity)
}
