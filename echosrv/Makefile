all: clean build
	@echo "*** COMPLETED ***"

.PHONY:  test

install: package
	@echo "*** INSTALL COMPLETED ***"

build: *.go
	go fmt
	go vet
	go build
	@echo "*** BUILD COMPLETED ***"

clean:
	go clean
	rm -f *.log *_pid
	@echo "*** CLEAN COMPLETE ***"

test:
	echo "please package and run tests in package dir"

coverage:
	go test -coverprofile=c.out
	go tool cover -func=c.out
	go tool cover -html=c.out

package:
	mkdir -p ../package/echosrv
	cp activate.sh echosrv ../package/echosrv/