package main

import (
	"fmt"
	"log"
	"math/big"
	"os"
	"sort"
	"strings"

	"github.com/nanmu42/etherscan-api"
)

const targetAddress = "0x2089035369B33403DdcaBa6258c34e0B3FfbbBd9"
const wethAddress = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"

type TransactionType string

const (
	Send              TransactionType = "Send"
	Receive           TransactionType = "Receive"
	Wrap              TransactionType = "Wrap"
	Unwrap            TransactionType = "Unwrap"
	Swap              TransactionType = "Swap"
	ContractExecution TransactionType = "ContractExecution"
)

type CombinedTransaction struct {
	Hash           string
	ExternalTx     *etherscan.NormalTx
	InternalTxs    []etherscan.InternalTx
	ERC20Transfers []etherscan.ERC20Transfer
}

func main() {
	client := etherscan.New(etherscan.Mainnet, os.Getenv("ETHERSCAN_API_KEY"))

	// Get all transactions
	externalTxs, err := client.NormalTxByAddress(targetAddress, nil, nil, 1, 0, true)
	if err != nil {
		log.Fatalf("Failed to retrieve transactions: %v", err)
	}
	internalTxs, err := client.InternalTxByAddress(targetAddress, nil, nil, 1, 0, true)
	if err != nil {
		log.Fatalf("Failed to retrieve transactions: %v", err)
	}
	addr := targetAddress
	erc20TokenTxs, err := client.ERC20Transfers(nil, &addr, nil, nil, 1, 0, true)
	if err != nil {
		log.Fatalf("Failed to retrieve ERC20 transfers: %v", err)
	}

	// Use a map to combine transactions by their hash
	transactionsByHash := make(map[string]*CombinedTransaction)
	for i, tx := range externalTxs {
		transactionsByHash[tx.Hash] = &CombinedTransaction{
			Hash: tx.Hash,
			// avoid pointer to loop variable
			ExternalTx: &externalTxs[i],
		}
	}
	for _, tx := range internalTxs {
		if combined, exists := transactionsByHash[tx.Hash]; exists {
			combined.InternalTxs = append(combined.InternalTxs, tx)
		} else {
			transactionsByHash[tx.Hash] = &CombinedTransaction{
				Hash:        tx.Hash,
				InternalTxs: []etherscan.InternalTx{tx},
			}
		}
	}
	for _, tx := range erc20TokenTxs {
		if combined, exists := transactionsByHash[tx.Hash]; exists {
			combined.ERC20Transfers = append(combined.ERC20Transfers, tx)
		} else {
			transactionsByHash[tx.Hash] = &CombinedTransaction{
				Hash:           tx.Hash,
				ERC20Transfers: []etherscan.ERC20Transfer{tx},
			}
		}
	}

	// sort hash from newest to oldest by block number
	txHashs := make([]string, 0, len(transactionsByHash))
	for hash := range transactionsByHash {
		txHashs = append(txHashs, hash)
	}
	sort.Slice(txHashs, func(i, j int) bool {
		return transactionsByHash[txHashs[i]].BlockNumber() > transactionsByHash[txHashs[j]].BlockNumber()
	})

	// Summarize for each combined transaction
	for _, hash := range txHashs {
		combinedTx := transactionsByHash[hash]
		fmt.Printf("Transaction %s: %s\n", combinedTx.Hash, combinedTx.Summary())
	}
}

func (c *CombinedTransaction) BlockNumber() int {
	if c.ExternalTx != nil {
		return c.ExternalTx.BlockNumber
	}
	if len(c.InternalTxs) > 0 {
		return c.InternalTxs[0].BlockNumber
	}
	if len(c.ERC20Transfers) > 0 {
		return c.ERC20Transfers[0].BlockNumber
	}
	return 0
}

