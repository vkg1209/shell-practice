#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_UTIL=$(df -hT | grep -v Filesystem)
DISK_THRESHOLD=1
IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
MESSAGE_BODY=""

while IFS= read -r line
do
    USAGE=$( echo $DISK_UTIL | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo $DISK_UTIL | awk '{print $2}')

    if [ $USAGE -gt "$DISK_THRESHOLD" ]; then
        MESSAGE_BODY+="High Disk Usage: $USAGE%"
    fi
    echo $MESSAGE_BODY
done <<< $DISK_UTIL

echo $MESSAGE_BODY