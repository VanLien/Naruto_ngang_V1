package util

import (
	"bytes"
	"compress/gzip"
)

func GZipCompress(src []byte) ([]byte, error) {
	buf := &bytes.Buffer{}
	w := gzip.NewWriter(buf)
	if _, err := w.Write(src); err != nil {
		return nil, err
	}
	if err := w.Close(); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

func GZipDecompress(src []byte) ([]byte, error) {
	buf := &bytes.Buffer{}
	r, err := gzip.NewReader(buf)
	if err != nil {
		return nil, err
	}
	if _, err := r.Read(src); err != nil {
		return nil, err
	}
	if err := r.Close(); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
