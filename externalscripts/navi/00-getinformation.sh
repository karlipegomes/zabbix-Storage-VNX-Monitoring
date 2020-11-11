#!/bin/bash


#### Lun Information 
naviseccli -h <primary_IP> -User sysadmin -Password sysadmin -Scope 0 -f /tmp/STATUS-VNX-LUN.log lun -list

######### Pegando Informacoes com NAVISECCLI
### SP
naviseccli -h <primary_IP> -User sysadmin -Password sysadmin -Scope 0 -f /usr/lib/zabbix/externalscripts/navi/CS1-PROD-SPA.log getcontrol -cbt
naviseccli -h <secondary_IP> -User sysadmin -Password sysadmin -Scope 0 -f /usr/lib/zabbix/externalscripts/navi/CS1-PROD-SPB.log getcontrol -cbt
naviseccli -h <bkp-primary_IP> -User sysadmin -Password sysadmin -Scope 0 -f /usr/lib/zabbix/externalscripts/navi/CS1-BKP-SPA.log getcontrol -cbt
naviseccli -h <bkp-secondary_IP> -User sysadmin -Password sysadmin -Scope 0 -f /usr/lib/zabbix/externalscripts/navi/CS1-BKP-SPB.log getcontrol -cbt
### Discos
naviseccli -h <primary_IP> -User sysadmin -Password sysadmin -Scope 0 -f /tmp/VNX-Disks.log getdisk -state 

######### Scripts de Filtros
### LUN/SP
bash /usr/lib/zabbix/externalscripts/navi/1.2-filter.sh
### Discos
bash /usr/lib/zabbix/externalscripts/navi/1.3-filter-Disk.sh 

######### Texto para CSV
bash /usr/lib/zabbix/externalscripts/navi/2-text2csv.sh 

######### Scritps para filtro dos Discos
python /usr/lib/zabbix/externalscripts/navi/3-csvtojson.py -i /tmp/VNX-LUN-Status.csv -o /tmp/lun.json -f pretty
python /usr/lib/zabbix/externalscripts/navi/3-csvtojson.py -i /tmp/VNX-DISKS-Status.csv -o /tmp/disk.json -f pretty 


