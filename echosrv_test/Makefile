ACCORDBIN=/usr/local/accord/bin

all: clean build package
	@echo "*** COMPLETED ***"

.PHONY:  test

install: package
	@echo "*** INSTALL COMPLETED ***"

build: *.go
	# go fmt
	/usr/local/accord/bin/govet.sh
	gl=$(which golint);if [ "x${gl}" != "x" ]; then golint; fi
	go build
	@echo "*** BUILD COMPLETED ***"

clean:
	go clean
	rm -f *.log *.txt
	@echo "*** CLEAN COMPLETE ***"

test:
	echo "please package and run tests in package dir"

package:
	mkdir -p ../package/echosrv_test
	cp activate.sh echosrv_test ../package/echosrv_test/
