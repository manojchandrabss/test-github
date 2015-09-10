#!/bin/sh
# post-receive hook that syncs with S3 upon a push

S3_BUCKET=git-hub-192.168.0.1
TEMP_DEPLOY_DIR=/tmp/$S3_BUCKET/

# Ensure that the temporary directory is clean and unset potential conflicting
# environment variables
rm -rf $TEMP_DEPLOY_DIR
unset GIT_DIR
unset GIT_WORK_TREE

# Create a working tree with a bare repo that does not have submodules
mkdir -p $TEMP_DEPLOY_DIR
export GIT_DIR=$(pwd)
export GIT_WORK_TREE=$TEMP_DEPLOY_DIR
git checkout -f
cd $TEMP_DEPLOY_DIR

# If the repo has submodules, comment out ore remove the above and uncomment the below:
#
# git clone $(pwd) $TEMP_DEPLOY_DIR
# cd $TEMP_DEPLOY_DIR
# git submodule update --init --recursive

# Sync with S3
s3cmd sync --delete-removed --acl-public --exclude '.git/*' ./ s3://$S3_BUCKET/

