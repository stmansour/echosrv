#!/bin/bash
# tester for echosrv

exitPassFail() {
	C=$(tail -n 1 test.log | grep Passed | wc -l) 
	if [ ${C} -eq 1 ]; then
		echo "PASS"
		rm -f test.log
		exit 0
	else
		echo "FAIL"
		exit 1
	fi
}

citestit() {
	N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
	if [ ${N} -eq 0 ]; then
		../echosrv/echosrv >echosrv.log 2>&1 &
	fi
	./echosrv_test > test.log
	if [ ${N} -eq 0 ]; then
		pushd ../echosrv;./activate.sh STOP;popd
	fi
	exitPassFail
}

testit() {
	./echosrv_test >test.log
	exitPassFail
}

for arg do
	# echo '--> '"\`$arg'"
    case "$arg" in
	"START")
		./echosrv_test >test.log
		;;
	"STOP")
		# nothing to do
		exit 0
		;;
	"READY")
		# always ready :-)
		exit 0
		;;
	"TEST")
		testit
		;;
	"CITEST")
		citestit
		;;
	*)
		echo "Unrecognized command: $arg"
		exit 1
		;;
    esac
done
