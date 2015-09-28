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
	cd ./package;tar cvf echosrv.tar echosrv;gzip echosrv.tar
	cd ./package;tar cvf echosrv_test.tar echosrv_test;gzip echosrv_test.tar

publish:
	cd ./package;/usr/local/accord/bin/deployfile.sh echosrv.tar.gz jenkins-snapshot/echosrv/latest
	cd ./package;/usr/local/accord/bin/deployfile.sh echosrv_test.tar.gz jenkins-snapshot/echosrv_test/latest

