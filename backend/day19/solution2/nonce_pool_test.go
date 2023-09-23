package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNoncePool(t *testing.T) {
	pool := NewNoncePool(0)
	assert.Equal(t, int64(0), pool.GetNonce())
	assert.Equal(t, int64(1), pool.GetNonce())
	assert.Equal(t, int64(2), pool.GetNonce())
	pool.ReturnNonce(0)
	assert.Equal(t, int64(0), pool.GetNonce())
	assert.Equal(t, int64(3), pool.GetNonce())
	assert.Equal(t, int64(4), pool.GetNonce())
	pool.ReturnNonce(3)
	pool.ReturnNonce(1)
	assert.Equal(t, int64(1), pool.GetNonce())
	assert.Equal(t, int64(3), pool.GetNonce())
	assert.Equal(t, int64(5), pool.GetNonce())
}
