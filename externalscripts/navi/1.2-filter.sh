#!/bin/bash

FILE="/tmp/STATUS-VNX-LUN.log"

echo "" > /tmp/STATUS-VNX-LUN-Parsed.log
 
while IFS= read -r line
do
        if [[ -z $line ]]; then
                printf "\n" >> /tmp/STATUS-VNX-LUN-Parsed.log

        elif [[ $line = *"LOGICAL UNIT NUMBER"* ]]; then
                echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log 

        elif [[ $line = *"Name"* ]]; then
		echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log

        elif [[ $line = *"User Capacity (Blocks)"* ]]; then
                echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log 

        elif [[ $line = *"User Capacity (GBs)"* ]]; then
		echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log

        elif [[ $line = *"Consumed Capacity (Blocks)"* ]]; then
                echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log 

        elif [[ $line = *"Consumed Capacity (GBs)"* ]]; then
		echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log

        elif [[ $line = *"Current State"* ]]; then
                echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log 

        elif [[ $line = *"Status"* ]]; then
		echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log

        elif [[ $line = *"Performance"* ]]; then
                echo $line >>  /tmp/STATUS-VNX-LUN-Parsed.log 

        fi

done < $FILE

sed -i '/Extreme Performance/d' /tmp/STATUS-VNX-LUN-Parsed.log
sed -i '/Current Operation Status/d' /tmp/STATUS-VNX-LUN-Parsed.log

