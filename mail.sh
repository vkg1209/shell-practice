#!/bin/bash


TO_ADDRESS=$1
SUBJECT=$2
FINAL_BODY=$3
IP_ADDRESS=$4
ALERT_TYPE=$5
TEAM=$6

FINAL_BODY=$(sed -e "s/Team/$TEAM/" -e "s/ALERT_TYPE/$ALERT_TYPE/" -e "s/IP_ADDRESS/$IP_ADDRESS/" -e "s/MESSAGE/$FINAL_BODY/" ./template.html)


{
echo "To: $TO_ADDRESS"
echo "Subject: $SUBJECT"
echo "Content-Type: text/html"
echo ""
echo "$FINAL_BODY"
} | msmtp "$TO_ADDRESS"