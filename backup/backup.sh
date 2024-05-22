#!/bin/bash

SOURCE_PATH=$1 # path to folder/file to zip
BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).zip"
REMOTE_USER=$2 # targer server username 
REMOTE_HOST=$3 # target ip server
IDENTITY_KEY=$4 # path to public key
TARGET_PATH="~/backup/$BACKUP_NAME"
LOG_FILE="/var/log/backup_script.log" # local path to log file

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# check if all arguments are listed
if [ $# -ne 4 ]; then
    echo -e "You have to specify all arguments!\n$0 [SOURCE_PATH] [REMOTE_USER] [REMOTE_HOST] [IDENTITY_KEY]"
    log "Error: Not all the required arguments were provided."
    exit 1
fi

# creating backup zip
zip -r $BACKUP_NAME $SOURCE_PATH
if [ $? -ne 0 ]; then
    log "Error: Failed to create $BACKUP_NAME."
    exit 1
else
    log "Success: Created $BACKUP_NAME."
fi

# send backup to target server
rsync -avz --delete -e "ssh -i $IDENTITY_KEY" $BACKUP_NAME $REMOTE_USER@$REMOTE_HOST:$TARGET_PATH
# scp -r -i $IDENTITY_KEY $BACKUP_NAME $REMOTE_USER@$REMOTE_HOST:$TARGET_PATH
if [ $? -ne 0 ]; then
    log "Error: Failed to send backup folder to the target server."
    exit 1
else
    log "Success: Backup has been sent."
fi

# remove local backup folder
rm $BACKUP_NAME
if [ $? -ne 0 ]; then
    log "Error: Failed to delete $BACKUP_NAME."
else
    log "Success: Local $BACKUP_NAME has been deleted."
fi

exit 0