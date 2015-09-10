#!/bin/bash

S3_NAME=git-hub-192.168.0.1
BACKUP_DIR=/home/manojc/test-github/s3backup
password=March181987
account=manojchandrabss
repository=test-github

date=`date '+%Y%m%d%H%M%S'`

mkdir -p $BACKUP_DIR

echo "============Backing up $repository=============="

git clone --mirror https://github.com/$account/$repository.git $BACKUP_DIR/$repository.$date.git

if [ $? -ne 0 ]; then
    echo "==========Error cloning $repository==========="
    exit 1

else
    echo "===========clone is successfull=========="
    fi

tar cpzf $BACKUP_DIR/$repository.$date.git.tar.gz $BACKUP_DIR/$repository.$date.git
if [ $? -ne 0 ]; then
    echo "=========Error compressing $repository==========="
    exit 1
else
    echo "===========compress is successfull========="
fi

echo "========moving Repository to S3-Bucket========="

if [ -f $BACKUP_DIR/$repository.$date.git.tar.gz ]; then
    s3cmd put $BACKUP_DIR/$repository.$date.git.tar.gz s3://$S3_NAME/git.$repository.$date.git.tar.gz
fi

if [ $? -ne 0 ]; then
    echo "Error uploading $repository to S3"
    exit 1
else
    echo "===========uploading successfully completed=========="
fi

#delete tar file and checked out folder
# /bin/rm $BACKUP_DIR/$repository.$date.git.tar.gz
# /bin/rm -rf $BACKUP_DIR/$repository.$date.git
# if [ $? -ne 0 ]; then
#  echo "Error removing $repository"
#   exit 1
#  fi

echo "=========Succesfully backed up $repository==========="
