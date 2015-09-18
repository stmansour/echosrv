all: clean build package test
	@echo "*** COMPLETED ***"

.PHONY:  test

install: package
	@echo "*** INSTALL COMPLETED ***"

build: 
	cd echosrv;make build
	cd echosrv_test;make build
	@echo "*** BUILD COMPLETED ***"

clean:
	cd echosrv;make clean
	cd echosrv_test;make clean
	rm -rf package
	@echo "*** CLEAN COMPLETE ***"

test:
	./dotest.sh
	@echo "*** TEST COMPLETE ***"


package:
	cd ./echosrv;make package
	cd ./echosrv_test;make package
	cd ./package;tar cvf echosrv.tar echosrv echosrv_test;gzip echosrv.tar

publish:
	cd ./package;/usr/local/accord/bin/deployfile.sh echosrv.tar.gz jenkins-snapshot/echosrv/latest

