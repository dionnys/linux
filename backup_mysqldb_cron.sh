#!/bin/bash

# MySQL credentials for connection
 user="root"
 password="secretPassword"
 host="localhost"

# WARNING: Never user the root "/" as backup_path
# This folder must be exist:
 backup_path="/backups"

# The maximum of backups to keep
# (the oldest backups will be erased)
 maximum_backup_folders=5

# Create a folder using actual date to storage the backup
 date=$(date +"%Y-%m-%d")
 mkdir $backup_path/$date

# Get a list of all databases in MySQL
 databases=$(mysql --user=$user --password=$password -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|mysql|sys|performance_schema)")

# Create a file dumps for each database
 for db in $databases
  do
   mysqldump --user=$user --password=$password --host=$host $db | gzip -9 > $backup_path/$date/$db.sql.gz
 done

# Remove the oldest backups
 total_backup_folders=$(ls -tr $backup_path | wc -l)
 if [ $total_backup_folders -gt $maximum_backup_folders ];then
  to_delete=$(( $total_backup_folders - $maximum_backup_folders ));
  for delete_folder in $(ls -tr $backup_path | head -$to_delete);
   do
    rm -rf $backup_path/$delete_folder;
  done
 fi;
