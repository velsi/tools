#!/bin/bash

# Создание бэкапов сайтов на основе скрипта Битрикс /opt/webdir/bin/bx_backup.sh
#

BACKUP_DIR="/mnt/Deborah/backup"
TENANT=XXXX
USER="YYYY"
PASS="ZZZZ"
SELECTEL_CONTAINER = "QQQQ"

mkdir -p $BACKUP_DIR

while IFS= read db; do
    if [ "$db" != "Database" ] && [ "$db" != "information_schema" ] && [ "$db" != "mysql" ] && [ "$db" != "performance_schema" ]; then
        echo $db
        /opt/webdir/bin/bx_backup.sh $db $BACKUP_DIR && /bin/find $BACKUP_DIR -type f -name '*.gz' -print0 | xargs -0 -I {file1} sh -c "split -b 200M {file1} {file1}.part. && /bin/rm -f {file1}" && /bin/find $BACKUP_DIR -type f -name '*.gz.part.*' -print0 | xargs -P 3 -0 -I {file} sh -c "/usr/local/bin/supload -u $USER -k $PASS -d 7d $SELECTEL_CONTAINER/backup/$(date '+%Y-%m-%d')/ {file} && /bin/rm -f {file}"
        sleep 5
    fi
done < <(/usr/bin/mysql -u root -e "show databases" | cut -f1)
