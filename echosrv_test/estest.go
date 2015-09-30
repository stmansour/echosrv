package main

import (
	"bufio"
	"flag"
	"fmt"
	"net"
	"os"
	"strings"
)

const port = 8200

func main() {
	h, _ := os.Hostname()
	hptr := flag.String("h", h, "echosrv host")
	pPtr := flag.Int("p", port, "echosrv port")
	flag.Parse()
	fmt.Printf("Host = %s, port = %d\n", *hptr, *pPtr)
	hp := fmt.Sprintf("%s:%d", *hptr, *pPtr)

	// test 1
	conn, err := net.Dial("tcp", hp)
	if nil != err {
		fmt.Printf("Error trying to connect to %s:  %v", hp, err)
		os.Exit(1)
	}
	fmt.Fprint(conn, "hello\n")
	b, _ := bufio.NewReader(conn).ReadString('\n')
	s := string(b)
	s = strings.TrimRight(s, "\n\r")
	fmt.Printf("read: %s, len=%d\n", s, len(s))
	if "hello" == s {
		fmt.Printf("test 1 - Passed\n")
	} else {
		fmt.Printf("test 1 - Failed\n")
	}
	conn.Close()
}
