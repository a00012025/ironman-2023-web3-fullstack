package main

import (
	"fmt"
	"log"

	"github.com/go-resty/resty/v2"
)

type AccountPortfolioResp struct {
	AccountAddress string         `json:"accountAddress"`
	ChainID        int            `json:"chainId"`
	NativeBalance  TokenBalance   `json:"nativeBalance"`
	TokenBalances  []TokenBalance `json:"tokenBalances"`
	Value          struct {
		Currency    string  `json:"currency"`
		MarketValue float64 `json:"marketValue"`
	}
}

type TokenBalance struct {
	Address     string  `json:"address"`
	Name        string  `json:"name"`
	Symbol      string  `json:"symbol"`
	IconURL     string  `json:"iconUrl"`
	CoingeckoID string  `json:"coingeckoId"`
	Balance     float64 `json:"balance"`
}

func AccountPortfolio(address string) (*AccountPortfolioResp, error) {
	respData := AccountPortfolioResp{}
	_, err := resty.New().
		SetBaseURL("https://account.metafi.codefi.network").R().
		SetPathParam("address", address).
		SetQueryParam("chainId", "1").
		SetQueryParam("includePrices", "true").
		SetHeader("Referer", "https://portfolio.metamask.io/").
		SetResult(&respData).
		Get("/accounts/{address}")

	if err != nil {
		return nil, err
	}

	return &respData, nil
}

func GetWalletBalance(address string) {
	resp, err := AccountPortfolio(address)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Account address: %s\n", resp.AccountAddress)
	fmt.Printf("Chain ID: %d\n", resp.ChainID)
	fmt.Printf("ETH balance: %f\n", resp.NativeBalance.Balance)
	for _, token := range resp.TokenBalances {
		fmt.Printf("Token balance of %s: %f\n", token.Name, token.Balance)
	}
}
