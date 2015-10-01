package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"
)

var port int

// simple admin capability on port+1
// send "shutdown" to stop the service (unceremoniously)
func echoAdmin(h string, p int) {
	hp := fmt.Sprintf("%s:%d", h, p)
	lstnr, _ := net.Listen("tcp", hp)
	conn, _ := lstnr.Accept()
	for {
		b, _ := bufio.NewReader(conn).ReadString('\n')
		s := string(b)
		s = strings.TrimRight(s, "\n\r")
		fmt.Printf("read: %s, len=%d\n", s, len(s))
		if "shutdown" == s {
			fmt.Printf("shutting down now.  Bye!\n")
			os.Exit(0)
		}
	}
}

func main() {
	port = 8200
	h, _ := os.Hostname()
	pPtr := flag.Int("p", port, "echosrv port")
	flag.Parse()
	port = *pPtr
	hp := fmt.Sprintf("%s:%d", h, port)
	fmt.Printf("echosrv listening on %s\n", hp)

	go echoAdmin(h, port+1)
	lstnr, err := net.Listen("tcp", hp)
	if nil != err {
		fmt.Printf("echosrv listening on %s:  %s\n", hp, err)
		os.Exit(1)
	}

	for {
		conn, err := lstnr.Accept()
		if nil != err {
			log.Fatal(err)
		}
		go io.Copy(conn, conn)
	}
}
