package main

import (
	"context"
	"fmt"
	"log"
	"math/big"
	"os"

	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/metachris/eth-go-bindings/erc20"
	"github.com/shopspring/decimal"
)

const transferEventSignature = "Transfer(address,address,uint256)"

// const targetAddress = "0x2089035369B33403DdcaBa6258c34e0B3FfbbBd9"
// const targetAddress = "0x31d1C7751EAA6374D4138597e8c7b5a1605cC43c"
const targetAddress = "0x32e0556aeC41a34C3002a264f4694193EBCf44F7"

func main() {
	// connect to json rpc node
	client, err := ethclient.Dial("wss://eth-sepolia.g.alchemy.com/v2/" + os.Getenv("ALCHEMY_API_KEY"))
	if err != nil {
		log.Fatal(err)
	}

	// transfer out filter query
	transferEventSignatureHash := crypto.Keccak256Hash([]byte(transferEventSignature))
	transferOutQuery := ethereum.FilterQuery{
		Addresses: []common.Address{},
		Topics: [][]common.Hash{
			{transferEventSignatureHash},
			{common.HexToHash(targetAddress)},
			{},
		},
	}
	transferOutLogs, err := client.FilterLogs(context.Background(), transferOutQuery)
	if err != nil {
		log.Fatalf("Failed to retrieve logs: %v", err)
	}
	fmt.Printf("Got %d transfer out logs\n", len(transferOutLogs))

	// transfer in filter query
	transferInQuery := ethereum.FilterQuery{
		Addresses: []common.Address{},
		Topics: [][]common.Hash{
			{transferEventSignatureHash},
			{},
			{common.HexToHash(targetAddress)},
		},
	}
	transferInLogs, err := client.FilterLogs(context.Background(), transferInQuery)
	if err != nil {
		log.Fatalf("Failed to retrieve logs: %v", err)
	}
	fmt.Printf("Got %d transfer in logs\n", len(transferInLogs))

	// get an arbitrary erc20 binding
	erc20Token, err := erc20.NewErc20(common.HexToAddress("0x0000000000000000000000000000000000000000"), client)
	if err != nil {
		log.Fatalf("Failed to bind to erc20 contract: %v", err)
	}

	// calculate token balances
	allLogs := append(transferInLogs, transferOutLogs...)
	tokenBalances := make(map[string]*big.Int)
	tokens := make(map[string]struct {
		name     string
		decimals uint8
	})
	isERC20Contract := make(map[string]bool)
	for _, vLog := range allLogs {
		// check if the log is ERC-20 Transfer event
		if len(vLog.Topics) != 3 {
			continue
		}

		// check if the contract is ERC20 token contract
		contractAddress := vLog.Address.Hex()
		if val, ok := isERC20Contract[contractAddress]; ok && !val {
			// already checked and not ERC20 token contract
			continue
		}

		// get token data
		if _, ok := tokens[contractAddress]; !ok {
			name, decimals, err := getNameAndDecimals(client, vLog.Address)
			if err != nil {
				// not ERC20 token contract
				isERC20Contract[contractAddress] = false
				continue
			}
			isERC20Contract[contractAddress] = true
			tokens[contractAddress] = struct {
				name     string
				decimals uint8
			}{name, decimals}
		}

		// update token balance
		transferEvent, err := erc20Token.ParseTransfer(vLog)
		if err != nil {
			log.Fatalf("Failed to unmarshal Transfer event: %v", err)
		}
		if transferEvent.From != transferEvent.To {
			if _, ok := tokenBalances[contractAddress]; !ok {
				tokenBalances[contractAddress] = big.NewInt(0)
			}
			if vLog.Topics[1] == common.HexToHash(targetAddress) {
				tokenBalances[contractAddress] = tokenBalances[contractAddress].Sub(tokenBalances[contractAddress], transferEvent.Value)
			} else {
				tokenBalances[contractAddress] = tokenBalances[contractAddress].Add(tokenBalances[contractAddress], transferEvent.Value)
			}
		}
	}

	// print token balances
	fmt.Println("Token Balances:")
	for contractAddress, balance := range tokenBalances {
		if balance.Cmp(big.NewInt(0)) == 0 {
			continue
		}
		balanceStr := decimal.NewFromBigInt(balance, -int32(tokens[contractAddress].decimals))
		fmt.Printf("%-32s: %s (%s)\n", tokens[contractAddress].name, balanceStr, contractAddress)
	}

	// listen to new transfer in/out event
	fmt.Println("Listening to new transfer in/out event...")
	var transferOutChan = make(chan types.Log)
	transferOutSub, err := client.SubscribeFilterLogs(context.Background(), transferOutQuery, transferOutChan)
	if err != nil {
		log.Fatalf("Failed to subscribe to transfer out event: %v", err)
	}
	var transferInChan = make(chan types.Log)
	transferInSub, err := client.SubscribeFilterLogs(context.Background(), transferInQuery, transferInChan)
	if err != nil {
		log.Fatalf("Failed to subscribe to transfer in event: %v", err)
	}

	for {
		// wait for new transfer event
		var newLog types.Log
		select {
		case err := <-transferOutSub.Err():
			log.Fatalf("Failed to receive transfer out event: %v", err)
		case err := <-transferInSub.Err():
			log.Fatalf("Failed to receive transfer in event: %v", err)
		case newLog = <-transferOutChan:
			fmt.Printf("Got transfer out event. hash: %s, address: %s, block: %d, topics: %+v\n", newLog.TxHash, newLog.Address, newLog.BlockNumber, newLog.Topics)
			// we can get the token name and decimals, then update token balance here
		case newLog = <-transferInChan:
			fmt.Printf("Got transfer in event. hash: %s, address: %s, block: %d, topics: %+v\n", newLog.TxHash, newLog.Address, newLog.BlockNumber, newLog.Topics)
			// we can get the token name and decimals, then update token balance here
		}
	}
}

// getNameAndDecimals get name and decimals if contract is ERC20 token. Otherwise, return error.
func getNameAndDecimals(client *ethclient.Client, address common.Address) (name string, decimals uint8, err error) {
	erc20Token, err := erc20.NewErc20(address, client)
	if err != nil {
		return
	}
	name, err = erc20Token.Name(nil)
	if err != nil || name == "" {
		return
	}
	symbol, err := erc20Token.Symbol(nil)
	if err != nil || symbol == "" {
		return
	}
	totalSupply, err := erc20Token.TotalSupply(nil)
	if err != nil || totalSupply.Cmp(big.NewInt(0)) == 0 {
		return
	}
	decimals, err = erc20Token.Decimals(nil)
	if err != nil || decimals == 0 {
		return
	}
	fmt.Printf("%s is ERC20 token\n", address.Hex())
	return
}
