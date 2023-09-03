package main

import (
	"fmt"
	"strings"

	"github.com/ethereum/go-ethereum/accounts"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/spruceid/siwe-go"
)

// VerifySignature checks the signature of the given message.
func VerifySignature(from, sigHex, msg string) error {
	// input validation
	sig, err := hexutil.Decode(sigHex)
	if err != nil {
		return fmt.Errorf("failed to decode signature: %v", err.Error())
	}
	if len(sig) != 65 {
		return fmt.Errorf("invalid Ethereum signature length: %v", len(sig))
	}
	if sig[64] != 27 && sig[64] != 28 {
		return fmt.Errorf("invalid Ethereum signature (V is not 27 or 28): %v", sig[64])
	}

	// calculate message hash
	msgHash := accounts.TextHash([]byte(msg))

	// recover public key from signature and verify it matches the from address
	sig[crypto.RecoveryIDOffset] -= 27 // Transform yellow paper V from 27/28 to 0/1
	recovered, err := crypto.SigToPub(msgHash, sig)
	if err != nil {
		return fmt.Errorf("failed to recover public key: %v", err.Error())
	}
	recoveredAddr := crypto.PubkeyToAddress(*recovered)
	if strings.EqualFold(from, recoveredAddr.Hex()) {
		return nil
	}
	return fmt.Errorf("invalid Ethereum signature (addresses don't match)")
}

// VerifySiweSignature checks the signature of the given SIWE message. It returns the nonce of the message if it's valid
func VerifySiweSignature(from, sigHex, msg, domain string) (string, error) {
	message, err := siwe.ParseMessage(msg)
	if err != nil {
		return "", fmt.Errorf("failed to parse SIWE message: %v", err.Error())
	}

	publicKey, err := message.Verify(sigHex, &domain, nil, nil)
	if err != nil {
		return "", fmt.Errorf("failed to verify signature: %v", err.Error())
	}

	recoveredAddr := crypto.PubkeyToAddress(*publicKey)
	if strings.EqualFold(from, recoveredAddr.Hex()) {
		return message.GetNonce(), nil
	}
	return "", fmt.Errorf("invalid Ethereum signature (addresses don't match)")
}
