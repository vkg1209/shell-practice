#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR=$1
DESTINATION_DIR=$2
DAYS=${3:-14}

FILE_COUNT=0

#Script Usage Syntax
USAGE(){
    echo -e "$R USAGE:: $N sudo sh 24-backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS>[optional, default 14 days]"
    exit 1
}

# Check SOURCE_DIR and DEST_DIR passed or not
if [ $# -lt 2 ]; then
    USAGE
fi

# Checking if the source directory exists, if not then exit
if [ -d $SOURCE_DIR ]; then
    echo -e "Source Directory ... $G FOUND $N"
else
    echo -e "Source Directory ... $R NOT FOUND $N"
    exit 1
fi

# Checking if the destination directory exists, if not then exit
if [ -d $DESTINATION_DIR ]; then
    echo -e "Destination Directory ... $G FOUND $N"
else
    echo -e "Destination Directory ... $R NOT FOUND $N"
    exit 1
fi

# Checking if the Days are not less than 0 (delete today files if it is 0) exit if days < 0
if [ $DAYS -lt 0 ]; then
    echo -e "$R We cant delete $Y $DAYS $R days old logs ... $Y Days should be greater than or equal to 0 $N"
    exit 1
fi

# Finding all the files from the source directory which are N days old
FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

# Counting the number of files found
while IFS= read -r filepath
do
    FILE_COUNT=$(($FILE_COUNT + 1))
done <<< $FILES_TO_DELETE

echo -e "Files Found $Y $FILE_COUNT $N"

# Helper Functions

zip_file_name() {
    TIMESTAMP=$(date +%F-%H-%M)
    ZIP_FILE_NAME="$DESTINATION_DIR/apps-logs-$TIMESTAMP.zip"
}

delete_files() {
    while IFS= read -r filepath
    do
        rm -rf $filepath
        echo -e "Deleting the file: $filepath $G SUCCESS $N"
    done <<< $FILES_TO_DELETE
}

check_archive_status() {
    if [ -f $1 ]; then
        echo -e "Archieval ... $G SUCCESS $N"
    else
        echo -e "Archieval ... $R FAILURE $N"
        exit 1
}


# Zipping the file and deleting the source files
if [ ! -z "${FILES_TO_DELETE}" ]; then
    ZIP_FILE_NAME=$(zip_file_name)
    find $FILES_TO_DELETE | zip -@ -j $ZIP_FILE_NAME
    check_archive_status
    delete_files
else
    echo -e "No Files to Archive or Backup ... $Y SKIPPING $N"
fi

