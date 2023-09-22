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

	"github.com/a00012025/ironman-2023-web3-fullstack/backend/day18/uniswap"
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

const uniswapV2ContractAddress = "0xc532a74256d3db42d0bf7a0400fefdbad7694008"
const uniTokenContractAddress = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"

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

	// connect to json rpc node
	client, err := ethclient.Dial("https://eth-sepolia.g.alchemy.com/v2/" + os.Getenv("ALCHEMY_API_KEY"))
	if err != nil {
		log.Fatal(err)
	}

	// sending ERC20 Transfer Tx
	fmt.Printf("=== Sending ERC20 Transfer Tx...\n")
	tx, err := sendUniTokenTransferTx(client, account.Address, privateKey)
	if err != nil {
		log.Fatal(err)
	}
	waitUntilTxConfirmed(tx, client)

	// sending Uniswap Tx
	fmt.Printf("=== Sending Uniswap Tx...\n")
	tx, err = sendUniswapSwapTx(client, account.Address, privateKey)
	if err != nil {
		log.Fatal(err)
	}
	waitUntilTxConfirmed(tx, client)
}

func sendUniTokenTransferTx(client *ethclient.Client, address common.Address, privateKey *ecdsa.PrivateKey) (tx *types.Transaction, err error) {
	uniToken, err := erc20.NewErc20(common.HexToAddress(uniTokenContractAddress), client)
	if err != nil {
		log.Fatal(err)
	}

	// get nonce
	nonce, err := client.PendingNonceAt(context.Background(), common.HexToAddress(address.Hex()))
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

	chainID := big.NewInt(11155111)
	tx, err = uniToken.Transfer(
		&bind.TransactOpts{
			From: common.HexToAddress(address.Hex()),
			Signer: func(_ common.Address, tx *types.Transaction) (*types.Transaction, error) {
				return types.SignTx(tx, types.NewEIP155Signer(chainID), privateKey)
			},
			GasLimit: 1000000,
			Value:    big.NewInt(0),
			Nonce:    big.NewInt(int64(nonce)),
			GasPrice: gasPrice,
		},
		common.HexToAddress("0xE2Dc3214f7096a94077E71A3E218243E289F1067"),
		big.NewInt(1000000),
	)
	fmt.Printf("tx sent: %s\n", tx.Hash().Hex())
	return
}

func sendUniswapSwapTx(client *ethclient.Client, address common.Address, privateKey *ecdsa.PrivateKey) (tx *types.Transaction, err error) {
	uniswapV2, err := uniswap.NewUniswapV2(common.HexToAddress(uniswapV2ContractAddress), client)
	if err != nil {
		log.Fatal(err)
	}

	// get nonce
	nonce, err := client.PendingNonceAt(context.Background(), common.HexToAddress(address.Hex()))
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

	chainID := big.NewInt(11155111)
	amountToSend := big.NewInt(100000)
	tx, err = uniswapV2.SwapExactETHForTokens(
		&bind.TransactOpts{
			From: common.HexToAddress(address.Hex()),
			Signer: func(_ common.Address, tx *types.Transaction) (*types.Transaction, error) {
				return types.SignTx(tx, types.NewEIP155Signer(chainID), privateKey)
			},
			GasLimit: 1000000,
			Value:    amountToSend,
			Nonce:    big.NewInt(int64(nonce)),
			GasPrice: gasPrice,
		},
		big.NewInt(0),
		[]common.Address{
			common.HexToAddress("0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"),
			common.HexToAddress("0xbd429ad5456385bf86042358ddc81c57e72173d3"),
		},
		common.HexToAddress("0x32e0556aeC41a34C3002a264f4694193EBCf44F7"),
		big.NewInt(999999999999999999),
	)
	fmt.Printf("tx sent: %s\n", tx.Hash().Hex())
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
			fmt.Println("tx is not confirmed yet")
			time.Sleep(5 * time.Second)
		}
		if receipt != nil && receipt.BlockNumber != nil {
			break
		}
	}
	fmt.Printf("tx is confirmed: %v. Block number: %v\n", receipt.Status, receipt.BlockNumber)
	if receipt.Status != types.ReceiptStatusSuccessful {
		fmt.Println("tx failed!")
	} else {
		fmt.Println("tx successful!")
	}
}
