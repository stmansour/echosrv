#!/bin/bash
# tester for echosrv

TESTRESULTS="testresults.txt"
TESTSTART="teststart.txt"
usage() {
    cat << ZZEOF

Usage:   activate.sh cmd
cmd is one of: start | stop | ready | test | teststatus

cmd is case insensitive

Examples:
Command to start application:
	bash$  activate.sh START 

Command to stop the application on port 8200:
	bash$  activate.sh Stop

ZZEOF

	exit 0
}

PassFail() {
	C=$(tail -n 1 test.log | grep Passed | wc -l) 
	if [ ${C} -eq 1 ]; then
		echo "PASS" > ${TESTRESULTS}
		rm -f test.log
	else
		echo "FAIL" > ${TESTRESULTS}
	fi
}

init() {
	date > ${TESTSTART}
	sleep 1
	rm -f ${TESTRESULTS}
}

citestit() {
	init
	N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
	if [ ${N} -eq 0 ]; then
		../echosrv/echosrv >echosrv.log 2>&1 &
	fi
	./echosrv_test > test.log
	if [ ${N} -eq 0 ]; then
		pushd ../echosrv;./activate.sh STOP;popd
	fi
	PassFail
}

testit() {
	init
	./echosrv_test >test.log
	PassFail
}

while getopts ":p:ih:" o; do
    case "${o}" in
        h)
            usage
            ;;
        p)
            PORT=${OPTARG}
	    echo "PORT set to: ${PORT}"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

for arg do
	cmd=$(echo ${arg}|tr "[:upper:]" "[:lower:]")
    case "${cmd}" in
	"start")
		echo "OK" 
		;;
	"stop")
		echo "OK"
		;;
	"ready")
		echo "OK"
		;;
	"test")
		testit
		;;
	"teststatus")
		if [ -f ${TESTSTART} ]; then
			if [ -f ${TESTRESULTS} ]; then
				if [[ ${TESTRESULTS} -nt ${TESTSTART} ]]; then
					echo "DONE"
					exit 0
				fi
			fi
			echo "TESTING"
		else
			echo "ERROR not testing"
		fi
		;;
	"testresults")
		if [ -f "${TESTRESULTS}" ]; then
			cat ${TESTRESULTS}
		else
			echo "ERROR No test results"
		fi
		;;
	"citest")
		citestit
		;;
	*)
		echo "Unrecognized command: ${cmd}"
		exit 1
		;;
    esac
done
exit 0
