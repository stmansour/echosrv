#!/bin/bash
# tester for echosrv

TESTRESULTS="testresults.txt"
TESTSTART="teststart.txt"
HOST="localhost"
PORT=8200
LOGFILE="test.log"
CILOGFILE="citest.log"

usage() {
    cat << ZZEOF

Usage:   activate.sh [OPTIONS] cmd
OPTIONS:
	-h host        // the hostname where echosrv is running
	-p port        // the port on which echosrv is listening
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
	C=$(tail -n 1 ${LOGFILE} | grep Passed | wc -l) 
	if [ ${C} -eq 1 ]; then
		echo "PASS" > ${TESTRESULTS}
		rm -f ${LOGFILE}
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
        date > ${CILOGFILE}
        if [ ${N} -eq 0 ]; then
                echo "echsrv not running. Will attempt to start it" >> ${CILOGFILE} &
                ../echosrv/echosrv >echosrv.log 2>&1 &
                sleep 1
                m=$(ps -ef|grep echosrv|grep -v grep|wc -l)
                echo "count of running echsrv(s) after starting it: ${m}" >> ${CILOGFILE}
        fi
        ./echosrv_test -h ${HOST} -p {PORT} > ${LOGFILE}
        if [ ${N} -eq 0 ]; then
                echo "stopping echosrv" >> ${CILOGFILE} &
                pushd ../echosrv;./activate.sh STOP;popd
        fi
        echo "calling standard pass/fail checker" >> ${CILOGFILE} &
        PassFail
}

testit() {
	init
	echo "./echosrv_test -h ${HOST} -p {PORT}" >${LOGFILE}
	./echosrv_test -h ${HOST} -p ${PORT} >${LOGFILE}
	PassFail
}

while getopts ":p:h:u" o; do
    case "${o}" in
        u)
            usage
            ;;
        h)
			HOST=${OPTARG}
			echo "HOST set to ${HOST}"
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
		echo "OK"
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
