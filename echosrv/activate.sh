#!/bin/bash
# activation script for tgo

usage() {
    cat << ZZEOF

Usage:   activate.sh cmd
cmd is one of: START | STOP | READY | TEST

Examples:
Command to start application:
	bash$  activate.sh START 

Command to stop the application on port 8081:
	bash$  activate.sh STOP

ZZEOF

	exit 0
}

tryit() {
	echo "logs before: ";ls *.log
	host=$(hostname)
	netcat ${host} 8200 <<EOF >t.log 2>&1 &
hello
EOF
	kill $!
	sleep 1
	echo "logs after: ";ls *.log
	if [ ! -e t.log ]; then
		echo "t.log not found.  FAIL."
		exit 1
	fi
	if [ "hello" == $(cat t.log) ]; then
		echo "PASS"
		rm t.log
		exit 0
	else
		echo "FAIL"
		exit 1
	fi
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
	# echo '--> '"\`$arg'"
    case "$arg" in
	"START")
		./echosrv >echosrv.log 2>&1 &
		echo "echosrv started, PID = $!"
		exit 0
		;;
	"STOP")
		N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
		if [ ${N} -gt 0 ]; then
			pkill echosrv
			N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
			if [ ${N} -gt 0 ]; then
				echo "Still ${N} running instances of echosrv"
				exit 1
			else
				echo "echosrv stopped"
				exit 0
			fi
		fi
		echo "echosrv is not running"
		exit 0
		;;
	"READY")
		N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
		if [ ${N} -gt 0 ]; then
			echo "Yes"
			exit 0
		else
			echo "NO"
			exit 1
		fi
		;;
	"TEST")
		echo "TEST"
		tryit
		;;
	*)
		echo "Unrecognized command: $arg"
		usage
		;;
    esac
done
