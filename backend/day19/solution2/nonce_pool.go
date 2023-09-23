package main

import (
	"container/heap"
	"sync"
)

type IntHeap []int64

func (h IntHeap) Len() int           { return len(h) }
func (h IntHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *IntHeap) Push(x interface{}) {
	*h = append(*h, x.(int64))
}
func (h *IntHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

type NoncePool struct {
	nonces IntHeap
	lock   sync.Mutex
}

func NewNoncePool(initialNonce int64) *NoncePool {
	pool := &NoncePool{}
	heap.Init(&pool.nonces)
	heap.Push(&pool.nonces, initialNonce)
	return pool
}

func (n *NoncePool) GetNonce() int64 {
	n.lock.Lock()
	defer n.lock.Unlock()

	// Get min nonce
	nonce := heap.Pop(&n.nonces).(int64)
	if n.nonces.Len() == 0 {
		// Add next nonce if nonce pool is empty
		heap.Push(&n.nonces, nonce+1)
	}
	return nonce
}

func (n *NoncePool) ReturnNonce(returnedNonce int64) {
	n.lock.Lock()
	defer n.lock.Unlock()

	heap.Push(&n.nonces, returnedNonce)
}
