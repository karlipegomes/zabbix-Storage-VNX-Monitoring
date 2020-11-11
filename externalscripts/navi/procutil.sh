#!/bin/bash

if [[ $1 = *"CS1-PROD-SPA"* ]];then
	busy=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-PROD-SPA.log | awk 'NR==1{print $4}')
	idle=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-PROD-SPA.log | awk 'NR==2{print $4}')
	sum=$(( $busy+$idle ))
	procutil1=$(( 100*$busy  / $sum ))
	echo $procutil1
elif [[ $1 = *"CS1-PROD-SPB"* ]];then
	busy=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-PROD-SPB.log | awk 'NR==1{print $4}')
	idle=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-PROD-SPB.log | awk 'NR==2{print $4}')
	sum=$(( $busy+$idle ))
	procutil1=$(( 100*$busy  / $sum ))
	echo $procutil1
elif [[ $1 = *"CS1-BKP-SPA"* ]];then
	busy=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-BKP-SPA.log | awk 'NR==1{print $4}')
	idle=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-BKP-SPA.log | awk 'NR==2{print $4}')
	sum=$(( $busy+$idle ))
	procutil1=$(( 100*$busy  / $sum ))
	echo $procutil1
elif [[ $1 = *"CS1-BKP-SPB"* ]];then
	busy=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-BKP-SPB.log | awk 'NR==1{print $4}')
	idle=$(cat /usr/lib/zabbix/externalscripts/navi/CS1-BKP-SPB.log | awk 'NR==2{print $4}')
	sum=$(( $busy+$idle ))
	procutil1=$(( 100*$busy  / $sum ))
	echo $procutil1
else
	echo error
fi
