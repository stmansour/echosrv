#!/bin/bash
# tester for echosrv

testit() {
	./echosrv_test >test.log
	N=$(tail -n 1 test.log | grep Passed | wc -l) 
	if [ ${N} -eq 1 ]; then
		echo "PASS"
		rm -f test.log
		exit 0
	else
		echo "FAIL"
		exit 1
	fi
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
	*)
		echo "Unrecognized command: $arg"
		exit 1
		;;
    esac
done