func (c *CombinedTransaction) GetTokenChanges() map[string]*big.Int {
	// Calculate token balance changes
	tokenChanges := make(map[string]*big.Int)

	// External ETH transaction
	if c.ExternalTx != nil {
		value := new(big.Int)
		value.SetString(c.ExternalTx.Value.Int().String(), 10)
		tokenChanges["ETH"] = value
	} else {
		tokenChanges["ETH"] = big.NewInt(0)
	}
	// Internal ETH transaction
	for _, intTx := range c.InternalTxs {
		value := new(big.Int)
		value.SetString(intTx.Value.Int().String(), 10)
		if strings.EqualFold(intTx.From, targetAddress) {
			tokenChanges["ETH"].Sub(tokenChanges["ETH"], value)
		} else {
			tokenChanges["ETH"].Add(tokenChanges["ETH"], value)
		}
	}
	// ERC20 token transfer
	for _, erc20 := range c.ERC20Transfers {
		value := new(big.Int)
		value.SetString(erc20.Value.Int().String(), 10)
		if strings.EqualFold(erc20.From, targetAddress) {
			if _, exists := tokenChanges[erc20.ContractAddress]; !exists {
				tokenChanges[erc20.ContractAddress] = new(big.Int)
			}
			tokenChanges[erc20.ContractAddress].Sub(tokenChanges[erc20.ContractAddress], value)
		} else {
			if _, exists := tokenChanges[erc20.ContractAddress]; !exists {
				tokenChanges[erc20.ContractAddress] = new(big.Int)
			}
			tokenChanges[erc20.ContractAddress].Add(tokenChanges[erc20.ContractAddress], value)
		}
	}
	// Remove zero balances
	for token, balance := range tokenChanges {
		if balance.Int64() == 0 {
			delete(tokenChanges, token)
		}
	}
	return tokenChanges
}

func (c *CombinedTransaction) Type() TransactionType {
	// Check for Wrap/Unwrap
	if c.ExternalTx != nil && strings.EqualFold(c.ExternalTx.To, wethAddress) {
		// Check for Wrap
		if c.ExternalTx.Value != nil && c.ExternalTx.Value.Int().Cmp(big.NewInt(0)) > 0 {
			return Wrap
		}

		// Check for Unwrap
		if c.ExternalTx.Value.Int().String() == "0" && len(c.InternalTxs) > 0 {
			internalTx := c.InternalTxs[0]
			if strings.EqualFold(internalTx.To, targetAddress) {
				return Unwrap
			}
		}
	}

	tokenChanges := c.GetTokenChanges()
	if len(tokenChanges) > 1 {
		// Check Swap: 2 tokens, 1 positive, 1 negative
		if len(tokenChanges) == 2 {
			sign := 1
			for _, balanceChange := range tokenChanges {
				sign *= balanceChange.Sign()
			}
			if sign < 0 {
				return Swap
			}
		}
		return ContractExecution
	}

	// Check it's a Send or Receive
	for _, balanceChange := range tokenChanges {
		if balanceChange.Sign() < 0 {
			return Send
		} else if balanceChange.Sign() > 0 {
			return Receive
		}
	}

	return ContractExecution
}

func (c *CombinedTransaction) Summary() string {
	txType := c.Type()
	tokenChanges := c.GetTokenChanges()
	tokens := make([]string, 0, len(tokenChanges))
	for k := range tokenChanges {
		tokens = append(tokens, k)
	}

	switch txType {
	case Send:
		return fmt.Sprintf("Sent %s %s", tokenChanges[tokens[0]].Neg(tokenChanges[tokens[0]]).String(), tokens[0])
	case Receive:
		return fmt.Sprintf("Received %s %s", tokenChanges[tokens[0]].String(), tokens[0])
	case Wrap:
		return fmt.Sprintf("Wrapped %s ETH to WETH", c.ExternalTx.Value.Int().String())
	case Unwrap:
		return fmt.Sprintf("Unwrapped WETH to %s ETH", c.InternalTxs[0].Value.Int().String())
	case Swap:
		return "Swap Token"
	case ContractExecution:
		return "Executed a contract"
	default:
		return "Unknown transaction type"
	}
}
