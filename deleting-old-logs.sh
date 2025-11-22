#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR="."
FILE_COUNT=0

# Checking if the source directory exists, if not then exit
if [ -d $SOURCE_DIR ]; then
    echo -e "Source Directory ... $G FOUND $N"
else
    echo -e "Source DIrectory ... $R NOT FOUND $N"
    exit 1
fi

# Finding all the files from the source directory which are 14 days old
FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -type f -mtime +14)

# Counting the number of files found
while IFS= read -r filepath
do
    FILE_COUNT=$(($FILE_COUNT + 1))
done <<< $FILES_TO_DELETE

echo -e "Files Found $Y $FILE_COUNT $N"

# Deleting all the files
while IFS= read -r filepath
do
    rm -rf $filepath
    echo -e "Deleting the file: $filepath $G SUCCESS $N"
done <<< $FILES_TO_DELETE