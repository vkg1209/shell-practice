#!/bin/bash

TO_ADDRESS=$1
SUBJECT=$2
FINAL_BODY=$3

{
echo "To: $TO_ADDRESS"
echo "Subject: $SUBJECT"
echo "Content-Type: text/html"
echo ""
echo "$FINAL_BODY"
} | msmtp "$TO_ADDRESS"