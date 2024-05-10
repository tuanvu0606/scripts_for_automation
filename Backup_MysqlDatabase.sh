#!/bin/bash
# ------------------------------- Backup mysqldump ---------------------------------------
# get to tmp folder on deployment server
cd /tmp/

i=$(expr $i + 1)

# Set file name
A=$(date +%M)
A=$((A/30*30))
B=$(date +"%y%m%d_%H%M%S")$A

PRODUCT=${ENV_PRODUCT}
MYSQL_ENV=${ENV_ENV}
SERVICE_NAME=${ENV_SERVICE_NAME}
FILE_NAME=${SERVICE_NAME}_${MYSQL_ENV}_backup_$B.sql
S3_BUCKET="techg-systemrank-backups-prod/"
BACKUP_FILE=/tmp/$FILE_NAME
PASSWORD=${ENV_MYSQL_PASSWORD}
DATABASE_NAME=${ENV_DATABASE_NAME}
CONTAINER_NAME=${ENV_CONTAINER_NAME}

# Get docker container name
DOCKER_CONTAINER=$(docker ps | grep ${CONTAINER_NAME} | awk '{print $1}')

echo ${DOCKER_CONTAINER}

# Dump the sql file to host /tmp
docker exec -i $DOCKER_CONTAINER /usr/bin/mysqldump -u root --password=${PASSWORD} ${DATABASE_NAME} > $BACKUP_FILE
if [ "${?}" -eq 0 ]; then
  sudo gzip $BACKUP_FILE
  aws s3 cp --profile funniq_s3 $BACKUP_FILE.gz s3://${S3_BUCKET}
  # rm $BACKUP_FILE.gz
else
  echo "Error backing up mysql"
  exit 255
fi
