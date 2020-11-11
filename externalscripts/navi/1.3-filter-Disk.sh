#!/bin/bash

FILE="/tmp/VNX-Disks.log"

echo "" > /tmp/STATUS-VNX-Disks-Parsed.log

while IFS= read -r line
do
	if [[ -z $line ]]; then
                printf "\n" >> /tmp/STATUS-VNX-Disks-Parsed.log

        elif [[ $line = *"Bus"* ]]; then
		bus=$(echo $line | grep "Bus" | awk '{print $1$2"_"$3$4"_"$5$6}')
		echo $bus >> /tmp/STATUS-VNX-Disks-Parsed.log

	elif [[ $line = *"State"* ]]; then
		state=$(echo $line| cut -d":" -f2)
		echo $state >> /tmp/STATUS-VNX-Disks-Parsed.log		
		
	fi 
done < $FILE
		
