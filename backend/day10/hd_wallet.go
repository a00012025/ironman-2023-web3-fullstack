package main

import (
	"fmt"
	"log"

	"github.com/ethereum/go-ethereum/accounts"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/crypto"
	hdwallet "github.com/miguelmota/go-ethereum-hdwallet"
	"github.com/tyler-smith/go-bip39"
)

// GenerateMnemonic generate mnemonic
func GenerateMnemonic() string {
	entropy, err := bip39.NewEntropy(128)
	if err != nil {
		log.Fatal(err)
	}
	mnemonic, err := bip39.NewMnemonic(entropy)
	if err != nil {
		log.Fatal(err)
	}
	return mnemonic
}

// DeriveWallet derive wallet from mnemonic and path. It returns the account and private key.
func DeriveWallet(mnemonic string, path accounts.DerivationPath) (*accounts.Account, string, error) {
	wallet, err := hdwallet.NewFromMnemonic(mnemonic)
	if err != nil {
		return nil, "", err
	}
	account, err := wallet.Derive(path, false)
	if err != nil {
		return nil, "", err
	}
	privateKey, err := wallet.PrivateKey(account)
	if err != nil {
		return nil, "", err
	}
	privateKeyBytes := crypto.FromECDSA(privateKey)
	return &account, hexutil.Encode(privateKeyBytes), nil
}

func main() {
	mnemonic := GenerateMnemonic()
	fmt.Printf("mnemonic: %s\n", mnemonic)

	path := hdwallet.MustParseDerivationPath("m/44'/60'/0'/0/0")
	account, privateKeyHex, err := DeriveWallet(mnemonic, path)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("1st account: %s\n", account.Address.Hex())
	fmt.Printf("1st account private key: %s\n", privateKeyHex)

	path = hdwallet.MustParseDerivationPath("m/44'/60'/0'/0/1")
	account, privateKeyHex, err = DeriveWallet(mnemonic, path)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("2nd account: %s\n", account.Address.Hex())
	fmt.Printf("2nd account private key: %s\n", privateKeyHex)
}
