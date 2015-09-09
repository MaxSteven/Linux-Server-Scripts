#!/bin/bash

MYSQL_USER="<user>"
MYSQL_PASS="<password>"
BACKUP_DIR="/dir/to/backup/location"

# Get the database list, exclude information_schema
for db in $(mysql -B -s -u $MYSQL_USER --password=$MYSQL_PASS -e 'show databases' | grep -Ev 'information_schema|performance_schema|sitebuilder5|mysql|phpmyadmin' ); do
  # dump each database in a separate file
  echo "backup database: \"$db\""
  mysqldump -u $MYSQL_USER --password=$MYSQL_PASS --events --skip-lock-tables "$db" | gzip > "$BACKUP_DIR/${db}_$(date +%Y-%m-%d).sql.gz"
done

exit
