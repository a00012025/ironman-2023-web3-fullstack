package main

import (
	"context"
	"crypto/ecdsa"
	"fmt"
	"log"
	"math/big"
	"math/rand"
	"os"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/ethereum/go-ethereum/accounts"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/metachris/eth-go-bindings/erc20"
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

const uniTokenContractAddress = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"

var currentNonce int64 = -1 // -1 means not initialized
func main() {
	rand.Seed(33333)

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

	// connect to json rpc node
	client, err := ethclient.Dial("https://eth-sepolia.g.alchemy.com/v2/" + os.Getenv("ALCHEMY_API_KEY"))
	if err != nil {
		log.Fatal(err)
	}

	// init nonce
	nonce, err := client.PendingNonceAt(context.Background(), account.Address)
	if err != nil {
		log.Fatal(err)
	}
	atomic.StoreInt64(&currentNonce, int64(nonce))

	// send 3 transaction concurrently
	wg := sync.WaitGroup{}
	for i := 0; i < 3; i++ {
		wg.Add(1)
		go func() {
			tx, err := sendUniTokenTransferTx(client, account.Address, privateKey)
			if err == nil {
				fmt.Printf("tx sent: %s\n", tx.Hash().Hex())
				waitUntilTxConfirmed(tx, client)
			} else {
				fmt.Printf("tx sent failed: %s\n", err.Error())
			}
			wg.Done()
		}()
	}
	wg.Wait()
}

func sendUniTokenTransferTx(client *ethclient.Client, address common.Address, privateKey *ecdsa.PrivateKey) (tx *types.Transaction, err error) {
	uniToken, err := erc20.NewErc20(common.HexToAddress(uniTokenContractAddress), client)
	if err != nil {
		log.Fatal(err)
	}

	// get gas price
	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	// get next nonce
	nonce := atomic.AddInt64(&currentNonce, 1) - 1
	fmt.Printf("Got nonce: %d\n", nonce)

	chainID := big.NewInt(11155111)
	amount := rand.Int63n(1000000)
	if rand.Int()%2 == 0 {
		// simulate RPC node error
		return nil, fmt.Errorf("RPC node error for nonce %d", nonce)
	}
	tx, err = uniToken.Transfer(
		&bind.TransactOpts{
			From: common.HexToAddress(address.Hex()),
			Signer: func(_ common.Address, tx *types.Transaction) (*types.Transaction, error) {
				return types.SignTx(tx, types.NewEIP155Signer(chainID), privateKey)
			},
			Value:    big.NewInt(0),
			GasPrice: gasPrice,
			Nonce:    big.NewInt(nonce),
		},
		common.HexToAddress("0xE2Dc3214f7096a94077E71A3E218243E289F1067"),
		big.NewInt(amount),
	)
	return
}

func waitUntilTxConfirmed(tx *types.Transaction, client *ethclient.Client) {
	// wait until transaction is confirmed
	fmt.Printf("Waiting for tx %s to be confirmed...\n", tx.Hash().Hex())
	var receipt *types.Receipt
	for {
		var err error
		receipt, err = client.TransactionReceipt(context.Background(), tx.Hash())
		if err != nil {
			time.Sleep(5 * time.Second)
		}
		if receipt != nil && receipt.BlockNumber != nil {
			break
		}
	}
	fmt.Printf("tx %s is confirmed: %v. Block number: %v\n", tx.Hash(), receipt.Status, receipt.BlockNumber)
	if receipt.Status != types.ReceiptStatusSuccessful {
		fmt.Println("tx failed!")
	} else {
		fmt.Println("tx successful!")
	}
}
