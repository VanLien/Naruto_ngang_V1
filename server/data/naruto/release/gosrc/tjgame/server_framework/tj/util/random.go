package util

import (
	"math/rand"
	"os"
	"time"
)

type WeightElement interface {
	Weight() int
}

type WeightRandom struct {
	weights   []WeightElement
	weightsum int
}

func (r *WeightRandom) GetRandom() WeightElement {
	rnd := rand.Intn(r.weightsum) + 1
	for _, elem := range r.weights {
		rnd -= elem.Weight()
		if rnd <= 0 {
			return elem
		}
	}
	return nil
}

func (r *WeightRandom) GetRandomDrop() WeightElement {
	choose := -1
	var elem WeightElement
	rnd := rand.Intn(r.weightsum) + 1
	for i, e := range r.weights {
		rnd -= e.Weight()
		if rnd <= 0 {
			choose = i
			elem = e
			break
		}
	}
	if elem != nil {
		r.weightsum -= elem.Weight()
		r.weights = append(r.weights[:choose], r.weights[choose+1:]...)
	}
	return elem
}

func (r *WeightRandom) IsEmpty() bool {
	return len(r.weights) == 0
}

func NewWeightRandom(weights []WeightElement) *WeightRandom {
	w := make([]WeightElement, len(weights))
	copy(w, weights)
	r := &WeightRandom{
		weights:   w,
		weightsum: 0,
	}
	for _, elem := range r.weights {
		r.weightsum += elem.Weight()
	}
	if r.weightsum == 0 {
		panic("weight sum zero")
	}
	return r
}

func OnceRandom(weights []WeightElement) WeightElement {
	r := NewWeightRandom(weights)
	return r.GetRandom()
}

func OnceSimpleRandom(weights []WeightElement, num int) []WeightElement {
	r := NewWeightRandom(weights)
	ret := make([]WeightElement, 0, num)
	for i := 0; i < num; i++ {
		e := r.GetRandomDrop()
		if e != nil {
			ret = append(ret, e)
		}
	}
	return ret
}

func ReseedRandom() {
	rand.Seed((time.Now().Unix() * 1000) ^ int64(os.Getpid()))
}

type WeightInts [2]int

func (i WeightInts) Weight() int {
	return i[1]
}
