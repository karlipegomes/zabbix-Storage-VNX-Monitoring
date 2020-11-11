#!/bin/bash

FILE="/tmp/STATUS-VNX-LUN-Parsed.log"
echo "LUN-ID;Name;User Capacity (Blocks);User Capacity (GBs);Consumed Capacity (Blocks);Consumed Capacity (GBs);Pool Name;Current State;Status;Performance" > /tmp/VNX-LUN-Status.csv

FILEDISK="/tmp/STATUS-VNX-Disks-Parsed.log"
echo "DISKID;DISKSTATE" > /tmp/VNX-DISKS-Status.csv

i=0
declare -a array

while IFS= read -r line
do	
	if [[ -z $line ]]; then
                removesemicolon=$(echo ${array[9]}|cut -d'%' -f1)
                array[9]="$removesemicolon"

                echo ${array[*]} >> /tmp/VNX-LUN-Status.csv
                unset array     
                i=0
	else
		lunoption=$(echo $line | cut -d':' -f2| awk '{print}' ORS=';')
		array[i]="$lunoption"
		let i++
	fi

done < $FILE

d=0
declare -a arraydisk
while IFS= read -r linedisk
do
	if  [[ -z $linedisk ]]; then
                removesemicolon=$(echo ${arraydisk[1]}|cut -d';' -f1)
                arraydisk[1]="$removesemicolon"

                echo ${arraydisk[*]} >> /tmp/VNX-DISKS-Status.csv
                unset arraydisk     
                d=0
	else 
		diskoption=$(echo $linedisk | awk '{print}' ORS=';')
		arraydisk[d]="$diskoption"
		let d++
		
	fi

done < $FILEDISK
