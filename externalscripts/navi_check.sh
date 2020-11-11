#!/bin/bash

option1=$1
option2=$2
option3=$3
option4=$4

LUNFILE="/tmp/lun.json"
PROCFILE1="/usr/lib/zabbix/externalscripts/navi/SP1.json"
PROCFILE2="/usr/lib/zabbix/externalscripts/navi/SP2.json"

case $option1 in 
     lun)
	case $option2 in
	     status)
		lunstatus=$(cat $LUNFILE | grep -B2 $option3 | grep Status | awk '{print $3}'| cut -d"\"" -f1 | awk 'NR==1{print $1}')
		echo $lunstatus
		;;
	     perf)
		lunperf=$(cat $LUNFILE | grep -A6 $option3 | grep Perf | awk '{print $3}'| cut -d"\"" -f1 | awk 'NR==1{print $1}')
		echo $lunperf
		;;
	     conc)
		lunconc=$(cat $LUNFILE | grep -A6 $option3 | grep Perf | awk '{print $3}'| cut -d"\"" -f1 | awk 'NR==1{print $1}')
		echo $lunconc
		;;
	 esac
	 ;;
     process)
	case $option2 in
	    utilization)
		case $option3 in
			CS1-PROD-SPA)
				procutil1=$(/usr/lib/zabbix/externalscripts/navi/procutil.sh CS1-PROD-SPA)
				echo $procutil1
			;;
			CS1-PROD-SPB)
				procutil1=$(/usr/lib/zabbix/externalscripts/navi/procutil.sh CS1-PROD-SPB)
				echo $procutil1
			;;
			CS1-BKP-SPA)
				procutil1=$(/usr/lib/zabbix/externalscripts/navi/procutil.sh CS1-BKP-SPA)
				echo $procutil1
			;;
			CS1-BKP-SPB)
				procutil1=$(/usr/lib/zabbix/externalscripts/navi/procutil.sh CS1-BKP-SPB)
				echo $procutil1
			;;
		esac
		;;
	esac
	;;
     disk)
	case $option2 in
            state)
		statedisk=$(cat /tmp/VNX-DISKS-Status.csv | grep $option3 | cut -d";" -f2 | awk 'NR==1')
		echo $statedisk
		;;
	esac
	;;
esac

