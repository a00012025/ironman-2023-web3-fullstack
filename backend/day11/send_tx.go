package main

import (
	"context"
	"crypto/ecdsa"
	"fmt"
	"log"
	"math/big"
	"os"
	"strings"
	"time"

	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethclient"
	hdwallet "github.com/miguelmota/go-ethereum-hdwallet"
)

// DeriveWallet derive wallet from mnemonic and path. It returns the account and private key.
func DeriveWallet(mnemonic string, path accounts.DerivationPath) (*accounts.Account, *ecdsa.PrivateKey, error) {
	mnemonic = strings.Trim(mnemonic, "\n")
	wallet, err := hdwallet.NewFromMnemonic(mnemonic)
	if err != nil {
		return nil, nil, err
	}
	account, err := wallet.Derive(path, false)
	if err != nil {
		return nil, nil, err
	}
	privateKey, err := wallet.PrivateKey(account)
	if err != nil {
		return nil, nil, err
	}
	return &account, privateKey, nil
}

func main() {
	fmt.Println("Please enter your mnemonic:")
	var mnemonic string
	for i := 0; i < 12; i++ {
		var word string
		fmt.Scanf("%s", &word)
		mnemonic += word
		if i != 11 {
			mnemonic += " "
		}
	}

	path := hdwallet.MustParseDerivationPath("m/44'/60'/0'/0/0")
	account, privateKey, err := DeriveWallet(mnemonic, path)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Wallet address: %s\n", account.Address.Hex())
	amountToSend := big.NewInt(1000000000000000) // 0.001 eth in wei

	// connect to json rpc node
	client, err := ethclient.Dial("https://eth-sepolia.g.alchemy.com/v2/" + os.Getenv("ALCHEMY_API_KEY"))
	if err != nil {
		log.Fatal(err)
	}

	// get nonce
	nonce, err := client.PendingNonceAt(context.Background(), common.HexToAddress(account.Address.Hex()))
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Got nonce: %d\n", nonce)

	// get gas price
	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Got gas price: %d\n", gasPrice)

	// estimate gas
	estimateGas, err := client.EstimateGas(context.Background(), ethereum.CallMsg{
		From:  common.HexToAddress(account.Address.Hex()),
		To:    nil,
		Value: amountToSend,
		Data:  nil,
	})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Estimated gas: %d\n", estimateGas)

	// create transaction
	tx := types.NewTransaction(
		nonce,
		common.HexToAddress("0xE2Dc3214f7096a94077E71A3E218243E289F1067"),
		amountToSend,
		estimateGas,
		gasPrice,
		[]byte{},
	)
	chainID := big.NewInt(11155111)
	signedTx, err := types.SignTx(tx, types.NewEIP155Signer(chainID), privateKey)
	if err != nil {
		log.Fatal(err)
	}

	// broadcast transaction
	err = client.SendTransaction(context.Background(), signedTx)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("tx sent: %s\n", signedTx.Hash().Hex())

	// wait until transaction is confirmed
	var receipt *types.Receipt
	for {
		receipt, err = client.TransactionReceipt(context.Background(), signedTx.Hash())
		if err != nil {
			fmt.Println("tx is not confirmed yet")
			time.Sleep(5 * time.Second)
		}
		if receipt != nil {
			break
		}
	}
	// Status = 1 if transaction succeeded
	fmt.Printf("tx is confirmed: %v. Block number: %v\n", receipt.Status, receipt.BlockNumber)
}
