#!/bin/bash
# activation script for tgo

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
	cmd=$(echo ${arg}|tr "[:upper:]" "[:lower:]")
    case "$cmd" in
	"start")
		#===============================================
		# START
		# Add the command to start your application...
		#===============================================
		./echosrv >echosrv.log 2>&1 &
		echo "OK"
		exit 0
		;;
	"stop")
		#===============================================
		# STOP
		# Add the command to terminate your application...
		#===============================================
		N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
		if [ ${N} -gt 0 ]; then
			pkill echosrv
			N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
			if [ ${N} -gt 0 ]; then
				echo "ERROR still ${N} running instances of echosrv"
				exit 0
			else
				echo "OK"
				exit 0
			fi
		fi
		echo "OK"
		exit 0
		;;
	"ready")
		#===============================================
		# READY
		# Is your application ready to receive commands?
		#===============================================
		# a self-check would be best, such as the tryit
		# function above. But a simple implementation is
		# just to make sure it's running. For this app,
		# if it's running, we assume it's ready.
		N=$(ps -ef|grep echosrv|grep -v grep|wc -l)
		if [ ${N} -gt 0 ]; then
			echo "OK"
			exit 0
		else
			echo "ERROR not ready"
			exit 1
		fi
		;;
	*)
		echo "Unrecognized command: $arg"
		usage
		;;
    esac
done
