package main

import (
	"fmt"

	"golang.org/x/crypto/ssh"
)

func main() {
	fmt.Println("Hello, world!")
	var hostKey ssh.PublicKey
	fmt.Println("Hello, key! %S", hostKey)
}
