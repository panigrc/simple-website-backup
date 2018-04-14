#!/bin/bash

# Default Configuration File
configfile="./website-backup.conf"

# Check for arguments
if [ ! -z "$1" ]
  then
    configfile=$1
fi

# Get the configuration file from argument
if [  ! -f "$configfile" ]; then
   echo "Configuration File $configfile does not exist."
   exit 1
fi


echo "Reading config...." >&2
source $configfile

# Create directory if doesn't exist
mkdir -p $output_path

if [ $website_backup -gt 0 ]; then
  echo "Backing up the Website" >&2

  rsync -avz -e "ssh -p $server_port -i $ssh_key" --progress $server_username@$server_host:$website_path $output_path

fi

if [ $db_backup -gt 0 ]; then
  echo "Backing up Database: $db_name" >&2

  # backup database from remote host
  ssh -p $server_port -i $ssh_key $server_username@$server_host "mysqldump -u $db_username -p$db_password $db_name | gzip > /tmp/db_backup.sql.gz"

  # get the db_backup.sql file from remote server
  rsync -avz -e "ssh -p $server_port -i $ssh_key" --progress $server_username@$server_host:/tmp/db_backup.sql.gz $output_path

  if [ $cleanup -gt 0 ]; then
    echo "Deleting Backup" >&2

    # remove the backup from remote host
    ssh -p $server_port -i $ssh_key $server_username@$server_host "rm -f /tmp/db_backup.sql.gz"
  fi

fi
