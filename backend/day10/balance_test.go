package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGetWalletBalance(t *testing.T) {
	GetWalletBalance("0x4Ed97d6470f5121a8E02498eA37A50987DA0eEC0")
	assert.True(t, true)
}
