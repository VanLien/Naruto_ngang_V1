package util

import (
	"crypto/aes"
	"crypto/cipher"
)

// AES CBC
func AESCBCEncrypter(plaintext, key, iv []byte) ([]byte, error) {
	if len(plaintext)%aes.BlockSize != 0 {
		panic("plaintext is not a multiple of the block size")
	}
	if len(key) == 0 {
		panic("key is empty")
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	ciphertext := make([]byte, len(plaintext))
	model := cipher.NewCBCEncrypter(block, iv)
	model.CryptBlocks(ciphertext, plaintext)
	return ciphertext, nil
}

func AESCBCDecrypter(ciphertext, key, iv []byte) ([]byte, error) {
	if len(ciphertext)%aes.BlockSize != 0 {
		panic("ciphertext is not a multiple of the block size")
	}
	if len(key) == 0 {
		panic("key is empty")
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	plaintext := make([]byte, len(ciphertext))
	model := cipher.NewCBCDecrypter(block, iv)
	model.CryptBlocks(plaintext, ciphertext)
	return plaintext, nil
}
